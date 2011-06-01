Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754917Ab1FAV6M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Jun 2011 17:58:12 -0400
Received: from hyde.gogi.tv ([87.106.161.174]:51392 "EHLO hyde.gogi.tv"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752073Ab1FAV6K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Jun 2011 17:58:10 -0400
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Wed, 01 Jun 2011 22:58:08 +0100
From: Daniel Haid <d.haid@gogi.tv>
To: <linux-kernel@vger.kernel.org>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andi Kleen <andi@firstfloor.org>
Subject: Re: Question about iommu on =?UTF-8?Q?x=38=36=5F=36=34=20and=20ra?=
 =?UTF-8?Q?deon=20driver=2E?=
In-Reply-To: <21491fcfb013e21177140326efc0ee66@admin.gogi.tv>
References: <20110525125752.GB3467@dumpdata.com>
 <dfd8bfd19ba1fb77d6448bff97123e13@admin.gogi.tv>
 <20110527155507.GB11273@dumpdata.com>
 <9e26ea71798d10a3f900c777b71ff485@admin.gogi.tv>
 <20110531134519.GC14641@dumpdata.com>
 <59be1730ec1660abeb7b4dc584510d34@admin.gogi.tv>
 <20110531160221.GA31659@dumpdata.com>
 <0a8cb4bcad7fcf091a6bbe158323bba0@admin.gogi.tv>
 <20110531190412.GA21245@dumpdata.com>
 <d0ce6a4ba6092a1a9ef0f1e8f3cac9c9@admin.gogi.tv>
 <20110601132444.GA4081@dumpdata.com>
 <21491fcfb013e21177140326efc0ee66@admin.gogi.tv>
Message-ID: <34fa3fe7780241e452b268fd5ecfdee9@admin.gogi.tv>
User-Agent: Roundcube Webmail/0.4.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 I have also found out the following. In

 line 741 of drivers/gpu/drm/radeon/radeon_device.c

 there is a comment "PCIE - can handle 40-bits." -
 I have a PCIE card - and then need_dma32 is not set.

 So if I read it correctly the ttm allocation
 routines will allocate memory over 4GB.

 But if PCIE can handle 40 bits, why does swiotlb
 give out a bounce buffer to the radeon driver at all?

 Shouldn't

 (dma_capable(dev, dev_addr, size) && !swiotlb_force)

 on line 672 of lib/swiotlb.c be true?



