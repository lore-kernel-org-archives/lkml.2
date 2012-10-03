Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932076Ab2JCH1H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Oct 2012 03:27:07 -0400
Received: from mailout2.samsung.com ([203.254.224.25]:32015 "EHLO
	mailout2.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754840Ab2JCH1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Oct 2012 03:27:03 -0400
X-AuditID: cbfee61a-b7f726d000000ec7-df-506be8c573d1
From: Tomasz Figa <t.figa@samsung.com>
To: chander.kashyap@linaro.org
Cc: linux-arm-kernel@lists.infradead.org, linux-samsung-soc@vger.kernel.org,
        kgene.kim@samsung.com, mturquette@linaro.org, mturquette@ti.com,
        linux-kernel@vger.kernel.org,
        Thomas Abraham <thomas.abraham@linaro.org>
Subject: Re: [PATCH 0/2] ARM: Exynos4: Migrate to common clock framework.
Date: Wed, 03 Oct 2012 09:26:50 +0200
Message-id: <2779610.RIGYtRk86h@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.9.1 (Linux/3.5.3-gentoo; KDE/4.9.1; x86_64; ; )
In-reply-to: <1349093361-18820-1-git-send-email-thomas.abraham@linaro.org>
References: <1349093361-18820-1-git-send-email-thomas.abraham@linaro.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrNLMWRmVeSWpSXmKPExsVy+t9jQd2jL7IDDL6c4be4vGsOm8WM8/uY
	HJg8Pm+SC2CM4rJJSc3JLEst0rdL4Mo4+uk5a8F0nopd3SsYGxhfc3YxcnBICJhIzLoX3MXI
	CWSKSVy4t56ti5GLQ0hgOqPElUn7GSGcFiaJt9/fs4NUsQmoSXxueMQGYosIyEks37uLGaSI
	WeAWo8Tac/dZQRLCAp4Sv4/fYgKxWQRUJZ5seQsW5xXQlHhydT1YM7+AusS7bU/BakQFnCWu
	NC5iBLE5Bbwkvs88C2YLAc3pfzidDaJXUOLH5HssIDazgLzEvv1TWSFsLYn1O48zTWAUnIWk
	bBaSsllIyhYwMq9iFE0tSC4oTkrPNdQrTswtLs1L10vOz93ECA7SZ1I7GFc2WBxiFOBgVOLh
	vcCVHSDEmlhWXJl7iFGCg1lJhNflEVCINyWxsiq1KD++qDQntfgQozQHi5I4b7NHSoCQQHpi
	SWp2ampBahFMlomDU6qBMW+OpaAc9+7rjP4qvIJvFI+vFdindEjo+Y6mPlafxmkWCoY2p7NY
	/zh9j0k8emv324N3rK3+bOpef4W7+PPyBe0OccdmZFrN/177eNtMftXqwlv8Apq/K0T3HNxw
	dXtb/ObjQrOjyru/bd0uZ3jwlMqhFb92sp2/OGv7qx9njNTtY1W/WDNIrVBiKc5INNRiLipO
	BAAfnG5nTgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Chander, Thomas,

On Monday 01 of October 2012 17:39:19 chander.kashyap@linaro.org wrote:
> From: Thomas Abraham <thomas.abraham@linaro.org>
> 
> This patch series migrates Exynos4 clock support to common clock
> framework. The first patch in this series removes the existing Exynos4
> clock support that uses the Samsung specific clock framework. The second
> patch in this series add Exynos4 clock support using common clock
> framework.
> 
> Thomas Abraham (2):
>   ARM: Exynos4: Remove Samsung clock type support
>   ARM: Exynos4: Register clocks via common clock framework

I think the order of changes is a little bit off here:
 - patch 1 will break all exynos4-based boards (what about bisects?)
 - patch 2 will be still broken until all related drivers get converted to 
use clk_prepare(_enable) and clk_(disable_)unprepare.

Shouldn't the order be exactly opposite, i.e.:
 - all the patches for prepare/unprepare first
 - then the patch adding common clock frameworks support for exynos4 
(disabling the old clock code)
 - and finally the patch removing remaining (disabled by previous patch) 
code.

Also, I assume that these patches doesn't consider native device tree 
support (without auxdata, using OF-based clock lookup), correct me if I'm 
wrong. If I'm right, since Exynos SoCs are going to be DT-only, is there 
really a point for adding common clock framework support for non-DT 
platforms (which are going to be eventually dropped anyway)?

Best regards,
-- 
Tomasz Figa
Samsung Poland R&D Center

