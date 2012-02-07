Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab2BGXRd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Feb 2012 18:17:33 -0500
Received: from mx1.redhat.com ([209.132.183.28]:39511 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753992Ab2BGXRc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Feb 2012 18:17:32 -0500
Date: Tue, 7 Feb 2012 17:19:24 -0500
From: Vivek Goyal <vgoyal@redhat.com>
To: Don Zickus <dzickus@redhat.com>
Cc: "Eric W. Biederman" <ebiederm@xmission.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        kexec-list <kexec@lists.infradead.org>
Subject: Re: [PATCH] x86, kdump: No need to disable ioapic in crash path
Message-ID: <20120207221924.GH6346@redhat.com>
References: <1328206323-25580-1-git-send-email-dzickus@redhat.com>
 <m1r4ycsts1.fsf@fess.ebiederm.org>
 <20120207215741.GD5650@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120207215741.GD5650@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 07, 2012 at 04:57:41PM -0500, Don Zickus wrote:
> On Thu, Feb 02, 2012 at 03:24:46PM -0800, Eric W. Biederman wrote:
> > > Eric, brought up a point that because the boot code was restructured we may
> > > not need to disable the io apic any more in the crash path.  The original
> > > concern that led to the development of disable_IO_APIC, was that the TSC
> > > calibration on boot up relied on the PIT timer for reference.  Access
> > > to the PIT required 8259 interrupts to be working.  This wouldn't work
> > > if the ioapic needed to be configured.  So on panic path, the ioapic was
> > > reconfigured to use virtual wire mode to allow the 8259 to passthrough.
> > 
> > A small clarification originally it was the jiffies calibration that
> > would fail if we could cause the PIT to generate interrupts through the
> > 8259.  The boot would then hang at calibrating jiffies.
> 
> Ok.  Thanks!

So now what has changed? Do we setup LAPIC and IOAPIC early enough to
receive PIT interrupts in regular mode (non-virtual wire mode) or
something else?

Thanks
Vivek
