Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932423Ab2ARRyf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jan 2012 12:54:35 -0500
Received: from hqemgate03.nvidia.com ([216.228.121.140]:8767 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932396Ab2ARRyd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jan 2012 12:54:33 -0500
X-PGP-Universal: processed;
	by hqnvupgp06.nvidia.com on Wed, 18 Jan 2012 09:54:28 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Laxman Dewangan <ldewangan@nvidia.com>, "lrg@ti.com" <lrg@ti.com>,
        "broonie@opensource.wolfsonmicro.com" 
	<broonie@opensource.wolfsonmicro.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
CC: "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Laxman Dewangan <ldewangan@nvidia.com>
Date: Wed, 18 Jan 2012 09:54:27 -0800
Subject: RE: [PATCH V1 2/2] regulator: tps65910: Initialize n_voltages for
 rails.
Thread-Topic: [PATCH V1 2/2] regulator: tps65910: Initialize n_voltages for
 rails.
Thread-Index: AczV9E+GbYWK/Q9iTv6L3FiCavWhTAAFYz8g
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1780DAAE10@HQMAIL01.nvidia.com>
References: <1326899836-14470-1-git-send-email-ldewangan@nvidia.com>
In-Reply-To: <1326899836-14470-1-git-send-email-ldewangan@nvidia.com>
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

Laxman Dewangan wrote at Wednesday, January 18, 2012 8:17 AM:
> Initializing the number of voltages supported by different
> rails of pmic device tps65911.
...
> diff --git a/drivers/regulator/tps65910-regulator.c b/drivers/regulator/tps65910-regulator.c
...
> @@ -188,56 +188,67 @@ static struct tps_info tps65911_regs[] = {
>  		.name = "VDD1",
>  		.min_uV = 600000,
>  		.max_uV = 4500000,
> +		.table_len = 73,
>  	},

Forgive me if these comments are bogus since I'm not familiar with
regulators much, but:

a) Don't you want to use ARRAY_SIZE() instead of hard-coding table_len's
value?

b) Don't you need to set .table to actually point at the table too? If not,
isn't tps65910_list_voltage() going to dereference a NULL pointer, since
it will dereference .table if .table_len is set?

-- 
nvpublic

