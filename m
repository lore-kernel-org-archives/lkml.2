Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030570Ab2HHRSn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 13:18:43 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:37902 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030476Ab2HHRSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 13:18:41 -0400
Message-ID: <50229F6C.10802@wwwdotorg.org>
Date: Wed, 08 Aug 2012 11:18:36 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Laxman Dewangan <ldewangan@nvidia.com>
CC: olof@lixom.net, linux@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH 0/3] ARM: dt: tegra: cardhu: add entry for regulators
References: <1344408527-32051-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1344408527-32051-1-git-send-email-ldewangan@nvidia.com>
X-Enigmail-Version: 1.5a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/08/2012 12:48 AM, Laxman Dewangan wrote:
> This patch series add the PMIC and fixed regulators for 
> cardhu board. There is multiple versions of cardhu baord named
> as A01, A02, A03..and so on. Cardhu A01 and A03 are not supported.
> Cardhu A02 and A04 have different sets of GPIO for regualtors.
> The cardhu A04 is compatible for A05, A06 and A07 in GPIOs.
> This patch series split the cardhu dts file to cardhu-a02 and 
> carchu-a04 and then add entry for different fixed regualtors.

With this series, I see the following warnings:

tps65910 4-002d: VMBCH-Threshold not specified
tps65910 4-002d: VMBCH2-Threshold not specified

I also see the following error:

vdd_sdmmc1: Failed to request enable GPIO31: -16
reg-fixed-voltage c.regulator: Failed to register regulator: -16
reg-fixed-voltage: probe of c.regulator failed with error -16

... because both the existing SDHCI node and the new "vdd_sdmmc1_reg:
regulator@12" node both use the same GPIO.

I also don't see "pex_hvdd_3v3_reg: regulator@5" being created, for
reasons I haven't tracked down.

Note that I have a Cardhu A02, although all the issues are with
regulators in the common file.

Can you please fix these, roll in the fixes for the board ID comment
issues I mentioned before, retest to ensure there are no errors and that
all regulators get created as expected, and resubmit.

Thanks.
