Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab1JAAaT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Sep 2011 20:30:19 -0400
Received: from mga02.intel.com ([134.134.136.20]:17913 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751998Ab1JAAaN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Sep 2011 20:30:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,352,1309762800"; 
   d="scan'208";a="57895519"
Date: Fri, 30 Sep 2011 17:30:10 -0700
From: Sarah Sharp <sarah.a.sharp@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, linux-pci@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: PME via interrupt or SCI mechanism?
Message-ID: <20111001003010.GA26349@xanatos>
References: <20110912171003.GA7939@xanatos>
 <20110929225700.GA6207@xanatos>
 <201109301840.20402.rjw@sisk.pl>
 <201109302221.06714.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201109302221.06714.rjw@sisk.pl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 30, 2011 at 10:21:06PM +0200, Rafael J. Wysocki wrote:
> OK, please test the appended patch.  The difference is that it should only
> continuously poll devices that don't get notifications.  You'll still see
> the debug messages from your previous patches, but this one should be a bit
> less wasteful than the previous one in general.

This patch seems to work.  The GPE fires and the xHCI host controller
comes out of D3 after a stream of:

Sep 30 17:07:32 talon kernel: [  197.745312] ehci_hcd 0000:00:1d.0: pci_acpi_wake_dev
Sep 30 17:07:32 talon kernel: [  197.745321] ehci_hcd 0000:00:1a.0: pci_acpi_wake_dev
Sep 30 17:07:32 talon kernel: [  197.745326] snd_hda_intel 0000:00:1b.0: pci_acpi_wake_dev
Sep 30 17:07:32 talon kernel: [  197.745331] e1000e 0000:00:19.0: pci_acpi_wake_dev

It does seem to take less time to come out of D3 than the previous patch
though.

I occasionally do not see the host controller come out of D3 when I plug
in a new device, but the interrupt count for GPE 0D doesn't increment
when that happens, so it's probably just a BIOS or hardware bug.  Did
mention this was bleeding edge hardware?

Sarah Sharp
