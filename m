Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755688Ab2KZQnz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:43:55 -0500
Received: from mail-wi0-f174.google.com ([209.85.212.174]:38967 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755284Ab2KZQmG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:42:06 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] of: Have of_device_add call platform_device_add rather than device_add
To: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
In-Reply-To: <20121122173020.GA8473@obsidianresearch.com>
References: <20121121072448.GG19837@obsidianresearch.com> <20121121155104.726B83E0AE2@localhost> <20121121174453.GD6406@obsidianresearch.com> <CACxGe6u2Kfm+x5KsFzNPt7voyeD0x_4V6EO4add=tBwMKJ6VWQ@mail.gmail.com> <20121121181430.GE6406@obsidianresearch.com> <20121122153621.452CA3E129E@localhost> <20121122173020.GA8473@obsidianresearch.com>
Date: Mon, 26 Nov 2012 15:28:48 +0000
Message-Id: <20121126152848.57CB73E1A30@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Nov 2012 10:30:20 -0700, Jason Gunthorpe <jgunthorpe@obsidianresearch.com> wrote:
> On Thu, Nov 22, 2012 at 03:36:21PM +0000, Grant Likely wrote:
> 
> > Hmm... I've not tried it with assigned-address. I tried with two sibling
> > platform devices using just the 'reg' property. That the kernel will
> > complain about. For powerpc-only, the patch I posted allows the device
> > to get registered anyway even though the range incorrectly overlaps.
> 
> My second example was done with the reg property..
> 
>                 gpio0: gpio@10100 {
>                         compatible = "marvell,orion-gpio";
>                         #gpio-cells = <2>;
>                         gpio-controller;
>                         reg = <0x10100 0x40>;
>                 }
>                 chip_cfg@0 {
>                         compatible = "orc,chip_config";
>                         // Doubles up on gpio0
>                         reg = <0x10100 0x4>;
>                 };
> 
> 
> f1010100-f101013f : /internal@f1000000/gpio@10100
>   f1010100-f1010103 : /internal@f1000000/chip_cfg@0
> 
> What did you try? Maybe order matters?

(Sorry for not replying to my own mail; I'm doing this offline and my
sent mail doesn't show)

Looks like it is by design. With my dummy devices I see this:

10200c00-102023ff : /amba/overlap@10200c00
  10201000-10201fff : /amba/dummy@10201000
    10201400-10201bff : /amba/overlap@10201400

All three of those devices are siblings in the device tree.

g.
