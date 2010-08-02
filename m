Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732Ab0HBO40 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 10:56:26 -0400
Received: from sh.osrg.net ([192.16.179.4]:44245 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751303Ab0HBO4Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 10:56:24 -0400
Date: Mon, 2 Aug 2010 23:56:12 +0900
To: konrad.wilk@oracle.com
Cc: fujita.tomonori@lab.ntt.co.jp, konrad@kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        ak@linux.intel.com, akataria@vmware.com
Subject: Re: [PATCH] swiotlb: enlarge iotlb buffer on demand
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
In-Reply-To: <201008020940.09552.konrad.wilk@oracle.com>
References: <20100731010706.GA30319@andromeda.dapyr.net>
	<20100801120224F.fujita.tomonori@lab.ntt.co.jp>
	<201008020940.09552.konrad.wilk@oracle.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-Id: <20100802235521D.fujita.tomonori@lab.ntt.co.jp>
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-3.0 (sh.osrg.net [192.16.179.4]); Mon, 02 Aug 2010 23:56:13 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Aug 2010 09:40:08 -0400
Konrad Rzeszutek Wilk <konrad.wilk@oracle.com> wrote:

> I am curious about the handling of the -ENOMEM stage. Naturally we would 
> return an error the device - are the most common ones (ahci, r8169, 
> ata_piix - those that are DMA_32) equipped to deal with unavailable memory?

libata does dma mapping for ata drivers. It can handle mapping errors.

Looks like r8169 can't handle errors.

All drivers should handle mapping errors because IOMMUs are pretty
common now. I think that drivers that vendor people are serious about
can handle mapping errors.
