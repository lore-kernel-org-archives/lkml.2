Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759501Ab0HLC54 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 22:57:56 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58039 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759233Ab0HLC5y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 22:57:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:organization:to:subject:date:user-agent:cc:references
         :in-reply-to:mime-version:content-type:content-transfer-encoding
         :message-id;
        b=n9iwkDdJ06RABv8GSEOya74RcfwF4/1A2NsFK0KyJMhbdgGWj4nmkRI7MZClQtQ0/Z
         tB/hUj9nmy5akuOeOAOSR8EPy/p+r8Q5J8IrixO95BMQDi1Uj7nlHBvCwc0lzPI1TALR
         piDRIxZ7pusdKu9k2wuzZrrEa8hJmOm3LMkAQ=
From: Marek Vasut <marek.vasut@gmail.com>
Organization: Hack&Dev
To: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2 v2] ARM: Fix gen_nand probe structures contents
Date: Thu, 12 Aug 2010 04:57:25 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.34-1-amd64; KDE/4.4.4; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux@arm.linux.org.uk,
        nico@fluxnic.net, kernel@wantstofly.org, kernel@pengutronix.de,
        u.kleine-koenig@pengutronix.de, kaloz@openwrt.org, khc@pm.waw.pl,
        tj@kernel.org, gregkh@suse.de, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Artem.Bityutskiy@nokia.com,
        David.Woodhouse@intel.com, ralf@linux-mips.org, vapier@gentoo.org,
        michael.hennerich@analog.com, barry.song@analog.com,
        sonic.zhang@analog.com, cliff.cai@analog.com,
        uclinux-dist-devel@blackfin.uclinux.org, yakovenkov@gmail.com,
        w.sang@pengutronix.de
References: <1281581635-26213-1-git-send-email-marek.vasut@gmail.com>
In-Reply-To: <1281581635-26213-1-git-send-email-marek.vasut@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201008120457.25635.marek.vasut@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne Čt 12. srpna 2010 04:53:54 Marek Vasut napsal(a):
> These three platforms didn't properly fill nr_chips in gen_nand
> registration and therefore depended on gen_nand bug fixed by the following
> patch:
> 

NOTE for bfin guys: I'm slightly concerned about overall code quality on the 
BFIN architecture. Maybe someone should run it through checkpatch or something.

> "mtd: gen_nand: fix support for multiple chips"
> 
> Signed-off-by: Marek Vasut <marek.vasut@gmail.com>
> ---
> v2: Added other broken boards outside arch-arm (mips and bfin)
> v1: Initial patch
> 
>  arch/arm/mach-ixp4xx/ixdp425-setup.c      |    1 +
>  arch/arm/mach-mx3/mach-qong.c             |    1 +
>  arch/arm/mach-orion5x/ts78xx-setup.c      |    1 +
>  arch/blackfin/mach-bf537/boards/stamp.c   |    1 +
>  arch/blackfin/mach-bf561/boards/acvilon.c |    1 +
>  arch/mips/nxp/pnx833x/common/platform.c   |    1 +
>  6 files changed, 6 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/arm/mach-ixp4xx/ixdp425-setup.c
> b/arch/arm/mach-ixp4xx/ixdp425-setup.c index 827cbc4..ea9ee4e 100644
> --- a/arch/arm/mach-ixp4xx/ixdp425-setup.c
> +++ b/arch/arm/mach-ixp4xx/ixdp425-setup.c
> @@ -100,6 +100,7 @@ ixdp425_flash_nand_cmd_ctrl(struct mtd_info *mtd, int
> cmd, unsigned int ctrl)
> 
>  static struct platform_nand_data ixdp425_flash_nand_data = {
>  	.chip = {
> +		.nr_chips		= 1,
>  		.chip_delay		= 30,
>  		.options		= NAND_NO_AUTOINCR,
>  #ifdef CONFIG_MTD_PARTITIONS
> diff --git a/arch/arm/mach-mx3/mach-qong.c b/arch/arm/mach-mx3/mach-qong.c
> index e5b5b83..1f9363f 100644
> --- a/arch/arm/mach-mx3/mach-qong.c
> +++ b/arch/arm/mach-mx3/mach-qong.c
> @@ -169,6 +169,7 @@ static void qong_nand_select_chip(struct mtd_info *mtd,
> int chip)
> 
>  static struct platform_nand_data qong_nand_data = {
>  	.chip = {
> +		.nr_chips		= 1,
>  		.chip_delay		= 20,
>  		.options		= 0,
>  	},
> diff --git a/arch/arm/mach-orion5x/ts78xx-setup.c
> b/arch/arm/mach-orion5x/ts78xx-setup.c index 5041d1b..696b1a9 100644
> --- a/arch/arm/mach-orion5x/ts78xx-setup.c
> +++ b/arch/arm/mach-orion5x/ts78xx-setup.c
> @@ -216,6 +216,7 @@ static struct mtd_partition ts78xx_ts_nand_parts[] = {
> 
>  static struct platform_nand_data ts78xx_ts_nand_data = {
>  	.chip	= {
> +		.nr_chips		= 1,
>  		.part_probe_types	= ts_nand_part_probes,
>  		.partitions		= ts78xx_ts_nand_parts,
>  		.nr_partitions		= ARRAY_SIZE(ts78xx_ts_nand_parts),
> diff --git a/arch/blackfin/mach-bf537/boards/stamp.c
> b/arch/blackfin/mach-bf537/boards/stamp.c index 9eaf5b0..68a27bc 100644
> --- a/arch/blackfin/mach-bf537/boards/stamp.c
> +++ b/arch/blackfin/mach-bf537/boards/stamp.c
> @@ -400,6 +400,7 @@ static int bfin_plat_nand_dev_ready(struct mtd_info
> *mtd)
> 
>  static struct platform_nand_data bfin_plat_nand_data = {
>  	.chip = {
> +		.nr_chips = 1,
>  		.chip_delay = 30,
>  #ifdef CONFIG_MTD_PARTITIONS
>  		.part_probe_types = part_probes,
> diff --git a/arch/blackfin/mach-bf561/boards/acvilon.c
> b/arch/blackfin/mach-bf561/boards/acvilon.c index bfcfa86..35b6d12 100644
> --- a/arch/blackfin/mach-bf561/boards/acvilon.c
> +++ b/arch/blackfin/mach-bf561/boards/acvilon.c
> @@ -284,6 +284,7 @@ static int bfin_plat_nand_dev_ready(struct mtd_info
> *mtd)
> 
>  static struct platform_nand_data bfin_plat_nand_data = {
>  	.chip = {
> +		 .nr_chips = 1,
>  		 .chip_delay = 30,
>  #ifdef CONFIG_MTD_PARTITIONS
>  		 .part_probe_types = part_probes,
> diff --git a/arch/mips/nxp/pnx833x/common/platform.c
> b/arch/mips/nxp/pnx833x/common/platform.c index 01f8345..ce45df1 100644
> --- a/arch/mips/nxp/pnx833x/common/platform.c
> +++ b/arch/mips/nxp/pnx833x/common/platform.c
> @@ -266,6 +266,7 @@ pnx833x_flash_nand_cmd_ctrl(struct mtd_info *mtd, int
> cmd, unsigned int ctrl)
> 
>  static struct platform_nand_data pnx833x_flash_nand_data = {
>  	.chip = {
> +		.nr_chips		= 1,
>  		.chip_delay		= 25,
>  		.part_probe_types 	= part_probes,
>  	},
