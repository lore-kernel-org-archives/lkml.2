Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932498Ab2BBPdb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 10:33:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:23963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081Ab2BBPd2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 10:33:28 -0500
Date: Thu, 2 Feb 2012 10:33:20 -0500
From: Don Zickus <dzickus@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, vgoyal@redhat.com,
        kexec-list <kexec@lists.infradead.org>
Subject: Re: [PATCH] x86, kdump, ioapic: Fix kdump race with migrating irq
Message-ID: <20120202153320.GM5650@redhat.com>
References: <1328045114-4489-1-git-send-email-dzickus@redhat.com>
 <m1ipjr4jaa.fsf@fess.ebiederm.org>
 <20120131222751.GE5650@redhat.com>
 <m1vcnr33c8.fsf@fess.ebiederm.org>
 <20120201230414.GL5650@redhat.com>
 <m1ehuevx12.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ehuevx12.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 01, 2012 at 05:34:01PM -0800, Eric W. Biederman wrote:
> > Talking to folks here and trying to read the code it seems like the PIT
> > stuff is delayed until after the IOAPIC is configured using Fast TSC
> > calibration as a mechanism to work around the PIT??
> >
> > I attached the output of the Pentium4 when kdumping.  Not sure what to
> > really look for to verify the PIC is being skipped.  Perhaps you know?
> 
> The important part is the kexec on panic works without shutting down
> the ioapic.  There should be no corner case issues it should either
> work it should fail.
> 
> The problem used to be that we always would initialize the PIT interrupt
> in the 8259 interrupt controller before we would initialize the ioapics
> and that would kill the boot.
> 
> If I have read your testing correctly you are apparently booting in the
> kexec on panic case.  That seems to be successful to me.  So we should
> be able to just remove the ioapic shutdown code from
> machine_crash_shutdown as it is no longer needed.
> 
> Thank you for being careful and testing on a number of different
> platforms. 

No problem.  I was actually trying to find machines that did not have
ioapics to make sure they still worked (it's hard!).

So if I test on a couple more machines (hopefully one without an ioapic),
can I get your ack?  Or is there something else you would like me to do to
verify things are working correctly?

I will also need your help writing the changelog such that people
understand why removing that line is safe now.

> 
> The only case I can think that won't work without ioapic disables
> is using a crash kernel that doesn't emable the ioapics.

Ok.  I can see that.  Would you agree that scenario is not a very sane
case? :-) Does not using the ioapic really save you anything?

Otherwise the alternative is to use my original patch.

Thanks for the help.

Cheers,
Don

> 
> Eric
