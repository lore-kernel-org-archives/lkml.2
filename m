Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966130Ab2EORhk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 13:37:40 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:46153 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965421Ab2EORhj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 13:37:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: Re: [PATCH]: In kernel hibernation, suspend to both
Date: Tue, 15 May 2012 19:42:36 +0200
User-Agent: KMail/1.13.6 (Linux/3.4.0-rc7+; KDE/4.6.0; x86_64; ; )
Cc: Bojan Smojver <bojan@rexursive.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Linux PM list <linux-pm@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>, bp@alien8.de
References: <Pine.LNX.4.44L0.1205132212070.5628-100000@netrider.rowland.org> <1337039996.1628.9.camel@shrek.rexursive.com> <4FB269BF.3090801@linux.vnet.ibm.com>
In-Reply-To: <4FB269BF.3090801@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201205151942.36335.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, May 15, 2012, Srivatsa S. Bhat wrote:
> On 05/15/2012 05:29 AM, Bojan Smojver wrote:
> 
> > On Mon, 2012-05-14 at 21:47 +1000, Bojan Smojver wrote:
> >> No. That hangs my box.
> >>
> >> This triggers a bug in workqueues code (essentially the same as the
> >> previous patch, except for sys_sync() not being done):
> > 
> > Alan/Srivatsa,
> > 
> > Coming back to the explanation of how this whole thing works, it would
> > seem that at the point of image writing all devices are fully functional
> > (not just some, as I mistakenly believed). However, the processes are
> > supposed to be already frozen, right? Calling suspend_prepare(), which
> > will essentially try to freeze the processes and kernel threads, seems
> > like the wrong thing to do.
> > 
> > Did you guys mean that we should be calling
> > pm_notifier_call_chain(PM_SUSPEND_PREPARE) only here?
> > 
> 
> 
> Exactly! And also arrange for the corresponding PM_POST_SUSPEND notification
> to happen at the end of suspend-to-ram stage...

Actually, no.  The notifiers are supposed to be called when user space is
available, otherwise some things will break badly (firmware loading for
one example IIRC).

So, I think we should pretend that this is all hibernation and, even if
the suspend to RAM phase succeeds, run PM_POST_HIBERNATION notifiers (which
I suppose is what the first Bojan's patch did, right?).

Thanks,
Rafael
