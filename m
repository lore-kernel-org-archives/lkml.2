Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756499Ab1JAU1q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Oct 2011 16:27:46 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:41887 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751834Ab1JAU1j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Oct 2011 16:27:39 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: Re: PME via interrupt or SCI mechanism?
Date: Sat, 1 Oct 2011 22:29:55 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc8+; KDE/4.6.0; x86_64; ; )
Cc: linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
References: <20110912171003.GA7939@xanatos> <201109302221.06714.rjw@sisk.pl> <20111001003010.GA26349@xanatos>
In-Reply-To: <20111001003010.GA26349@xanatos>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201110012229.55473.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Saturday, October 01, 2011, Sarah Sharp wrote:
> On Fri, Sep 30, 2011 at 10:21:06PM +0200, Rafael J. Wysocki wrote:
> > OK, please test the appended patch.  The difference is that it should only
> > continuously poll devices that don't get notifications.  You'll still see
> > the debug messages from your previous patches, but this one should be a bit
> > less wasteful than the previous one in general.
> 
> This patch seems to work.  The GPE fires and the xHCI host controller
> comes out of D3 after a stream of:
> 
> Sep 30 17:07:32 talon kernel: [  197.745312] ehci_hcd 0000:00:1d.0: pci_acpi_wake_dev
> Sep 30 17:07:32 talon kernel: [  197.745321] ehci_hcd 0000:00:1a.0: pci_acpi_wake_dev
> Sep 30 17:07:32 talon kernel: [  197.745326] snd_hda_intel 0000:00:1b.0: pci_acpi_wake_dev
> Sep 30 17:07:32 talon kernel: [  197.745331] e1000e 0000:00:19.0: pci_acpi_wake_dev
> 
> It does seem to take less time to come out of D3 than the previous patch
> though.
> 
> I occasionally do not see the host controller come out of D3 when I plug
> in a new device, but the interrupt count for GPE 0D doesn't increment
> when that happens, so it's probably just a BIOS or hardware bug.

I think the controller doesn't signal PME in those cases.

> Did mention this was bleeding edge hardware?

No, you didn't, but that doesn't matter a lot.  Bugs of this kind are found in
systems being sold in the market too and we need to work around them anyway. :-(

Thanks for testing the patch, I'll resent it with a changelog shortly.

Rafael
