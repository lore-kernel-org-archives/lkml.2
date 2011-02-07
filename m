Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754952Ab1BGVfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 16:35:09 -0500
Received: from cavan.codon.org.uk ([93.93.128.6]:47051 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753313Ab1BGVfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 16:35:07 -0500
Date: Mon, 7 Feb 2011 21:34:26 +0000
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Bjorn Helgaas <bjorn.helgaas@hp.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, dri-devel@lists.freedesktop.org,
        akpm@linux-foundation.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, rpurdie@rpsys.net,
        Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 5/5] ACPI: Tie ACPI backlight devices to PCI devices if
	possible
Message-ID: <20110207213426.GA23843@srcf.ucam.org>
References: <1295033065-13450-1-git-send-email-mjg@redhat.com> <20110206230558.GA23889@srcf.ucam.org> <201102070034.43691.rjw@sisk.pl> <201102071432.35656.bjorn.helgaas@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102071432.35656.bjorn.helgaas@hp.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 07, 2011 at 02:32:35PM -0700, Bjorn Helgaas wrote:

> I'm not familiar with video devices, but I agree, this situation does
> feel broken.  Is it the case that there's a PCI device as well as an
> ACPI namespace Device for the same piece of hardware?  If so, I assume
> the reason for the ACPI Device is to have a "standard" interface to
> a platform knob like backlight control.
> 
> In that case, it seems like we should rely on PCI for enumeration and
> driver binding, have some sort of hook the PCI driver could use to
> twiddle that knob (using the ACPI methods), and make the ACPI Device
> ineligible for driver binding.  In other words, it sounds like part
> of the problem is that we have two drivers binding to what's really
> a single piece of hardware.

Part of the problem is that ACPI video devices aren't inherently PCI 
devices.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
