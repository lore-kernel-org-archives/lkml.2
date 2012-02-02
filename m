Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932306Ab2BBP3V (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 10:29:21 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:53920 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932126Ab2BBP3T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 10:29:19 -0500
Date: Thu, 2 Feb 2012 09:29:00 -0600
From: "Serge E. Hallyn" <serge.hallyn@canonical.com>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk, indan@nul.nu,
        mcgrathr@chromium.org
Subject: Re: [PATCH v6 1/3] seccomp: kill the seccomp_t typedef
Message-ID: <20120202152900.GA4583@sergelap>
References: <1327788715-24076-1-git-send-email-wad@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1327788715-24076-1-git-send-email-wad@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Will Drewry (wad@chromium.org):
> Replaces the seccomp_t typedef with seccomp_struct to match modern
> kernel style.

(sorry, I'm a bit behind on list)

You were going to switch this to 'struct seccomp' right?

> Signed-off-by: Will Drewry <wad@chromium.org>
> ---
>  include/linux/sched.h   |    2 +-
>  include/linux/seccomp.h |   10 ++++++----
>  2 files changed, 7 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/sched.h b/include/linux/sched.h
> index 4032ec1..288b5cb 100644
> --- a/include/linux/sched.h
> +++ b/include/linux/sched.h
> @@ -1418,7 +1418,7 @@ struct task_struct {
>  	uid_t loginuid;
>  	unsigned int sessionid;
>  #endif
> -	seccomp_t seccomp;
> +	struct seccomp_struct seccomp;
>  
>  /* Thread group tracking */
>     	u32 parent_exec_id;
> diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
> index cc7a4e9..171ab66 100644
> --- a/include/linux/seccomp.h
> +++ b/include/linux/seccomp.h
> @@ -7,7 +7,9 @@
>  #include <linux/thread_info.h>
>  #include <asm/seccomp.h>
>  
> -typedef struct { int mode; } seccomp_t;
> +struct seccomp_struct {
> +	int mode;
> +};
>  
>  extern void __secure_computing(int);
>  static inline void secure_computing(int this_syscall)
> @@ -19,7 +21,7 @@ static inline void secure_computing(int this_syscall)
>  extern long prctl_get_seccomp(void);
>  extern long prctl_set_seccomp(unsigned long);
>  
> -static inline int seccomp_mode(seccomp_t *s)
> +static inline int seccomp_mode(struct seccomp_struct *s)
>  {
>  	return s->mode;
>  }
> @@ -28,7 +30,7 @@ static inline int seccomp_mode(seccomp_t *s)
>  
>  #include <linux/errno.h>
>  
> -typedef struct { } seccomp_t;
> +struct seccomp_struct { };
>  
>  #define secure_computing(x) do { } while (0)
>  
> @@ -42,7 +44,7 @@ static inline long prctl_set_seccomp(unsigned long arg2)
>  	return -EINVAL;
>  }
>  
> -static inline int seccomp_mode(seccomp_t *s)
> +static inline int seccomp_mode(struct seccomp_struct *s)
>  {
>  	return 0;
>  }
> -- 
> 1.7.5.4
> 
