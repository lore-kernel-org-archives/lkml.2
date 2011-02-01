Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751873Ab1BAFW3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Feb 2011 00:22:29 -0500
Received: from sh.osrg.net ([192.16.179.4]:54502 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751187Ab1BAFW2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Feb 2011 00:22:28 -0500
Date: Tue, 1 Feb 2011 14:22:01 +0900
To: hancockrwd@gmail.com
Cc: fujita.tomonori@lab.ntt.co.jp, ak@linux.intel.com, cebbert@redhat.com,
        linux-kernel@vger.kernel.org, dwmw2@infradead.org
Subject: Re: b44 driver causes panic when using swiotlb
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <4D477C6F.8000906@gmail.com>
References: <4D4759BD.2000006@gmail.com>
	<20110201102707C.fujita.tomonori@lab.ntt.co.jp>
	<4D477C6F.8000906@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20110201142103M.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Tue, 01 Feb 2011 14:22:02 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 31 Jan 2011 21:22:23 -0600
Robert Hancock <hancockrwd@gmail.com> wrote:

> > Some ideas to implement something that works for such device were
> > discussed. Seems that the conclusion is that it's doesn't worth making
> > the common code complicated for such minor and insane devices.
> 
> I don't think this is the only device that has sub-32-bit DMA 
> restrictions, this will just lead to a bunch of duplicated code.

Yeah, not only device but not many.

The block layer has the own bouncing mechanism. Some network drivers
have the similar bouncing code. I don't know if there are other kinds
of drivers that have the own bouncing code.

I thought that we can make mm/bounce.c (used for block drivers now)
work any drivers without complicating it. We could make swiotlb to do
but it's too complicated and it doesn't worth.


> In 
> particular, how is LPC DMA supposed to work?

LPC DMA can't do 32bit dma?


> At the very least we should be allowing the driver to deal with the 
> failure instead of panicing the system. Otherwise we are just leaving a 
> land mine for people to trip over.

Agreed. swiotlb shouldn't panic in this case. I'll take care of it.
