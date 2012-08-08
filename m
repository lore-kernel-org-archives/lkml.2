Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758856Ab2HHQay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 12:30:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:52426 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752588Ab2HHQaw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 12:30:52 -0400
Message-ID: <50229439.3090401@wwwdotorg.org>
Date: Wed, 08 Aug 2012 10:30:49 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: olof@lixom.net, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 2/3] ARM: dt: tegra: cardhu: split dts file for support
 multiple board versions
References: <1344408527-32051-1-git-send-email-ldewangan@nvidia.com> <1344408527-32051-3-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1344408527-32051-3-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 12:48 AM, Laxman Dewangan wrote:
> There is multiple version of cardhu starting from A01 to A07.
> Cardhu A01 and A03 are not supported. Cardhu A02 will have
> different sets of GPIOs for fixed regulator compare to
> cardhu A04. The Cardhu A05, A06, A07 are compatibe with A04.
> Based on cardhu version, the related dts file need to be chosen
> like for cardhu A02, use tegra30-cardhu-a02.dts, cardhu A04 and
> more, use tegra30-cardhu-a04.dts.
> This patch create the DTS file A02 and A04 and convert tegra30-cardhu.dts
> as dts include file.
> 

> diff --git a/arch/arm/boot/dts/tegra30-cardhu.dts b/arch/arm/boot/dts/tegra30-cardhu.dtsi

> +/**
> + * This file contains common DT entry for all fab version of Cardhu.
> + * There is multiple fab version of Cardhu starting from A01 to A07.
> + * Cardhu fab version A01 and A03 are not supported. Cardhu fab version
> + * A02 will have different sets of GPIOs for fixed regulator compare to
> + * Cardhu fab version A04. The Cardhu fab version A05, A06, A07 are
> + * compatible with fab version A04. Based on Cardhu fab version, the
> + * related dts file need to be chosen like for Cardhu fab version A02,
> + * use tegra30-cardhu-a02.dts, Cardhu fab version A04 and later, use
> + * tegra30-cardhu-a04.dts.
> + * The identification of board is done in two ways, by looking the sticker
> + * on PCB and by reading board id eeprom.
> + * The stciker will have number like 600-81291-1000-002 C.3. In this 4th
> + * number is the fab version like here it is 002 and hence fab version A02.
> + * The The (downstream internal) U-Boot of Cardhu display the board-id as

"The The"

> + * follows:
> + * BoardID: 0C5B, SKU: 0A01, Fab: 02, Rev: 45.00
> + * In this Fab version is 02 i.e. A02.
> + * The BoardID eeprom is interfaced through i2c5 (pwr_i2c). The location 0x8
> + * contains the Fab version. It is 1 byte wide.

That should also mention the Board ID EEPROM's I2C address (0x56).

I can fix up these two issues when I apply the patches.
