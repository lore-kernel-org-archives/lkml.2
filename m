Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751516Ab2LSP24 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 10:28:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:37028 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753706Ab2LSP2t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 10:28:49 -0500
From: Paul Moore <pmoore@redhat.com>
To: Corey Bryant <coreyb@linux.vnet.ibm.com>, Will Drewry <wad@chromium.org>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        jmorris@namei.org, otubo@linux.vnet.ibm.com,
        Kees Cook <keescook@chromium.org>
Subject: Re: [PATCH 1/3] seccomp: Add SECCOMP_RET_INFO return value
Date: Wed, 19 Dec 2012 10:28:42 -0500
Message-ID: <34771527.GTMPbzeFu2@sifl>
Organization: Red Hat
User-Agent: KMail/4.9.4 (Linux/3.6.11-gentoo; KDE/4.9.4; x86_64; ; )
In-Reply-To: <50D1D58D.6060408@linux.vnet.ibm.com>
References: <1355867449-3209-1-git-send-email-coreyb@linux.vnet.ibm.com> <CABqD9hbw2kT1PYiHRNSq+xVEDQdYPVqrJv78Sa4DiSnvWJ97cQ@mail.gmail.com> <50D1D58D.6060408@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, December 19, 2012 09:56:13 AM Corey Bryant wrote:
> On 12/18/2012 05:22 PM, Will Drewry wrote:
> > while others I've spoken with have been using the audit path to track
> > denied values -- not so great for soft-failures :)
> 
> The audit path would work too but if I understand I think you can only
> learn one syscall per execution.  The nice thing about SECCOMP_RET_INFO
> is that you can easily learn all the syscalls in one execution.

Another quick point about the audit log: on some systems, e.g. tightly secured 
SELinux systems, the audit log is only accessible via a very privileged user 
(Will hints at this below).  Normal users do not have access to, and therefore 
can't make use of, the seccomp related audit records.

> > That aside, I worry that pr_info is the wrong place for a random user
> > on the machine to log to for this, but I may be wrong, rather than a
> > dedicated ringbufffer, etc.  So if this is for a user with privs, then
> > a SECCOMP_RET_AUDIT might make sense.  Feedback to a local user seems
> > tricky in general. I don't know :)  I just decided to deal with it in
> > userland even if it is slightly painful.
> 
> That's a good point.  I don't know which option is better either so if
> anyone else could weigh in on the better approach I'd appreciate it.

I agree with Will's statement about better to deal with the problem in 
userspace when possible, but as Corey pointed out, our experiences with QEMU 
have demonstrated that dealing with the problem exclusively in userspace just 
isn't practical in every case.

Syslog might not be the answer, but RET_TRAP and the audit log aren't very 
good answers either.

-- 
paul moore
security and virtualization @ redhat

