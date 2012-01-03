Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753160Ab2ACNLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jan 2012 08:11:17 -0500
Received: from am1ehsobe002.messaging.microsoft.com ([213.199.154.205]:30020
	"EHLO AM1EHSOBE002.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752181Ab2ACNLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jan 2012 08:11:15 -0500
X-SpamScore: -13
X-BigFish: VPS-13(zz98dKzz1202hzz15d4Rz2dh668h839h944h)
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-FB-SS: 13,
X-WSS-ID: 0LX84MG-02-DTU-02
X-M-MSG: 
Date: Tue, 3 Jan 2012 14:10:48 +0100
From: "'Joerg Roedel'" <joerg.roedel@amd.com>
To: Marek Szyprowski <m.szyprowski@samsung.com>
CC: "'KyongHo Cho'" <pullip.cho@samsung.com>,
        "'Kukjin Kim'" <kgene.kim@samsung.com>,
        "'Subash Patel'" <subash.ramaswamy@linaro.org>,
        <linux-kernel@vger.kernel.org>,
        "'Younglak Kim'" <younglak1004.kim@samsung.com>,
        <iommu@lists.linux-foundation.org>,
        <linux-samsung-soc@vger.kernel.org>,
        "'Kyungmin Park'" <kyungmin.park@samsung.com>,
        "'Sanghyun Lee'" <sanghyun75.lee@samsung.com>,
        <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v8 0/2] ommu/exynos: Add IOMMU/System MMU driver for
 Samsung Exynos
Message-ID: <20120103131048.GD29877@amd.com>
References: <000e01ccc624$c9349310$5b9db930$%cho@samsung.com>
 <20120102134229.GZ29877@amd.com>
 <00dc01ccc9fb$4fcb7590$ef6260b0$%szyprowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <00dc01ccc9fb$4fcb7590$ef6260b0$%szyprowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Marek,

On Tue, Jan 03, 2012 at 10:37:29AM +0100, Marek Szyprowski wrote:
> Yes, there is something a bit wrong with your kernel configuration. You get this error if 
> there is no board selected to be compiled-in. Please go to kernel configuration and select
> "System Type -> SAMSUNG EXYNOS SoCs Suppport". Then select some hardware board to be 
> compiled in, for example SMDKV310, SMDKC210 and "Mobile NURI board".

thanks for this info. I selected a board and compile of linux-next now
fails with:

  LD      .tmp_vmlinux1
arch/arm/mach-exynos/built-in.o: In function `exynos4_pm_resume':
/data/lemmy/linux.trees.git/arch/arm/mach-exynos/pm.c:385: undefined reference to `scu_enable'
make[1]: *** [.tmp_vmlinux1] Error 1

This is because scu_enable() is only available with CONFIG_SMP=y which
is not set for Exynos.


	Joerg

-- 
AMD Operating System Research Center

Advanced Micro Devices GmbH Einsteinring 24 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Landkr. Muenchen; Registerger. Muenchen, HRB Nr. 43632

