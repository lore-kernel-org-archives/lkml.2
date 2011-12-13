Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754005Ab1LMAO3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Dec 2011 19:14:29 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:47284 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752764Ab1LMAO1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Dec 2011 19:14:27 -0500
Message-ID: <1323735263.3837.13.camel@joe2Laptop>
Subject: drivers/dma/sirf-dma.c: boolean and / or confusion
From: Joe Perches <joe@perches.com>
To: roel <roel.kluin@gmail.com>, Barry Song <baohua.song@csr.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Date: Mon, 12 Dec 2011 16:14:23 -0800
In-Reply-To: <4EE688FC.8090606@gmail.com>
References: <4EE688FC.8090606@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-13 at 00:06 +0100, roel wrote:
> The test not [val1] or not [val2] always evaluates to true

Looking at drivers with:

$ grep -rP --include=*.[ch] "(\b[\w\[\]\>\._\-]+)\s*\!\=\s*[\w\[\]\>\._\-]+\s*\)\s*\|\|\s*\(\s*\1\s*\!\=" drivers

drivers/dma/sirf-dma.c:	if ((xt->dir != DMA_MEM_TO_DEV) || (xt->dir != DMA_DEV_TO_MEM)) {

Likely the || should be &&

