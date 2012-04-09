Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313Ab2DIMys (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 08:54:48 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56157 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754230Ab2DIMyq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 08:54:46 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: =?utf-8?q?=EC=A0=95=ED=9A=A8=EC=A7=84?= <syr.jeong@samsung.com>
Subject: Re: swap on eMMC and other flash
Date: Mon, 9 Apr 2012 12:54:39 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: "'Minchan Kim'" <minchan@kernel.org>,
        "'Alex Lemberg'" <Alex.Lemberg@sandisk.com>,
        linaro-kernel@lists.linaro.org, "'Rik van Riel'" <riel@redhat.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Luca Porzio (lporzio)'" <lporzio@micron.com>, linux-mm@kvack.org,
        kernel-team@android.com, "'Yejin Moon'" <yejin.moon@samsung.com>,
        "'Hugh Dickins'" <hughd@google.com>,
        "'Yaniv Iarovici'" <Yaniv.Iarovici@sandisk.com>, cpgs@samsung.com
References: <201203301744.16762.arnd@arndb.de> <4F8245EA.6000600@kernel.org> <006f01cd1623$ac4a2860$04de7920$%jeong@samsung.com>
In-Reply-To: <006f01cd1623$ac4a2860$04de7920$%jeong@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <201204091254.39380.arnd@arndb.de>
X-Provags-ID: V02:K0:3Oo1Fodb1gBrP0T6mFME8C6MXBs6gCc9fW8GYxou8K4
 gLUPFb6YTB2MM8roPsr/05oPuTkNU94Q0uAeHKzwwI5uYEmfKQ
 Wi/kf27BjY6R407lHmigaOcE6+Q0p5NdOQ9S2eD4G7FSxmv9lN
 Eis/Qw2qrxb2UsCM4FtL7gput3rT503jmKxL/uecSTfn4nAMK8
 bY5BIucJNpRnG+H8UqbUQa47CoJDIFRLP9guEaCE/gb87itz1o
 nnxzbxMVzgczpPnvcuzkqDzAo1MFwJ1FQcRrUqGtTQkatlJzqx
 dPXb2OV8RkVeWMdSHnoPl0rLrp70fo+uIDM7rEZUvaIjRggUWQ
 V0qBLIT3OaA4TOWZEsFU=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 09 April 2012, 정효진 wrote:
> If swap system use 512KB page and issue Discard/Trim align with 512KB, eMMC make best
> performance as of today. However, large page size in swap partition may not best way
> in Linux system level.
> I'm not sure that the best page size between Swap system and eMMC device.

Can you explain the significance of the 512KB size? I've seen devices report 512KB
erase size, although measurements clearly showed an erase block size of 8MB and I
do not understand this discprepancy.

Right now, we always send discards of 1MB clusters to the device, which does what
you want, although I'm not sure if those clusters are naturally aligned to the start
of the partition. Obviously this also requires aligning the start of the partition
to the erase block size, but most devices should already get that right nowadays.

	Arnd
