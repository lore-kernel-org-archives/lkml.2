Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933524Ab1KBQey (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Nov 2011 12:34:54 -0400
Received: from hqemgate03.nvidia.com ([216.228.121.140]:9724 "EHLO
	hqemgate03.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932601Ab1KBQeu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Nov 2011 12:34:50 -0400
X-PGP-Universal: processed;
	by hqnvupgp08.nvidia.com on Wed, 02 Nov 2011 09:34:41 -0700
From: Stephen Warren <swarren@nvidia.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>,
        Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Date: Wed, 2 Nov 2011 09:34:40 -0700
Subject: RE: [PATCH] arm/tegra: remove unused defines
Thread-Topic: [PATCH] arm/tegra: remove unused defines
Thread-Index: AcyZc6dGiJflCwMiR7OXgfKxO1X9rQACUu7g
Message-ID: <74CDBE0F657A3D45AFBB94109FB122FF173F9A46E0@HQMAIL01.nvidia.com>
References: <1320247524-22425-1-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1320247524-22425-1-git-send-email-pdeschrijver@nvidia.com>
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

Peter De Schrijver wrote at Wednesday, November 02, 2011 9:25 AM:
> PPI_NR is never used in arch/arm/mach-tegra/irq.c. Remove it.
> 
> Signed-off-by: Peter De Schrijver <pdeschrijver@nvidia.com>

Acked-by: Stephen Warren <swarren@nvidia.com>

For reference, I investigated why the defines aren't used, and found:

Those defines were introduced by:

commit 460907bc26f5565aced3cf35a10e3579c671ef50
[ARM] tegra: add suspend and mirror irqs to legacy controller

3524b70ef3336a4f1351a489e83894b88106ab7c moved those defines
into legacy_irq.c (and appears to have added define NUM_ICTLRS to replace
them) and d1d8c666683cdbef18329ff8f3743ddaca8842ee moved them back.

> -#define INT_SYS_NR	(INT_GPIO_BASE - INT_PRI_BASE)
> -#define INT_SYS_SZ	(INT_SEC_BASE - INT_PRI_BASE)
> -#define PPI_NR		((INT_SYS_NR+INT_SYS_SZ-1)/INT_SYS_SZ)

-- 
nvpublic

