Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab1HBI5F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 04:57:05 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:38818 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab1HBI46 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 04:56:58 -0400
Date: Tue, 2 Aug 2011 11:54:47 +0300
From: Dan Carpenter <error27@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Tino Keitel <tino.keitel@tikei.de>, Florian Mickler <florian@mickler.org>,
        mchehab@infradead.org
Subject: Re: USB related "unable to handle kernel paging request" in 3.0.0-rc7
Message-ID: <20110802085447.GA4522@shale.localdomain>
References: <20110722192722.GA9369@x61.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110722192722.GA9369@x61.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looking at this, I noticed a memory corruption bug introduce in:
ab22cbda6651d "[media] vp7045: get rid of on-stack dma buffers"

vp7045_properties.size_of_priv is sizeof(u8 *) so in vp7045_usb_probe()
the d->priv buffer gets allocated twice.  Once in:
	dvb_usb_device_init()
	-> dvb_usb_init()

And once explicitly to a larger buffer later on in the function with
a kmalloc().

So the two places that use the buffer will probably race and cause
memory corruption.

regards,
dan carpenter
