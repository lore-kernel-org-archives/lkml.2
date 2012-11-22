Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753936Ab2KVSew (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:34:52 -0500
Received: from quartz.orcorp.ca ([184.70.90.242]:37943 "EHLO quartz.orcorp.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753915Ab2KVSer (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:34:47 -0500
Date: Thu, 22 Nov 2012 10:30:20 -0700
From: Jason Gunthorpe <jgunthorpe@obsidianresearch.com>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree-discuss <devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH] of: Have of_device_add call platform_device_add rather
 than device_add
Message-ID: <20121122173020.GA8473@obsidianresearch.com>
References: <20121121072448.GG19837@obsidianresearch.com>
 <20121121155104.726B83E0AE2@localhost>
 <20121121174453.GD6406@obsidianresearch.com>
 <CACxGe6u2Kfm+x5KsFzNPt7voyeD0x_4V6EO4add=tBwMKJ6VWQ@mail.gmail.com>
 <20121121181430.GE6406@obsidianresearch.com>
 <20121122153621.452CA3E129E@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121122153621.452CA3E129E@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Broken-Reverse-DNS: no host name found for IP address 10.0.0.162
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 03:36:21PM +0000, Grant Likely wrote:

> Hmm... I've not tried it with assigned-address. I tried with two sibling
> platform devices using just the 'reg' property. That the kernel will
> complain about. For powerpc-only, the patch I posted allows the device
> to get registered anyway even though the range incorrectly overlaps.

My second example was done with the reg property..

                gpio0: gpio@10100 {
                        compatible = "marvell,orion-gpio";
                        #gpio-cells = <2>;
                        gpio-controller;
                        reg = <0x10100 0x40>;
                }
                chip_cfg@0 {
                        compatible = "orc,chip_config";
                        // Doubles up on gpio0
                        reg = <0x10100 0x4>;
                };


f1010100-f101013f : /internal@f1000000/gpio@10100
  f1010100-f1010103 : /internal@f1000000/chip_cfg@0

What did you try? Maybe order matters?

Regards,
Jason
