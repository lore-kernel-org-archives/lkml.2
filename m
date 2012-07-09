Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753206Ab2GIKz2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 06:55:28 -0400
Received: from na3sys009aog132.obsmtp.com ([74.125.149.250]:60932 "EHLO
	na3sys009aog132.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752128Ab2GIKz1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 06:55:27 -0400
MIME-Version: 1.0
In-Reply-To: <1341826026-6504-4-git-send-email-vincent.guittot@linaro.org>
References: <1341826026-6504-1-git-send-email-vincent.guittot@linaro.org> <1341826026-6504-4-git-send-email-vincent.guittot@linaro.org>
From: "Shilimkar, Santosh" <santosh.shilimkar@ti.com>
Date: Mon, 9 Jul 2012 16:25:06 +0530
Message-ID: <CAMQu2gydOEVK_fzmzkdrBwBfOq6eZG=0QfLUfFChWJu9unSn2A@mail.gmail.com>
Subject: Re: [PATCH v4 3/5] ARM: topology: Update cpu_power according to DT information
To: Vincent Guittot <vincent.guittot@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, devicetree-discuss@lists.ozlabs.org,
        linux@arm.linux.org.uk, a.p.zijlstra@chello.nl,
        grant.likely@secretlab.ca, rob.herring@calxeda.com,
        yong.zhang0@gmail.com, namhyung@kernel.org, jean.pihet@newoldbits.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vincent,
On Mon, Jul 9, 2012 at 2:57 PM, Vincent Guittot
<vincent.guittot@linaro.org> wrote:
> Use cpu compatibility field and clock-frequency field of DT to
> estimate the capacity of each core of the system and to update
> the cpu_power field accordingly.
> This patch enables to put more running tasks on big cores than
> on LITTLE ones. But this patch doesn't ensure that long running
> tasks will run on big cores and short ones on LITTLE cores.
>
> Signed-off-by: Vincent Guittot <vincent.guittot@linaro.org>
> Reviewed-by: Namhyung Kim <namhyung@kernel.org>
> ---
>  arch/arm/kernel/topology.c |  153 ++++++++++++++++++++++++++++++++++++++++++++
>  1 file changed, 153 insertions(+)
>
Sorry for not giving this comment on previous version but we should also
have a way to provide the big.LITTLE information without Device Tree.
May be a platform device/data.

I know we are moving DT way, but remember apart from core kernel
infrastructure, to have a complete product build with DT means all the
drivers must be already supporting DT which is not the case with
many huge driver sub-systems like USB, display subsystem, Audio etc.

Having that support would greatly help for the SOC's which have not yet
reached to stage where entire SOC is DT compliant and want to use
big.LITTLE infrastructure.

Regards
Santosh
