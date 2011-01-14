Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757940Ab1ANQKv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jan 2011 11:10:51 -0500
Received: from g5t0008.atlanta.hp.com ([15.192.0.45]:19705 "EHLO
	g5t0008.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757651Ab1ANQKq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jan 2011 11:10:46 -0500
From: Bjorn Helgaas <bjorn.helgaas@hp.com>
To: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: [PATCH 1/1] PCI: tune up ICH4 quirk for broken BIOSes
Date: Fri, 14 Jan 2011 09:10:05 -0700
User-Agent: KMail/1.13.2 (Linux/2.6.32-26-generic; KDE/4.4.2; x86_64; ; )
Cc: Linus Torvalds <torvalds@linux-foundation.org>, jbarnes@virtuousgeek.org,
        linux-pci@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Thomas Renninger <trenn@suse.de>
References: <1294327066-23518-1-git-send-email-jslaby@suse.cz> <AANLkTinN40GMRL3bJ7LKDmhCYK1AYZfQ+mVYwxDP1ZQe@mail.gmail.com> <4D3025F4.6020001@gmail.com>
In-Reply-To: <4D3025F4.6020001@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101140910.07154.bjorn.helgaas@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 14, 2011 03:31:16 am Jiri Slaby wrote:
> On 01/14/2011 01:15 AM, Linus Torvalds wrote:
> > On Thu, Jan 13, 2011 at 3:19 PM, Bjorn Helgaas <bjorn.helgaas@hp.com> wrote:
> >>
> >> I think we're back to the question of why we have the ICH4 quirk in
> >> the first place, and I don't know the answer to that.
> > 
> > Iirc, there were several laptops that didn't have the ACPI region
> > mentioned in any of the regular places, and we'd allocate the PCMCIA
> > IO region on top of them. The machine would boot, but if anybody ever
> > inserted a PCCard into the machine, the first access to the IO region
> > would generally just halt it (because it was trying to read the
> > PCCard, but the APCI region decodes first, and then the read from that
> > usually put the CPU in a sleep state that it would never wake up from
> > for obvious reasons).
> > 
> > So we do want the ICH4 quirk.
> 
> Yes, this is an "official" way how ICH4 (and later) advertises the region.

The quirk is a bug workaround, *not* the "official, planned" way to
deal with these regions.  The official way is to use ACPI, because
that's a generic way that doesn't require changes for new versions
of ICH.

The bug might be that BIOS didn't mention the region in the expected
places.  Or it might be that the BIOS mentioned it, but Linux didn't
deal with it correctly.  For example, the Linux ACPI/PNP core mostly
ignores the resources mentioned in ACPI _CRS methods.  We only look
at those in individual drivers.  The PNP system.c driver reserves
PNP0C01/02 resources, but the BIOS could use other PNP IDs, and Linux
would ignore them (PNPACPI parses them, but doesn't reserve them in
any way).

Bjorn
