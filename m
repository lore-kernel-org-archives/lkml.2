Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933731Ab2KBOTB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Nov 2012 10:19:01 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:38643 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1762912Ab2KBOS6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Nov 2012 10:18:58 -0400
Date: Fri, 2 Nov 2012 10:18:57 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Felipe Balbi <balbi@ti.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, Greg KH <greg@kroah.com>,
        <linux-next@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>
Subject: Re: linux-next: build warning after merge of the usb tree
In-Reply-To: <20121102090743.GB17938@arwen.pp.htv.fi>
Message-ID: <Pine.LNX.4.44L0.1211021014180.1356-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2 Nov 2012, Felipe Balbi wrote:

> Hi,
> 
> On Fri, Nov 02, 2012 at 03:08:28PM +1100, Stephen Rothwell wrote:
> > Hi Greg,
> > 
> > After merging the usb tree, today's linux-next build (x86_64 allmodconfig)
> > produced this warning:
> > 
> > WARNING: drivers/usb/host/ehci-hcd: 'ehci_init_driver' exported twice. Previous export was in drivers/usb/chipidea/ci_hdrc.ko
> > WARNING: drivers/usb/host/ehci-hcd: 'ehci_resume' exported twice. Previous export was in drivers/usb/chipidea/ci_hdrc.ko
> > WARNING: drivers/usb/host/ehci-hcd: 'ehci_suspend' exported twice. Previous export was in drivers/usb/chipidea/ci_hdrc.ko
> > WARNING: drivers/usb/host/ehci-hcd: 'ehci_setup' exported twice. Previous export was in drivers/usb/chipidea/ci_hdrc.ko
> > 
> > Introduced by commit 3e0232039967 ("USB: EHCI: prepare to make ehci-hcd a
> > library module").
> 
> Alex, why on earth is chipidea exporting symbols it doesn't own ?

That's at least partly my fault.  ehci-hcd.c now exports four symbols 
that it didn't before.  Since the ChipIdea driver does

	#include "../host/ehci-hcd.c"

it now exports them too, unintentionally.  A quick band-aid fix would 
be to protect those functions with

	#ifndef CHIPIDEA_EHCI

but the real fix is the patch I posted yesterday -- assuming it works 
right.  If we don't hear back from Alex soon, I will post the band-aid 
fix as a temporary stop-gap.

Alan Stern

