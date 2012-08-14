Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754113Ab2HNB3y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 21:29:54 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:47450 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753934Ab2HNB3x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 21:29:53 -0400
Date: Mon, 13 Aug 2012 18:29:49 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, devel@driverdev.osuosl.org,
        abbotti@mev.co.uk
Subject: Re: [PATCH 1/2 v2] staging: comedi: new adl_pci7x3x driver
Message-ID: <20120814012949.GA11859@kroah.com>
References: <201208031028.18759.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201208031028.18759.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 03, 2012 at 10:28:18AM -0700, H Hartley Sweeten wrote:
> Currently the ADLink PCI-7230 and PCI-7432 Isolated Digital
> I/O Boards are supported using two drivers (adl_pci7230 and
> adl_pci7432). These drivers are very similar and only differ
> in the total number of di/do channels provided.
> 
> This driver combines the support for both boards into one
> common driver. In addition, it adds PCI PnP support for the
> other boards in the ADLink PCI-723x and PCI-743x series.
> 
> This driver only supports the comedi PCI auto config attach
> mechanism. The legacy attach using the comedi_config utility
> is not supported or required by this driver.

I now get the following build warnings on my box with this patch
applied:

drivers/staging/comedi/drivers/adl_pci7x3x.c: In function ‘adl_pci7x3x_do_insn_bits’:
drivers/staging/comedi/drivers/adl_pci7x3x.c:124:21: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]
drivers/staging/comedi/drivers/adl_pci7x3x.c: In function ‘adl_pci7x3x_di_insn_bits’:
drivers/staging/comedi/drivers/adl_pci7x3x.c:150:21: warning: cast from pointer to integer of different size [-Wpointer-to-int-cast]

Care to send a follow-on patch to fix this up?

thanks,

greg k-h
