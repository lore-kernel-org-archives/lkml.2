Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750760Ab2JHGcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 02:32:21 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:55753 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752094Ab2JHGcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 02:32:17 -0400
MIME-Version: 1.0
In-Reply-To: <2779610.RIGYtRk86h@amdc1227>
References: <1349093361-18820-1-git-send-email-thomas.abraham@linaro.org>
	<2779610.RIGYtRk86h@amdc1227>
Date: Mon, 8 Oct 2012 12:02:15 +0530
Message-ID: <CAJuYYwSWL9e+php9B2bJ4GQ9AGLK32=q+0pFeSNHUMfhFNruoQ@mail.gmail.com>
Subject: Re: [PATCH 0/2] ARM: Exynos4: Migrate to common clock framework.
From: Thomas Abraham <thomas.abraham@linaro.org>
To: Tomasz Figa <t.figa@samsung.com>
Cc: chander.kashyap@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, kgene.kim@samsung.com,
        mturquette@linaro.org, mturquette@ti.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tomasz,

Thanks for reviewing this patch series.

On 3 October 2012 16:26, Tomasz Figa <t.figa@samsung.com> wrote:
> Hi Chander, Thomas,
>
> On Monday 01 of October 2012 17:39:19 chander.kashyap@linaro.org wrote:
>> From: Thomas Abraham <thomas.abraham@linaro.org>
>>
>> This patch series migrates Exynos4 clock support to common clock
>> framework. The first patch in this series removes the existing Exynos4
>> clock support that uses the Samsung specific clock framework. The second
>> patch in this series add Exynos4 clock support using common clock
>> framework.
>>
>> Thomas Abraham (2):
>>   ARM: Exynos4: Remove Samsung clock type support
>>   ARM: Exynos4: Register clocks via common clock framework
>
> I think the order of changes is a little bit off here:
>  - patch 1 will break all exynos4-based boards (what about bisects?)
>  - patch 2 will be still broken until all related drivers get converted to
> use clk_prepare(_enable) and clk_(disable_)unprepare.

Ok. I got the sequence wrong and I have fixed this in the next version.

>
> Shouldn't the order be exactly opposite, i.e.:
>  - all the patches for prepare/unprepare first
>  - then the patch adding common clock frameworks support for exynos4
> (disabling the old clock code)
>  - and finally the patch removing remaining (disabled by previous patch)
> code.

Right.

>
> Also, I assume that these patches doesn't consider native device tree
> support (without auxdata, using OF-based clock lookup), correct me if I'm
> wrong. If I'm right, since Exynos SoCs are going to be DT-only, is there
> really a point for adding common clock framework support for non-DT
> platforms (which are going to be eventually dropped anyway)?

The non-dt Exynos4 platforms require some effort to get basic device
tree support into them. Until then, the common clock support for them
are required. I have added device tree support as well in the second
version of this patch series.

Thanks,
Thomas.

>
> Best regards,
> --
> Tomasz Figa
> Samsung Poland R&D Center
>
