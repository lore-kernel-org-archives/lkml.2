Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933857Ab1ION1A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 09:27:00 -0400
Received: from mx1.redhat.com ([209.132.183.28]:64719 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933811Ab1ION0z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 09:26:55 -0400
Date: Thu, 15 Sep 2011 10:26:14 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Eric B Munson <emunson@mgebm.net>
Cc: Anthony Liguori <anthony@codemonkey.ws>, avi@redhat.com,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, arnd@arndb.de,
        riel@redhat.com, kvm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, kvm-ppc@vger.kernel.org,
        aliguori@us.ibm.com, raharper@us.ibm.com, kvm-ia64@vger.kernel.org,
        Glauber Costa <glommer@gmail.com>, mjwolf@us.ibm.com
Subject: Re: [PATCH 0/4] Avoid soft lockup message when KVM is stopped by host
Message-ID: <20110915132614.GA7101@amt.cnet>
References: <1314660435-23293-1-git-send-email-emunson@mgebm.net>
 <20110830122630.GA19450@amt.cnet>
 <4E5FDBDC.2030302@codemonkey.ws>
 <6c387b0ab0b091253c1a1488dd625b94@mgebm.net>
 <20110909132955.GA19459@amt.cnet>
 <20110913204955.GD9096@mgebm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110913204955.GD9096@mgebm.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 04:49:55PM -0400, Eric B Munson wrote:
> On Fri, 09 Sep 2011, Marcelo Tosatti wrote:
> 
> > On Thu, Sep 01, 2011 at 02:27:49PM -0600, emunson@mgebm.net wrote:
> > > On Thu, 01 Sep 2011 14:24:12 -0500, Anthony Liguori wrote:
> > > >On 08/30/2011 07:26 AM, Marcelo Tosatti wrote:
> > > >>On Mon, Aug 29, 2011 at 05:27:11PM -0600, Eric B Munson wrote:
> > > >>>Currently, when qemu stops a guest kernel that guest will
> > > >>>issue a soft lockup
> > > >>>message when it resumes.  This set provides the ability for
> > > >>>qemu to comminucate
> > > >>>to the guest that it has been stopped.  When the guest hits
> > > >>>the watchdog on
> > > >>>resume it will check if it was suspended before issuing the
> > > >>>warning.
> > > >>>
> > > >>>Eric B Munson (4):
> > > >>>   Add flag to indicate that a vm was stopped by the host
> > > >>>   Add functions to check if the host has stopped the vm
> > > >>>   Add generic stubs for kvm stop check functions
> > > >>>   Add check for suspended vm in softlockup detector
> > > >>>
> > > >>>  arch/x86/include/asm/pvclock-abi.h |    1 +
> > > >>>  arch/x86/include/asm/pvclock.h     |    2 ++
> > > >>>  arch/x86/kernel/kvmclock.c         |   14 ++++++++++++++
> > > >>>  include/asm-generic/pvclock.h      |   14 ++++++++++++++
> > > >>>  kernel/watchdog.c                  |   12 ++++++++++++
> > > >>>  5 files changed, 43 insertions(+), 0 deletions(-)
> > > >>>  create mode 100644 include/asm-generic/pvclock.h
> > > >>>
> > > >>>--
> > > >>>1.7.4.1
> > > >>
> > > >>How is the host supposed to set this flag?
> > > >>
> > > >>As mentioned previously, if you save save/restore the offset
> > > >>added to
> > > >>kvmclock on stop/cont (and the TSC MSR, forgot to mention that), no
> > > >>paravirt infrastructure is required. Which means the issue is
> > > >>also fixed
> > > >>for older guests.
> > > >
> 
> Marcelo,
> 
> I think that stopping the TSC is the wrong approach because it will break time
> between the two systems so timething that expects the monotonic clock to move
> consistently will be wrong.

In case the VM stops for whatever reason, the host system is not
supposed to adjust time related hardware state to compensate, in an
attempt to present apparent continuous time.

If you save a VM and then restore it later, it is the guest
responsability to adjust its time representation.

QEMU exposing continuous TSC and kvmclock state between "stop" and
"cont" should not be a reason to introduce new paravirt infrastructure.

>  IMO, messing with the TSC at run time to avoid a watchdog message
> is the wrong solution, better to teach the watchdog to ignore this
> special case.

OK then, it is not a harmful addition, can you post the QEMU patches to
set the "ignore watchdog" bit.

