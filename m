Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753526Ab1J0QEI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 12:04:08 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:10446 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753402Ab1J0QEE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 12:04:04 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Thu, 27 Oct 2011 09:03:55 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Thu, 27 Oct 2011 09:03:54 -0700
Subject: RE: [PATCHv2] arm/tegra: clk_get should not be fatal
Thread-Topic: [PATCHv2] arm/tegra: clk_get should not be fatal
Thread-Index: AcyTuxoiKKMhQgS7Q0aR7F3FdJkY1ABBq3KA
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173E1B48B0@HQMAIL01.nvidia.com>
References: <1319618501-15020-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1319618501-15020-1-git-send-email-pdeschrijver@nvidia.com>
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

pdeschrijver@nvidia.com wrote at Wednesday, October 26, 2011 2:42 AM:
> The timer and rtc-timer clocks aren't gated by default, so there is no reason
> to crash the system if the dummy enable call failed.
...
>  	clk = clk_get_sys("timer", NULL);
> -	BUG_ON(IS_ERR(clk));
> -	clk_enable(clk);
> +	if (IS_ERR(clk))
> +		pr_warn("Unable to get timer clock\n");
> +	else
> +		clk_enable(clk);

This seems reasonable to me, and is certainly required for Tegra30 support
until we get a full clock tree set up for Tegra30, which I think we'll
probably defer until the common clock infra-structure is in place.

Acked-by: Stephen Warren <swarren@nvidia.com>

-- 
nvpublic

