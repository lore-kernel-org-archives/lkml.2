Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752270Ab1LSUpJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 15:45:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38878 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751974Ab1LSUoz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 15:44:55 -0500
Date: Mon, 19 Dec 2011 15:50:47 -0200
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Eric B Munson <emunson@mgebm.net>, mingo@redhat.com, hpa@zytor.com,
        arnd@arndb.de, ryanh@linux.vnet.ibm.com, aliguori@us.ibm.com,
        jeremy.fitzhardinge@citrix.com, levinsasha928@gmail.com,
        Jan Kiszka <jan.kiszka@siemens.com>, kvm@vger.kernel.org,
        linux-arch@vger.kernel.org, x86@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/5 V5] Avoid soft lockup message when KVM is stopped by
 host
Message-ID: <20111219175047.GA17347@amt.cnet>
References: <1323116344-17911-1-git-send-email-emunson@mgebm.net>
 <4EDF7B0D.4060001@redhat.com>
 <20111214121622.GB18317@amt.cnet>
 <4EE8B53C.6070502@redhat.com>
 <20111214182101.GB21945@amt.cnet>
 <4EE9CA1C.3010801@redhat.com>
 <20111216093149.GA26982@amt.cnet>
 <4EEF351E.8040002@redhat.com>
 <20111219161108.GA15848@amt.cnet>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111219161108.GA15848@amt.cnet>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 19, 2011 at 02:11:08PM -0200, Marcelo Tosatti wrote:
> On Mon, Dec 19, 2011 at 02:59:10PM +0200, Avi Kivity wrote:
> > On 12/16/2011 11:31 AM, Marcelo Tosatti wrote:
> > > > >
> > > > > Slow enough that progress of the watchdog thread is unable to keep up
> > > > > with timer interrupt processing. This is considered a hang and
> > > > > should be reported.
> > > > 
> > > > It's not a guest hang though!
> > >
> > > No, but your host system is in such a load state that for the sake of
> > > system usability you better print out a warning message.
> > 
> > What's the point in printing it in the guest?  The guest can't observe
> > host conditions.
> >
> > > I don't see the advantage of preempt notifiers over the simple, paravirt
> > > solution proposed? Note kvmclock is already paravirt.
> > 
> > Right.
> > 
> > > What do you want to be done in preempt notifiers? Measure what to
> > > consider setting this flag?
> > 
> > Preemption while TASK_RUNNING or TASK_UNINTERRUPTIBLE.
> 
> Maybe it is good (not sure), need to look into schedstats and think of
> cases that would break legitimate guest hangs. And it probably also
> affects the position of clearing the flag on the guest side as its 
> currently done in Eric's patchset.

Is the task going to be TASK_UNINTERRUPTIBLE with SIGSTOP? Don't think
so. 

Note "Preemption while TASK_RUNNING or TASK_UNINTERRUPTIBLE" is not
functional for guest-paused-via-QEMU-monitor case.

