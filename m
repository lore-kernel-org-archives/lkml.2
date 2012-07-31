Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755474Ab2GaSNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 14:13:49 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:64572 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755085Ab2GaSNs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 14:13:48 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chao Xie <xiechao.mail@gmail.com>
Subject: Re: [PATCH 2/5] clk: mmp: add clock definition for pxa168
Date: Tue, 31 Jul 2012 11:54:42 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: haojian.zhuang@gmail.com, mturquette@linaro.org, viresh.linux@gmail.com,
        s.hauer@pengutronix.de, chao.xie@marvell.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1343716792-10399-1-git-send-email-xiechao.mail@gmail.com> <1343716792-10399-2-git-send-email-xiechao.mail@gmail.com>
In-Reply-To: <1343716792-10399-2-git-send-email-xiechao.mail@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201207311154.42866.arnd@arndb.de>
X-Provags-ID: V02:K0:OhznCjO+lmzRBuCElHB7O9JbwTCK1x66mUh/Mnf2QbB
 PxQKW/YQ9bdJ6XEeRZYPfEnyOufvqM8ZiV0mW5kAHRWoU70sl0
 6pvxdkB2RAF2CUVUZW3afP1MQqA+cPzP0sMJp3IbiwtGh2lz5t
 jQuBEeawkOzzE7kj3Pw2MaISJx6A0D/9PidUZR+lfo7ZQcvypQ
 PJlfxxkXnxmKBiChEMVQnKUj98hZNTYb7orR5+pTn+uAw7MJT7
 T6v7XUzQ9LLWCbJQQJs+s4kBbSfDl1aLisqLmyiqqrCPHiTlcA
 44Ctn3aZwjdZqtUtAkfSnEFeHyKopnYFsPNRx8peljlWvpfmG9
 tvdEGRmvilbx+DYCiXWM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 31 July 2012, Chao Xie wrote:
> +#define APBC_RTC       APBC_REG(0x28)
> +#define APBC_TWSI0     APBC_REG(0x2c)
> +#define APBC_KPC       APBC_REG(0x30)
> +#define APBC_UART0     APBC_REG(0x00)
> +#define APBC_UART1     APBC_REG(0x04)
> +#define APBC_GPIO      APBC_REG(0x08)
> +#define APBC_PWM0      APBC_REG(0x0c)
> +#define APBC_PWM1      APBC_REG(0x10)
> +#define APBC_PWM2      APBC_REG(0x14)
> +#define APBC_PWM3      APBC_REG(0x18)
> +#define APBC_SSP0      APBC_REG(0x81c)
> +#define APBC_SSP1      APBC_REG(0x820)
> +#define APBC_SSP2      APBC_REG(0x84c)
> +#define APBC_SSP3      APBC_REG(0x858)
> +#define APBC_SSP4      APBC_REG(0x85c)
> +#define APBC_TWSI1     APBC_REG(0x6c)
> +#define APBC_UART2     APBC_REG(0x70)
> +
> +#define APMU_SDH0      APMU_REG(0x54)
> +#define APMU_SDH1      APMU_REG(0x58)
> +#define APMU_USB       APMU_REG(0x5c)
> +#define APMU_DISP0     APMU_REG(0x4c)
> +#define APMU_CCIC0     APMU_REG(0x50)
> +#define APMU_DFC       APMU_REG(0x60)

Same comment as for patch 1: get the address from the device tree and just
define those macros to the offset, like:

#define APBC_RTC       0x28

apbc_clks[rtc_clk] = mmp_clk_register_apbc(rtc_clk, clk32k, APBC_RTC, 10, APBC_POWER_CTRL, mmp_clk_lock);
clk_register_clkdev(apbc_clks[rtc_clk], NULL, "sa1100-rtc");

	Arnd

