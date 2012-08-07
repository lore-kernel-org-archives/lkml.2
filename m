Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756434Ab2HGUKg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 16:10:36 -0400
Received: from 8bytes.org ([85.214.48.195]:52433 "EHLO mail.8bytes.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752883Ab2HGUKf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 16:10:35 -0400
Date: Tue, 7 Aug 2012 22:10:30 +0200
From: Joerg Roedel <joro@8bytes.org>
To: Seth Forshee <seth.forshee@canonical.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Len Brown <lenb@kernel.org>,
        Joerg Roedel <joerg.roedel@amd.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Yinghai Lu <yinghai@kernel.org>
Subject: Re: IRQ remapping problem on Macbook Air 5,1
Message-ID: <20120807201030.GJ1917@8bytes.org>
References: <20120807194837.GB23829@thinkpad-t410>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120807194837.GB23829@thinkpad-t410>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-DSPAM-Result: Whitelisted
X-DSPAM-Processed: Tue Aug  7 22:10:32 2012
X-DSPAM-Confidence: 0.9978
X-DSPAM-Probability: 0.0000
X-DSPAM-Signature: 5021763820421431517015
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Seth,

On Tue, Aug 07, 2012 at 02:48:37PM -0500, Seth Forshee wrote:
> This machine has a bug in its ACPI tables that's causing it to fail to
> boot unless intremap=off is passed to the kernel. The MADT defines a
> single IOAPIC with id 2, but the remapping unit defined in DMAR matches
> id 0. Thus interrupt remapping fails, and the kernel panics with the
> message "timer doesn't work through Interrupt-remapped IO-APIC." If I
> force the use of the non-matching ir hardware for the IOAPIC everything
> seems to works fine. dmesg for the working boot is below.

There are AMD systems with similar problems. For example I had a system
with 2 IO-APICs but only one was described in the IOMMU ACPI table.

> I'm looking at how to make this machine able to boot by default. OS X
> obviously boots, and Windows presumably boots as well since Apple
> officially supports running Windows on its hardware.

These operating systems probably don't support interrupt remapping, or
the IOMMU at all.

> I've got a patch to leave IRQ remapping disabled whenever any IOAPIC
> does not have a matching ir hardware unit. This gets it to boot, but I
> thought I'd check and see whether anyone had any better ideas for how to
> fix this.

This is exactly how I fixed this issue on the AMD side too. Mind to
submit the patch?


Thanks,

	Joerg


