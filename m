Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755475Ab2CEQma (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 11:42:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:53912 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752440Ab2CEQm2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 11:42:28 -0500
Date: Mon, 5 Mar 2012 13:39:43 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Eric B Munson <emunson@mgebm.net>
Cc: avi@redhat.com, mingo@redhat.com, hpa@zytor.com, ryanh@linux.vnet.ibm.com,
        aliguori@us.ibm.com, kvm@vger.kernel.org, linux-arch@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4 V13] Avoid soft lockup message when KVM is stopped by
 host
Message-ID: <20120305163943.GA10338@amt.cnet>
References: <1328713666-11424-1-git-send-email-emunson@mgebm.net>
 <20120214152931.GA6881@mgebm.net>
 <20120214153836.GA21106@amt.cnet>
 <20120214155013.GB6881@mgebm.net>
 <20120214161009.GA21515@amt.cnet>
 <20120214211720.GC6881@mgebm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120214211720.GC6881@mgebm.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 14, 2012 at 04:17:20PM -0500, Eric B Munson wrote:
> On Tue, 14 Feb 2012, Marcelo Tosatti wrote:
> 
> > On Tue, Feb 14, 2012 at 10:50:13AM -0500, Eric B Munson wrote:
> > > On Tue, 14 Feb 2012, Marcelo Tosatti wrote:
> > > 
> > > > On Tue, Feb 14, 2012 at 10:29:31AM -0500, Eric B Munson wrote:
> > > > > On Wed, 08 Feb 2012, Eric B Munson wrote:
> > > > > 
> > > > > > 
> > > > > > When a guest kernel is stopped by the host hypervisor it can look like a soft
> > > > > > lockup to the guest kernel.  This false warning can mask later soft lockup
> > > > > > warnings which may be real.  This patch series adds a method for a host
> > > > > > hypervisor to communicate to a guest kernel that it is being stopped.  The
> > > > > > final patch in the series has the watchdog check this flag when it goes to
> > > > > > issue a soft lockup warning and skip the warning if the guest knows it was
> > > > > > stopped.
> > > > > > 
> > > > > > It was attempted to solve this in Qemu, but the side effects of saving and
> > > > > > restoring the clock and tsc for each vcpu put the wall clock of the guest behind
> > > > > > by the amount of time of the pause.  This forces a guest to have ntp running
> > > > > > in order to keep the wall clock accurate.
> > > > > 
> > > > > Avi,
> > > > > 
> > > > > Is this set fit for merging or is there something else you want changed?
> > > > 
> > > > Eric,
> > > > 
> > > > On Message-ID: <20120210160536.GA23363@amt.cnet>, i asked:
> > > > 
> > > > How is the stub getting included for other architectures again?
> > > > 
> > > 
> > > Marcelo,
> > > 
> > > Sorry, I put out V13 to answer that.  There is a stub in asm-generic that was
> > > lost in the V11-V12 rebase.  This stub has be included in the V13 set.
> > > 
> > > Eric
> > 
> > Eric, 
> > 
> > I know the stub has been included in the series. But i am asking how 
> > it is #include'ed for other architectures? (can't see that).
> 
> Marcelo,
> 
> kernel/watchdog.c now includes linux/kvm_para.h which includes asm/kvm_para.h.
> The check_and_clear function is defined in arch include/asm/kvm_para.h or in
> asm-generic/kvm_para.h for any arch lacking the specific header in their asm
> include dir.  If I have misunderstood how these headers work, please let me
> know and I will fix it.

There is no automatic inclusion of asm-generic/ headers. You must create
kvm_para.h in each architecture's include/asm/ directory, #including
asm-generic/kvm_para.h.

