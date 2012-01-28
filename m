Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752502Ab2A1LPh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jan 2012 06:15:37 -0500
Received: from mx1.redhat.com ([209.132.183.28]:25339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751992Ab2A1LPf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jan 2012 06:15:35 -0500
Message-ID: <1327749226.15441.4.camel@cr0>
Subject: Re: [PATCH v5 1/3] seccomp: kill the seccomp_t typedef
From: Cong Wang <amwang@redhat.com>
To: Will Drewry <wad@chromium.org>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        keescook@chromium.org, john.johansen@canonical.com,
        serge.hallyn@canonical.com, coreyb@linux.vnet.ibm.com,
        pmoore@redhat.com, eparis@redhat.com, djm@mindrot.org,
        torvalds@linux-foundation.org, segoon@openwall.com,
        rostedt@goodmis.org, jmorris@namei.org, scarybeasts@gmail.com,
        avi@redhat.com, penberg@cs.helsinki.fi, viro@zeniv.linux.org.uk,
        luto@mit.edu, mingo@elte.hu, akpm@linux-foundation.org, khilman@ti.com,
        borislav.petkov@amd.com, oleg@redhat.com, ak@linux.intel.com,
        eric.dumazet@gmail.com, dhowells@redhat.com, daniel.lezcano@free.fr,
        linux-fsdevel@vger.kernel.org, linux-security-module@vger.kernel.org,
        olofj@chromium.org, mhalcrow@google.com, dlaor@redhat.com,
        corbet@lwn.net, alan@lxorguk.ukuu.org.uk, indan@nul.nu,
        mcgrathr@chromium.org
Date: Sat, 28 Jan 2012 19:13:46 +0800
In-Reply-To: <CABqD9hZ9StgL_v-Z+hpGnbC6Ggu1N3hWXfV_gqUu6caCbcMCtQ@mail.gmail.com>
References: <1327706681-11959-1-git-send-email-wad@chromium.org>
	 <20120127234140.GA19407@suse.de>
	 <CABqD9hZ9StgL_v-Z+hpGnbC6Ggu1N3hWXfV_gqUu6caCbcMCtQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-01-27 at 17:47 -0600, Will Drewry wrote:
> On Fri, Jan 27, 2012 at 5:41 PM, Greg KH <gregkh@suse.de> wrote:
> > On Fri, Jan 27, 2012 at 05:24:39PM -0600, Will Drewry wrote:
> >> Replaces the seccomp_t typedef with seccomp_struct to match modern
> >> kernel style.
> >>
> >> Signed-off-by: Will Drewry <wad@chromium.org>
> >> ---
> >>  include/linux/sched.h   |    2 +-
> >>  include/linux/seccomp.h |   10 ++++++----
> >>  2 files changed, 7 insertions(+), 5 deletions(-)
> >>
> >> diff --git a/include/linux/sched.h b/include/linux/sched.h
> >> index 4032ec1..288b5cb 100644
> >> --- a/include/linux/sched.h
> >> +++ b/include/linux/sched.h
> >> @@ -1418,7 +1418,7 @@ struct task_struct {
> >>       uid_t loginuid;
> >>       unsigned int sessionid;
> >>  #endif
> >> -     seccomp_t seccomp;
> >> +     struct seccomp_struct seccomp;
> >
> > Isn't 'struct seccomp_struct' a bit redundant?
> >
> > How about a simple 'struct seccomp' instead?
> 
> Works for me - I can't recall why that seemed to make sense (other
> than the user of similar redundant names elsewhere).

seccomp_struct for a type is okay, but you also have:

+#define seccomp_struct_init_task(_seccomp) do { } while (0);
+#define seccomp_struct_fork(_tsk, _orig) do { } while (0);
+#define seccomp_struct_free_task(_seccomp) do { } while (0);

in patch 2/3, "struct" in these function/macro names is redundant.

Thanks.


