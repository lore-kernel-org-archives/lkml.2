Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758391Ab2DJIkV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 04:40:21 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:64482 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753063Ab2DJIkT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 04:40:19 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Minchan Kim <minchan@kernel.org>
Subject: Re: swap on eMMC and other flash
Date: Tue, 10 Apr 2012 08:40:11 +0000
User-Agent: KMail/1.12.2 (Linux/3.3.0-rc1; KDE/4.3.2; x86_64; ; )
Cc: =?utf-8?q?=EC=A0=95=ED=9A=A8=EC=A7=84?= <syr.jeong@samsung.com>,
        "'Alex Lemberg'" <Alex.Lemberg@sandisk.com>,
        linaro-kernel@lists.linaro.org, "'Rik van Riel'" <riel@redhat.com>,
        linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        "'Luca Porzio (lporzio)'" <lporzio@micron.com>, linux-mm@kvack.org,
        kernel-team@android.com, "'Yejin Moon'" <yejin.moon@samsung.com>,
        "'Hugh Dickins'" <hughd@google.com>,
        "'Yaniv Iarovici'" <Yaniv.Iarovici@sandisk.com>, cpgs@samsung.com
References: <201203301744.16762.arnd@arndb.de> <201204091300.34304.arnd@arndb.de> <4F838870.9030407@kernel.org>
In-Reply-To: <4F838870.9030407@kernel.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201204100840.11763.arnd@arndb.de>
X-Provags-ID: V02:K0:igPLSbdNMHSwj1mU+duuIjJ60zmCl0aTAneAmKdHXZF
 lVBxdLUHO+RwR7k9Uc2wTh+p5lzRgFY+mrTQ8wWOsnM5KikV1a
 OWsMgWjEXdDd/AI3jkHXaHggFnJa5ASfw6QQoBpNI3oRnGyFOB
 ULorSvIW2i0InsIrMWotq93gdTI9h/vSNHGTc2D5CPM/rpuSvu
 LYA8u3MR6wNqM9PLe6hsRdYJe52NEkC0ETBYtAOpjP6b6D3Qca
 +TzXbWs7hGUH+OYt64BvRM3/JisxePSl3dK2n8W5Kq5YjkyaGC
 dFO5ArtkRlqrttJ8O+QVw9mIye6lrEcDLjhJvzquoGJDbf345U
 vgPlYj5FQC44VwF9Vp6k=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 10 April 2012, Minchan Kim wrote:
> I think it's not good approach.
> How long does it take to know such parameters?
> I guess it's not short so that mkfs/mkswap would be very long
> dramatically. If needed, let's maintain it as another tool.

I haven't come up with a way that is both fast and reliable.
A very fast method is to time short read requests across potential
erase block boundaries and see which ones are faster than others,
this works on about 3 out of 4 devices. 

For the other devices, I currently use a fairly manual process that
times a lot of write requests and can take a long time.

> If storage vendors break such fields, it doesn't work well on linux
> which is very popular on mobile world today and user will not use such
> vendor devices and company will be gone. Let's give such pressure to
> them and make vendor keep in promise.

This could work for eMMC, yes.

The SD card standard makes it impossible to write the correct value for
most devices, it only supports power-of-two values up to 4MB for SDHC,
and larger values (I believe 8, 12, 16, 24, ... 64) for SDXC, but a lot
of SDHC cards nowadays use 1.5, 3, 6 or 8 MB erase blocks.

	Arnd
