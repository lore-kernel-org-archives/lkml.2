Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab2CSGZA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 02:25:00 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:12312 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756207Ab2CSGY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 02:24:58 -0400
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Sun, 18 Mar 2012 23:24:58 -0700
Message-ID: <4F66CFF9.3010305@nvidia.com>
Date: Mon, 19 Mar 2012 11:49:37 +0530
From: Laxman Dewangan <ldewangan@nvidia.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the mfd tree
References: <20120319131345.a2f5b9983538d25c2974d344@canb.auug.org.au>
In-Reply-To: <20120319131345.a2f5b9983538d25c2974d344@canb.auug.org.au>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Monday 19 March 2012 07:43 AM, Stephen Rothwell wrote:
> * PGP Signed by an unknown key
>
> Hi Samuel,
>
> After merging the mfd tree, today's linux-next build (x86_64 allmodconfig)
> failed like this:
>
> drivers/built-in.o: In function `rc5t583_i2c_init':
> rc5t583.c:(.init.text+0xb3db): undefined reference to `i2c_register_driver'
> drivers/built-in.o: In function `rc5t583_i2c_probe':
> rc5t583.c:(.devinit.text+0x8fa0): undefined reference to `regmap_init_i2c'
> drivers/built-in.o: In function `rc5t583_i2c_exit':
> rc5t583.c:(.exit.text+0x708): undefined reference to `i2c_del_driver'
>
> Caused by commit 1b1247dd75aa ("mfd: Add support for RICOH PMIC
> RC5T583"). Presumably some missing Kconfig dependency.
>
> I have ued the version of the mfd tree from next-20120316 for today.

Sorry for inconvenience.
I sent the patch for fixing the issue as
[PATCH V1] mfd: rc5t583: Build only if I2C config is selected to y.

The issue which I saw is that if CONFIG_I2C=m then also rx5t583.c is 
gettign compiled and so generating the linking error.
With fix, compiling only if the CONFIG_i2C=y.

The change is  as follows:

--- a/drivers/mfd/Kconfig
+++ b/drivers/mfd/Kconfig
@@ -849,7 +849,7 @@ config MFD_INTEL_MSIC

  config MFD_RC5T583
         bool "Ricoh RC5T583 Power Management system device"
-       depends on I2C && GENERIC_HARDIRQS
+       depends on I2C=y && GENERIC_HARDIRQS
         select MFD_CORE
         select REGMAP_I2C
         help


