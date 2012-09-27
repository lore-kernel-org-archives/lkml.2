Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752467Ab2I0P7f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 11:59:35 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:32571 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751140Ab2I0P7e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 11:59:34 -0400
X-AuditID: cbfee61b-b7f2b6d000000f14-88-506477e2dbf2
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Thierry Reding'" <thierry.reding@avionic-design.de>
Cc: "'Michal Nazarewicz'" <mina86@mina86.com>, linux-kernel@vger.kernel.org
References: <20120927112911.GA25959@avionic-0098.mockup.avionic-design.de>
In-reply-to: <20120927112911.GA25959@avionic-0098.mockup.avionic-design.de>
Subject: RE: CMA broken in next-20120926
Date: Thu, 27 Sep 2012 17:59:19 +0200
Organization: SPRC
Message-id: <000601cd9cc9$100428c0$300c7a40$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac2co1hhfpTP6PATTK2sWXR8ejgJRQAJZaSA
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t9jAd1H5SkBBgvvWFlc3jWHzYHR4/Mm
	uQDGKC6blNSczLLUIn27BK6M7oMLmQv2clUcXraesYFxPUcXIyeHhICJxNT+hSwQtpjEhXvr
	2boYuTiEBBYxSvS//s4O4cxikrj/4QArSBWbgKFE19suNhBbRMBcYsmivcwgNrOAp8TTrtVg
	NUICXhLnG/6wg9icAt4Sv3e/AdsgLKAhsb5tO1icRUBVYtmnGUA2Bwe/gJDExFkKIGFeAReJ
	liM9jBC2oMSPyfdYIMZrSazfeZwJwpaX2LzmLTNIq4SAusSjv7oQ1xhJ7Dk3mQ2iRETibsNz
	1gmMwrOQTJqFZNIsJJNmIWlZwMiyilE0tSC5oDgpPddIrzgxt7g0L10vOT93EyM4vJ9J72Bc
	1WBxiFGAg1GJhzfAPTlAiDWxrLgy9xCjBAezkghvlGpKgBBvSmJlVWpRfnxRaU5q8SFGaQ4W
	JXHeZg+glEB6YklqdmpqQWoRTJaJg1OqgTHt8ZK7eeLCZ+sjDebwrTv0c7HeetnVKWZNbIHp
	uZXppZW8ji4yK9d9PHVzwjGr5MLnBy7oyL+MOhzgUuogfPVfzAOe2/uCOx1mF7Rtk9w8MaNo
	D3/zgxXHV/LuZnmnqq+9Nc+Ib/ZOntw9TowHdTNcnruxTGM9bmC9rjdEmWt52hXm9geWaUos
	xRmJhlrMRcWJAMMky0FrAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thursday, September 27, 2012 1:29 PM Thierry Reding wrote:

> any idea why CMA might be broken in next-20120926. I see that there
> haven't been any major changes to CMA itself, but there's been quite a
> bit of restructuring of various memory allocation bits lately. I wasn't
> able to track the problem down, though.
> 
> What I see is this during boot (with CMA_DEBUG enabled):
> 
> [    0.266904] cma: dma_alloc_from_contiguous(cma db474f80, count 64, align 6)
> [    0.284469] cma: dma_alloc_from_contiguous(): memory range at c09d7000 is busy, retrying
> [    0.293648] cma: dma_alloc_from_contiguous(): memory range at c09d7800 is busy, retrying
> ...
> [    2.648619] DMA: failed to allocate 256 KiB pool for atomic coherent allocation
> ...
> [    4.196193] WARNING: at /home/thierry.reding/src/kernel/linux-ipmp.git/arch/arm/mm/dma-
> mapping.c:485 __alloc_from_pool+0xdc/0x110()
> [    4.207988] coherent pool not initialised!
> 
> So the pool isn't getting initialized properly because CMA can't get at
> the memory. Do you have any hints as to what might be going on? If it's
> any help, I started seeing this with next-20120926 and it is in today's
> next as well.

Thanks for the report, I will check this issue asap.

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


