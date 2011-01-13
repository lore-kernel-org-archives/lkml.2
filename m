Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757277Ab1AMRj2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jan 2011 12:39:28 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:57345 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756571Ab1AMRj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jan 2011 12:39:26 -0500
Date: Thu, 13 Jan 2011 17:39:21 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Manoj Iyer <manoj.iyer@canonical.com>, linux-kernel@vger.kernel.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] Quirk to fix suspend/resume on Lenovo Edge 11,13,14,15
Message-ID: <20110113173921.GA22823@srcf.ucam.org>
References: <1294934542-2411-1-git-send-email-manoj.iyer@canonical.com> <1294934542-2411-2-git-send-email-manoj.iyer@canonical.com> <20110113164616.GB21289@srcf.ucam.org> <alpine.LFD.2.00.1101131808450.2678@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1101131808450.2678@localhost6.localdomain6>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 13, 2011 at 06:10:01PM +0100, Thomas Gleixner wrote:
> On Thu, 13 Jan 2011, Matthew Garrett wrote:
> 
> > On Thu, Jan 13, 2011 at 10:02:22AM -0600, Manoj Iyer wrote:
> > > Set acpi_skip_timer_override to force ignoring BIOS
> > > IRQ0 pin2 override. This fixes resume from suspend on
> > > AMD based ThinkPad Edge 11,13,14 and 15.
> > 
> > This was originally there because of a quirk in some ati chipsets, 
> > coupled with DSDT insanity on HP's part. The Thinkpad Edges seem to be 
> > Intel machines, so it's not the same underlying issue. Do we have any 
> 
> The patch description above talks explictely about AMD based ThinkPad
> Edge. So it might be as well the same underlying problem.

I'm sorry, I misread that completely. The reason for the extra quirk on 
the HPs was down to their DSDT setting thermal trip points incorrectly 
if the override weren't ignored - it would trigger at boot time, not 
after suspend/resume. In theory I think that should be handled by the 
chipset-specific quirk code already, with the DMI list as a backup. It 
may be that we need to look at the chipset quirk code?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
