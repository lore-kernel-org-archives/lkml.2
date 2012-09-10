Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757791Ab2IJNIM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 09:08:12 -0400
Received: from eu1sys200aog112.obsmtp.com ([207.126.144.133]:45978 "EHLO
	eu1sys200aog112.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751839Ab2IJNIH convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 09:08:07 -0400
From: Sjur BRENDELAND <sjur.brandeland@stericsson.com>
To: Ohad Ben-Cohen <ohad@wizery.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        =?iso-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Date: Mon, 10 Sep 2012 15:07:55 +0200
Subject: RE: Remoteproc: Translating between host and device addresses.
Thread-Topic: Remoteproc: Translating between host and device addresses.
Thread-Index: Ac2PUrMvtXHAYkcXRhGh40DQPTUFgQAAHKrg
Message-ID: <81C3A93C17462B4BBD7E272753C1057923B9DB3227@EXDCVYMBSTM005.EQ1STM.local>
References: <81C3A93C17462B4BBD7E272753C1057923B924C92D@EXDCVYMBSTM005.EQ1STM.local>
 <CAK=WgbZLjQVYFHcTkb+nDpYZx3qkWp=wQmOqOpMHCxroceTNpg@mail.gmail.com>
In-Reply-To: <CAK=WgbZLjQVYFHcTkb+nDpYZx3qkWp=wQmOqOpMHCxroceTNpg@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ohad,

> > One way for the device to figure out the translation between
> > host-physical and device-address is to peek into some CarveOut
> > resource entry and compute this translation. Because a CarveOut
> > resource entry contains both the host-physical-address and the
> > device address for the same memory location. But this feels
> > like a workaround, shouldn't we make a more explicit way of
> > communicating this mapping between host-physical and device
> > addresses?
> 
> Yes, we should. The plan is, when relevant, to switch to the
> IOMMU-based DMA API to allocate device addresses (by programming the
> IOMMUs automatically), and stop sending physical addresses remotely.

But the vring descriptor table will still contain the host's physical address for the
buffers, right?
So how can the device then find the device-address of these buffers if we don't 
use an IOMMU and have no address translation from host-physical-address 
to device-address?

> For OMAP, btw, we will still provide those device->physical
> translation resource entries, because OMAP4 has a few remote
> components that access the host-physical memory directly.

Thanks,
Sjur
