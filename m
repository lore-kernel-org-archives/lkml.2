Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932065Ab1JCLu1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Oct 2011 07:50:27 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:58143 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab1JCLuU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Oct 2011 07:50:20 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Sangbeom Kim <sbkim73@samsung.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org, "'Jassi Brar'" <jassisinghbrar@gmail.com>,
        linux-kernel@vger.kernel.org, "'Liam Girdwood'" <lrg@ti.com>
Subject: Re: [alsa-devel] [PATCH 5/6] ASoC: samsung: fix Kconfig dependencies
Date: Mon, 03 Oct 2011 13:50:08 +0200
Message-ID: <1869072.QQLATNzYYx@wuerfel>
User-Agent: KMail/4.7.1 (Linux/3.1.0-rc8nosema+; KDE/4.7.1; x86_64; ; )
In-Reply-To: <004e01cc8198$848347f0$8d89d7d0$@com>
References: <1317587284-2776-1-git-send-email-arnd@arndb.de> <3289863.m6ULFZUV3p@wuerfel> <004e01cc8198$848347f0$8d89d7d0$@com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:IS4rjtAOncpme8Fh8cZWpzH+QRioT7Xln/NqQXFuNWW
 /Nbs7gtN2knvB8tXYK1DbSccxtvz2cJZiDqmX9xOTrQNnEyChL
 IlfoaO3NHaN9ollzCrxwo8i6ZhK76BSzE6ZjHzxg9EzHMRYAkn
 Qm2hDgRePZLYqqxi+lIFiDSbGkoeNOjlj9K6dkc9DPiwWj5LVu
 irZDPI6z3LCVadHKnFCzGotBRmHwU2CmDf7zr8V42fd2e2tHyo
 I413CXbuZcUcq7LoslF2WOeEP6Azym3c9XJ1NdrAvdt9TurRSQ
 IU6kQ9WZhy6GP7m9RWq6QbOliIHJKeWhYFby2u1x/uoq168wR2
 AHNgzXUccX0I8J2oB8jc=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 03 October 2011 15:48:54 Sangbeom Kim wrote:
> On Mon, Oct 03, 2011 at 6:15:03AM , Arnd Bergmann wrote:
> > It's a bug that I only observed on exynos4, and it could be that
> > this patch didn't actually solve it in the end. I'll drop it for
> > now and do a better report when the problem comes back.
> 
> Could you please explain problem which observed on exynos4?
> If possible, I want to check it too.

Sorry, I can't reproduce it any more. It could have been something
unrelated like a Kconfig or toolchain problem that got fixed in
the meantime. I really should have dropped that one hunk from
the patch. The other problem in this patch is still there, with
CONFIG_SND_SOC_SMDK_WM8994_PCM=y and CONFIG_MFD_WM8994=n:

sound/built-in.o: In function `wm8994_resume':
last.c:(.text+0x1f600): undefined reference to `wm8994_reg_read'
sound/built-in.o: In function `wm8994_read':
last.c:(.text+0x20160): undefined reference to `wm8994_reg_read'
sound/built-in.o: In function `wm8994_codec_probe':
last.c:(.text+0x2029c): undefined reference to `wm8994_reg_read'
last.c:(.text+0x20480): undefined reference to `wm8994_reg_read'
last.c:(.text+0x204b4): undefined reference to `wm8994_reg_read'
sound/built-in.o: In function `wm8994_write':
last.c:(.text+0x20e68): undefined reference to `wm8994_reg_write'
last.c:(.text+0x20ea4): undefined reference to `wm8994_reg_write'
sound/built-in.o: In function `wm8958_dsp2_fw':
last.c:(.text+0x2159c): undefined reference to `wm8994_bulk_write'

	Arnd
