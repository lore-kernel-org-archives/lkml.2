Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753234Ab0ELHqk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 May 2010 03:46:40 -0400
Received: from eu1sys200aog117.obsmtp.com ([207.126.144.143]:34574 "EHLO
	eu1sys200aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751810Ab0ELHqh convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 May 2010 03:46:37 -0400
From: Linus WALLEIJ <linus.walleij@stericsson.com>
To: Dan Williams <dan.j.williams@intel.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
       "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
       "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 12 May 2010 09:39:23 +0200
Subject: RE: [PATCH 1/7] DMAENGINE: add generic PrimeCell interface to COH
 901 	318 v6
Thread-Topic: [PATCH 1/7] DMAENGINE: add generic PrimeCell interface to COH
 901 	318 v6
Thread-Index: AcrxKnmIkhMxXInkSCic0X1d/8I8TwAedKbg
Message-ID: <CEE6BB42CAD6E947908279175AF8470A025A6DE803@EXDCVYMBSTM006.EQ1STM.local>
References: <1272848076-28315-1-git-send-email-linus.walleij@stericsson.com>
	 <AANLkTinAVhnpjgVTtbZYYKb1t_DInVwTKkkJRzcO97RX@mail.gmail.com>
 <AANLkTim7Tp8lCwMbQwW5QiQ49j7idFFUWdU3x8azIlok@mail.gmail.com>
In-Reply-To: <AANLkTim7Tp8lCwMbQwW5QiQ49j7idFFUWdU3x8azIlok@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[Dan]

> >> +void dma_set_ambaconfig(struct dma_chan *chan,
> >> +                       struct amba_dma_channel_config *config)
> >
> > What happens when two primecell dma devices are present on one soc?
> > Can that happen?  In that case we'll have conflicting providers of
> > dma_set_ambaconfig().
> >
> 
> ...the ->device_control() method is already approaching an ioctl()
> let's just add the argument parameter to complete the capability,
> i.e.:
> 
> int (*device_control)(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
> unsigned long arg);

So the unsigned long arg is to match an ioctl? Okidoki...

If it was only for in-kernel use a void* would be preferred
I believe since assuming unsigned long to be == bus width
is ... well, disturbing, since we'll be casting this into
a struct pointer.

So this should also be used for the AMBA configuration stuff
then, so I have to make first a patch to convert all the
device_control functions and then a patch on top of that to
implement the AMBA call as a device_control() thingie?

(Should work out...)

Just a bit of work, so will take some more hours :-)

I will just have to make a proof-of-concept for the AMBA config
interface for Russell first, then I'll be on the ioctl-like API.

Yours,
Linus Walleij
