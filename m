Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755431Ab2HGOxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 10:53:49 -0400
Received: from mailout1.samsung.com ([203.254.224.24]:28960 "EHLO
	mailout1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755412Ab2HGOxn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 10:53:43 -0400
X-AuditID: cbfee61a-b7f616d000004b7e-a2-50212bf6cd0f
From: Marek Szyprowski <m.szyprowski@samsung.com>
To: "'Hideki EIRAKU'" <hdk@igel.co.jp>,
        "'Russell King'" <linux@arm.linux.org.uk>,
        "'Pawel Osciak'" <pawel@osciak.com>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Mauro Carvalho Chehab'" <mchehab@infradead.org>,
        "'Florian Tobias Schandinat'" <FlorianSchandinat@gmx.de>,
        "'Jaroslav Kysela'" <perex@perex.cz>, "'Takashi Iwai'" <tiwai@suse.de>,
        Tomasz Stanislawski <t.stanislaws@samsung.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-fbdev@vger.kernel.org,
        alsa-devel@alsa-project.org, "'Katsuya MATSUBARA'" <matsu@igel.co.jp>
References: <1344246924-32620-1-git-send-email-hdk@igel.co.jp>
 <1344246924-32620-4-git-send-email-hdk@igel.co.jp>
In-reply-to: <1344246924-32620-4-git-send-email-hdk@igel.co.jp>
Subject: RE: [PATCH v3 3/4] media: videobuf2-dma-contig: use dma_mmap_coherent
 if available
Date: Tue, 07 Aug 2012 16:53:25 +0200
Organization: SPRC
Message-id: <012701cd74ac$6a617060$3f245120$%szyprowski@samsung.com>
MIME-version: 1.0
Content-type: text/plain; charset=us-ascii
Content-transfer-encoding: 7bit
X-Mailer: Microsoft Office Outlook 12.0
Thread-index: Ac1zub2OnhGLLwQMTPWuQmtZYBCmagA6SHEA
Content-language: pl
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t9jAd1v2ooBBgu7BCxO9H1gtbi8aw6b
	Rc+GrawOzB6fN8kFMEZx2aSk5mSWpRbp2yVwZfQ82cZWsJy7Ys0m1wbG3ZxdjJwcEgImEutf
	nWKDsMUkLtxbD2RzcQgJLGKUOD7pBhOE85NRonnJIlaQKjYBQ4mut11gVSICbcwS1+fPYwdx
	mAVOMkpcffSZEaRKSKBY4sftvewgNqeAvcS8tyeYQWxhgViJ3oN7WUBsFgFViRv7rgLVcHDw
	CwhJTJylABLmFXCROHTsNSOELSjxY/I9sHJmAS2J9TuPM0HY8hKb17xlBmmVEFCXePRXFyQs
	ImAk8WryPmaIEhGJuw3PWScwCs9CMmkWkkmzkEyahaRlASPLKkbR1ILkguKk9FxDveLE3OLS
	vHS95PzcTYzgoH8mtYNxZYPFIUYBDkYlHt4JsgoBQqyJZcWVuYcYJTiYlUR4D+8ECvGmJFZW
	pRblxxeV5qQWH2KU5mBREuc19v7qLySQnliSmp2aWpBaBJNl4uCUamBkKlIyiiqtPVw/wf36
	JjPuJj479U+B9y2yJq+128HlkK7MlO+iYvTMQO3+lNXnTm5q2dxjfMjkps5NFgeOQ+wsu2p3
	RzCdZCp9d+7OSRnBjb/KuWZ06Ahrrvf5328zochnj2xv47HwpKb0a/etP894d/rJVOFd+uw3
	Sh7dzHaqV825X35phrMSS3FGoqEWc1FxIgDaOcLWdgIAAA==
X-TM-AS-MML: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Monday, August 06, 2012 11:55 AM Hideki EIRAKU wrote:

> Previously the vb2_dma_contig_mmap() function was using a dma_addr_t as a
> physical address.  The two addressses are not necessarily the same.
> For example, when using the IOMMU funtion on certain platforms, dma_addr_t
> addresses are not directly mappable physical address.
> dma_mmap_coherent() maps the address correctly.
> It is available on ARM platforms.
> 
> Signed-off-by: Hideki EIRAKU <hdk@igel.co.jp>

I'm sorry for bringing this issue now, once you have already created v3 of your
patches, but similar patch has been already proposed some time ago. It is already
processed together with general videobuf2-dma-contig redesign and dma-buf extensions
by Tomasz Stanislawski.

See post http://thread.gmane.org/gmane.comp.video.dri.devel/70402/focus=49461 and
http://thread.gmane.org/gmane.linux.drivers.video-input-infrastructure/49438 

It doesn't use conditional code inside videobuf2 allocator and rely entirely on 
dma-mapping subsystem to provide a working dma_mmap_coherent/writecombine/attrs() 
function. When it was posted, it relied on the dma-mapping extensions, which now
have been finally merged to v3.6-rc1. Now I wonder if there are any architectures, 
which don't use dma_map_ops based dma-mapping framework, which might use 
videobuf2-dma-conting module. 

Best regards
-- 
Marek Szyprowski
Samsung Poland R&D Center


