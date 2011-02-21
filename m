Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab1BUN55 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 08:57:57 -0500
Received: from 184-106-158-135.static.cloud-ips.com ([184.106.158.135]:43167
	"EHLO mail" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755917Ab1BUN5z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 08:57:55 -0500
Date: Mon, 21 Feb 2011 13:58:03 +0000
From: "Serge E. Hallyn" <serge@hallyn.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Daniel Lezcano <daniel.lezcano@free.fr>,
        "Serge E. Hallyn" <serge@hallyn.com>, Andrew Morton <akpm@osdl.org>,
        LSM <linux-security-module@vger.kernel.org>,
        James Morris <jmorris@namei.org>, Kees Cook <kees.cook@canonical.com>,
        containers@lists.linux-foundation.org,
        kernel list <linux-kernel@vger.kernel.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Alexey Dobriyan <adobriyan@gmail.com>,
        Michael Kerrisk <mtk.manpages@gmail.com>, xemul@parallels.com,
        dhowells@redhat.com
Subject: Re: [PATCH 1/4] userns: let clone_uts_ns() handle setting
 uts->user_ns
Message-ID: <20110221135803.GA15871@mail.hallyn.com>
References: <20110221040156.GA12580@mail.hallyn.com>
 <4D623886.3010505@free.fr>
 <20110221134129.GA15563@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110221134129.GA15563@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Oleg Nesterov (oleg@redhat.com):
> On 02/21, Daniel Lezcano wrote:
> >
> > On 02/21/2011 05:01 AM, Serge E. Hallyn wrote:
> >> To do so we need to pass in the task_struct who'll get the utsname,
> >> so we can get its user_ns.
> >>
> >> -extern struct uts_namespace *copy_utsname(unsigned long flags,
> >> -					struct uts_namespace *ns);
> >> +extern struct uts_namespace *copy_utsname(struct task_struct *tsk,
> >> +					  unsigned long flags,
> >> +					  struct uts_namespace *ns);
> >
> > Why don't we pass 'user_ns' instead of 'tsk' ? that will look
> > semantically clearer for the caller no ?
> > (example below).
> > ...
> >
> > new_nsp->uts_ns = copy_utsname(flags, tsk->nsproxy->uts_ns, task_cred_xxx(tsk, user)->user_ns);
> 
> To me tsk looks more readable, I mean
> 
> 	new_nsp->uts_ns = copy_utsname(flags, tsk);
> 
> copy_utsname() can find both uts_ns and user_ns looking at task_strcut.

Uh, yeah.  I should remove the 'ns' argument there shouldn't I.

Daniel, does that sway your opinion then?

thanks,
-serge
