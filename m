Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754895Ab1BGVcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 16:32:41 -0500
Received: from g1t0028.austin.hp.com ([15.216.28.35]:5032 "EHLO
	g1t0028.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992Ab1BGVck (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 16:32:40 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH 5/5] ACPI: Tie ACPI backlight devices to PCI devices if possible
Date: Mon, 7 Feb 2011 14:32:35 -0700
User-Agent: KMail/1.13.5 (Linux/2.6.32-26-generic; KDE/4.4.5; x86_64; ; )
Cc: Matthew Garrett <mjg59@srcf.ucam.org>, dri-devel@lists.freedesktop.org,
        akpm@linux-foundation.org, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, rpurdie@rpsys.net,
        Len Brown <lenb@kernel.org>
References: <1295033065-13450-1-git-send-email-mjg@redhat.com> <20110206230558.GA23889@srcf.ucam.org> <201102070034.43691.rjw@sisk.pl>
In-Reply-To: <201102070034.43691.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201102071432.35656.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday, February 06, 2011 04:34:43 pm Rafael J. Wysocki wrote:
> 
> Still, IMO, there is a design issue in the entire ACPI subsystem, because the
> idea of "ACPI device" really is not well defined, so to speak.  Sometimes
> they are just "device interfaces" that can be used to ask the firmware for
> something (like in the case of the "ACPI devices" associated with PCI devices)
> and sometimes they are "real devices" with real drivers.  The video device
> apparently wants to be both at the same time, which is even more confusing. :-)

I'm not familiar with video devices, but I agree, this situation does
feel broken.  Is it the case that there's a PCI device as well as an
ACPI namespace Device for the same piece of hardware?  If so, I assume
the reason for the ACPI Device is to have a "standard" interface to
a platform knob like backlight control.

In that case, it seems like we should rely on PCI for enumeration and
driver binding, have some sort of hook the PCI driver could use to
twiddle that knob (using the ACPI methods), and make the ACPI Device
ineligible for driver binding.  In other words, it sounds like part
of the problem is that we have two drivers binding to what's really
a single piece of hardware.

Bjorn
