Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758615Ab2AMRlJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jan 2012 12:41:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12534 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751230Ab2AMRlG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jan 2012 12:41:06 -0500
Message-ID: <1326476372.4342.1.camel@localhost>
Subject: Re: [PATCH v3 2/3] seccomp_filters: system call filtering using BPF
From: Eric Paris <eparis@redhat.com>
To: Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        john.johansen@canonical.com, serge.hallyn@canonical.com,
        coreyb@linux.vnet.ibm.com, pmoore@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, amwang@redhat.com, oleg@redhat.com,
        ak@linux.intel.com, eric.dumazet@gmail.com, gregkh@suse.de,
        dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk
Date: Fri, 13 Jan 2012 12:39:32 -0500
In-Reply-To: <1326411506-16894-2-git-send-email-wad@chromium.org>
References: <1326411506-16894-1-git-send-email-wad@chromium.org>
	 <1326411506-16894-2-git-send-email-wad@chromium.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-12 at 17:38 -0600, Will Drewry wrote:

> diff --git a/include/linux/seccomp.h b/include/linux/seccomp.h
> index cc7a4e9..0296871 100644
> --- a/include/linux/seccomp.h
> +++ b/include/linux/seccomp.h

> -typedef struct { int mode; } seccomp_t;
> +struct seccomp_filter;
> +/**
> + * struct seccomp_struct - the state of a seccomp'ed process
> + *
> + * @mode:
> + *     if this is 0, seccomp is not in use.
> + *             is 1, the process is under standard seccomp rules.
> + *             is 2, the process is only allowed to make system calls where
> + *                   associated filters evaluate successfully.
> + * @filter: Metadata for filter if using CONFIG_SECCOMP_FILTER.
> + *          @filter must only be accessed from the context of current as there
> + *          is no guard.
> + */
> +typedef struct seccomp_struct {
> +	int mode;
> +#ifdef CONFIG_SECCOMP_FILTER
> +	struct seccomp_filter *filter;
> +#endif
> +} seccomp_t;
>  
>  extern void __secure_computing(int);
>  static inline void secure_computing(int this_syscall)

Can we get rid of all of the typedef stuff?  I know you didn't add it
but now seems like a good time to follow typical kernel semantics if you
have to re-rev for some other reason.

-Eric

