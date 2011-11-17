Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754756Ab1KQSwn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Nov 2011 13:52:43 -0500
Received: from hqemgate04.nvidia.com ([216.228.121.35]:10254 "EHLO
	hqemgate04.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751789Ab1KQSwm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Nov 2011 13:52:42 -0500
X-PGP-Universal: processed;
	by hqnvupgp05.nvidia.com on Thu, 17 Nov 2011 10:52:23 -0800
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>, Colin Cross <ccross@android.com>,
        Olof Johansson <olof@lixom.net>, Marc Dietrich <marvin24@gmx.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>
Date: Thu, 17 Nov 2011 10:51:35 -0800
Subject: RE: [PATCH] arm/tegra: convert tegra20 to GIC devicetree binding
Thread-Topic: [PATCH] arm/tegra: convert tegra20 to GIC devicetree binding
Thread-Index: AcylOpvLhVzg82JjTLiQqijvdAcbWwAHlLYQ
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF1740D74C1E@HQMAIL01.nvidia.com>
References: <1321542430-17971-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1321542430-17971-1-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Thursday, November 17, 2011 8:07 AM:
> Convert tegra20 IRQ intialization to the GIC devicetree binding. Modify the
> interrupt definitions in the dts files according to
> Documentation/devicetree/bindings/arm/gic.txt
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

tegra-harmony.dts contains an interrupts property that wasn't updated,
for the WM8903 codec.

board-dt.c contains logic to search for a node with compatible of
nvidia,tegra20-gic, and then call irq_domain_add_simple. I assume that
logic is replaced by the new common GIC code, and so should be removed
from board-dt.c entirely?

>  	serial@70006000 {
>  		compatible = "nvidia,tegra20-uart";
> -		reg = <0x70006000 0x40>;
> +		reg = <0x70006000 0x040>;

Here and a few other places, why change the reg property?

-- 
nvpublic

