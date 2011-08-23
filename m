Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755863Ab1HWRnA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 13:43:00 -0400
Received: from oproxy8-pub.bluehost.com ([69.89.22.20]:42297 "HELO
	oproxy8-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755645Ab1HWRmz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 13:42:55 -0400
Date: Tue, 23 Aug 2011 10:42:53 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        alsa-devel@alsa-project.org
Subject: Re: [linux-next] ASoC: build failure if CONFIG_I2C=m &&
 CONFIG_SPI=y && CONFIG_SND_SOC=y
Message-Id: <20110823104253.d7768c82.rdunlap@xenotime.net>
In-Reply-To: <1314099960.13722.1.camel@phoenix>
References: <1314099960.13722.1.camel@phoenix>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Aug 2011 19:46:00 +0800 Axel Lin wrote:

> 
> hi,
> I got below build failure if CONFIG_I2C=m && CONFIG_SPI=y && CONFIG_SND_SOC=y
> 
>   LD      .tmp_vmlinux1
> sound/built-in.o: In function `snd_soc_codec_set_cache_io':
> last.c:(.text+0x1cb80): undefined reference to `regmap_init_i2c'
> make: *** [.tmp_vmlinux1] Error 1


I don't know if this is the same failure or just similar:

ERROR: "regmap_exit" [drivers/mfd/wm8400-core.ko] undefined!
ERROR: "regmap_bulk_read" [drivers/mfd/wm8400-core.ko] undefined!
ERROR: "regmap_read" [drivers/mfd/wm8400-core.ko] undefined!
ERROR: "regmap_init_i2c" [drivers/mfd/wm8400-core.ko] undefined!
ERROR: "regmap_raw_read" [drivers/mfd/wm8400-core.ko] undefined!
ERROR: "regmap_write" [drivers/mfd/wm8400-core.ko] undefined!

Maybe MFD_WM8400 needs to select REGMAP_I2C ?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
