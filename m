Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753098Ab2HSOSa (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 10:18:30 -0400
Received: from ud10.udmedia.de ([194.117.254.50]:52010 "EHLO
	mail.ud10.udmedia.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752607Ab2HSOS1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 10:18:27 -0400
Date: Sun, 19 Aug 2012 16:18:24 +0200
From: Markus Trippelsdorf <markus@trippelsdorf.de>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Kay Sievers <kay@vrfy.org>
Subject: Re: Force enabled HPET at 0x%lx
Message-ID: <20120819141824.GC251@x4>
References: <20120819140232.GA23629@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120819140232.GA23629@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2012.08.19 at 22:02 +0800, Fengguang Wu wrote:
> Hi,
> 
>         [   38.650387] PCI host bridge to bus 0000:00
>         [   38.657920] pci_bus 0000:00: Force enabled HPET at 0x%lx
>                                                                 ~~~
> 
> That "0x%lx" message should be emitted by one of the dev_printks in
> arch/x86/kernel/quirks.c and I failed to see anything wrong with it:
> 
>                 dev_printk(KERN_DEBUG, &dev->dev, "Force enabled HPET at "
>                         "0x%lx\n", force_hpet_address);
> 
> So why the value of "force_hpet_address" is not printed?
> 
>         [   38.657920] busn_res: [bus 00-ff] is inserted under domain [bus 00-ff]
>         [   38.658480] pci_bus 0000:00: ^A0root bus resource [bus 00-ff]
>         [   38.662411] pci_bus 0000:00: ^A0root bus resource [io  0x0000-0xffff]
>         [   38.664639] pci_bus 0000:00: ^A0root bus resource [mem 0x00000000-0xffffffffff]
>                                         ~~~
> 
> And that ^A0 character also looks strange..

http://lkml.org/lkml/2012/8/18/143

Fix:
http://git.kernel.org/?p=linux/kernel/git/gregkh/driver-core.git;a=commitdiff;h=ebdc82899ec5ed35af1c79ed6a4eeda69dad9b90

-- 
Markus
