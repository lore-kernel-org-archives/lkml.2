Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755448Ab2AaW14 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jan 2012 17:27:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:17998 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752916Ab2AaW1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jan 2012 17:27:55 -0500
Date: Tue, 31 Jan 2012 17:27:51 -0500
From: Don Zickus <dzickus@redhat.com>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: x86@kernel.org, LKML <linux-kernel@vger.kernel.org>, vgoyal@redhat.com,
        kexec-list <kexec@lists.infradead.org>
Subject: Re: [PATCH] x86, kdump, ioapic: Fix kdump race with migrating irq
Message-ID: <20120131222751.GE5650@redhat.com>
References: <1328045114-4489-1-git-send-email-dzickus@redhat.com>
 <m1ipjr4jaa.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1ipjr4jaa.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 31, 2012 at 02:08:29PM -0800, Eric W. Biederman wrote:
> > The problem is that although kdump tries to shutdown minimal hardware,
> > it still needs to disable the IO APIC.  This requires spinlocks which
> > may be held by another cpu.  This other cpu is being held infinitely in
> > an NMI context by kdump in order to serialize the crashing path.  Instant
> > deadlock.
> 
> Can you test to see if kexec on panic still needs to disable the IO
> APIC.  Last I looked we were close if not all of the way there to not
> needing to boot the kernel in pic mode?

Ok, so you just blindly remove disable_IO_APIC from
native_machine_crash_shutdown and re-run some panic tests on various
machines?  What about the disable_IO_APIC path in native_machine_shutdown?

Also, where could I look to see if that work was done?  Is that in the
ioapic setup code?

> 
> If we can skip the ioapic disable entirely we should be much more
> robust.

Agreed.

Cheers,
Don
