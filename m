Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755811Ab0EXABj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 May 2010 20:01:39 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:51920 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754440Ab0EXABh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 May 2010 20:01:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=AoN8BJEFZO1Q3SZNSaaXQwnbj+UnijWkHaHcnlDcEmAg7nTEeA+Qa+B+95H33wysfh
         WF+JMwQ3sPdBsXfBm7H5jCgW1PDGX4tkg3Xhs9YParGQUJo+FNvS06nTIYI8kijyIVbB
         4M6s2dXr2vYL8sNbjoTvVOuYCXjzoQh6jsyZY=
MIME-Version: 1.0
In-Reply-To: <m2vdbb048f61004190326ve4220de6za13c94eed059ec2@mail.gmail.com>
References: <v2mdbb048f61004132326r8ac75382k1e42321ff0ed484a@mail.gmail.com>
	 <v2he9c3a7c21004141730vcc79dd58t5478c9d83af9816@mail.gmail.com>
	 <m2vdbb048f61004190326ve4220de6za13c94eed059ec2@mail.gmail.com>
Date: Mon, 24 May 2010 02:01:34 +0200
Message-ID: <AANLkTikA0YefhGQb9V2e9Ub5W21cTy3pY66Rn1VDpX9Q@mail.gmail.com>
Subject: Re: Dmaengine query
From: Linus Walleij <linus.ml.walleij@gmail.com>
To: rd bairva <rbairva@gmail.com>
Cc: Dan Williams <dan.j.williams@intel.com>,
       linux-arm-kernel@lists.arm.linux.org.uk, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/4/19 rd bairva <rbairva@gmail.com>:

>    My DMA controller supports device to device DMA transfers and we
> need it in some of our drivers. Existing DMA engine framework doesn't
> have support for device to device transfers.
>
> Do you have any plans for device to device support in DMA engine?
>
> Can you suggest me some other suggestion for doing this?

Extend the DMA engine with the stuff you need and propose nice
patches, provide them along with a driver that make use of this
feature.

What about a signature like this:

struct dma_async_tx_descriptor *(*device_prep_slave2slave)(
                struct dma_chan *chan1, struct dma_chan *chan2,
                enum dma_data_direction direction,
                unsigned long flags);

You'd have to add some semantics comment saying that
DMA_TO_DEVICE means chan1->chan2 and
DMA_FROM_DEVICE means chan1<-chan2.

Could be a bit of hacking but how hard can it be?

Yours,
Linus Walleij
