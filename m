Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932372Ab2LNU0g (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Dec 2012 15:26:36 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:65149 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932157Ab2LNU0f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Dec 2012 15:26:35 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of: Support a PCI device that is compatible with 'simple-bus'
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        Rob Herring <rob.herring@calxeda.com>
In-Reply-To: <20121210215119.GA32011@obsidianresearch.com>
References: <20121210215119.GA32011@obsidianresearch.com>
Date: Fri, 14 Dec 2012 20:26:29 +0000
Message-Id: <20121214202629.BD40C3E0BDD@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 Dec 2012 14:51:19 -0700, Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
> The intended use for this feature is to let a PCI device declare
> itself a 'simple-bus' and then describe additional devices
> (such as GPIOs, I2C, etc) nested below itself.
> 
> The devices nested below the PCI device will use 'reg' addressing
> with the 5 dw format used by PCI.
> 
> This is for embedded cases where the PCI device may be a complex
> SOC with no PCI based partitioning of sub-functionality.
> 
> Tested on an ARM kirkwood system
> 
> Signed-off-by: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
> ---
>  drivers/of/address.c |   29 +++++++++++++++++++++++++++++
>  1 files changed, 29 insertions(+), 0 deletions(-)
> 
> Grant:
> 
> > If the soc_devices are getting triggered on that and they shouldn't be,
> > then we need a mechanism in the soc_bridge node to kick out of that
> > behavoir for its children.
> 
> Is this what you were thinking?

Not really. I see what you're trying to do, but doing it this way forces
all children of PCI nodes to use the PCI addressing space. Others have
had simple children of PCI devices and didn't use the PCI address layout
at all. Those users would break with this approach.

However, if you want to pass a unity mapping from the PCI device to the
a child of it, it should be sufficient to use an empty 'ranges;'
property in the PCI device node instead of listing out the ranges that
you want to translate.

g.
