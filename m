Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755700Ab2AIVaU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jan 2012 16:30:20 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:15447 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751379Ab2AIVaS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jan 2012 16:30:18 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Mon, 09 Jan 2012 13:30:08 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Mon, 9 Jan 2012 13:30:05 -0800
Subject: RE: [RESEND PATCH v2 0/3] Tegra30 clockframework
Thread-Topic: [RESEND PATCH v2 0/3] Tegra30 clockframework
Thread-Index: AczO5FGAJ/ubvfjHTHqsN2lMHLf45wAMN6aw
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF177EE3A286@HQMAIL01.nvidia.com>
References: <1326123315-32670-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1326123315-32670-1-git-send-email-pdeschrijver@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peter De Schrijver wrote at Monday, January 09, 2012 8:35 AM:
> This patchset introduces the tegra30 clockframework. Clocks which require
> voltage scaling are not included in this version. The implementation doesn't
> use the generic clock code yet. It's the intention to move to it, once the
> semantics are fully clarified.
> 
> ---
> 
> Changes in v2:
>  * Fix parent clocks for TWD. This makes the SMP configuration booting again.

Peter,

This version seems to still boot as well as without these patches.

I hacked some AUXDATA into board-dt-tegra30.c in an attempt to get SDHCI
working, but found that:

a) sdhci_add_host() fails due to:

mmc0: Hardware doesn't specify timeout clock frequency.

I haven't investigated why this happens.

b) More directly related to these patches, when sdhci_add_host() fails,
sdhci_tegra_probe() calls clk_disable() and clk_put() on its clock. One
of these hangs somehow. I assume that's a bug in this clock patch?

A couple of I2C devices did end up probing OK with these patches plus
AUXDATA, although I doubt any I2C accesses were actually performed.

-- 
nvpublic

