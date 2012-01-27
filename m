Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755953Ab2A0G7r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jan 2012 01:59:47 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:47187 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751917Ab2A0G7T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jan 2012 01:59:19 -0500
From: "Bedia, Vaibhav" <vaibhav.bedia@ti.com>
To: Peter De Schrijver <pdeschrijver@nvidia.com>
CC: Russell King <linux@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-tegra@vger.kernel.org" <linux-tegra@vger.kernel.org>,
        Colin Cross <ccross@android.com>, Olof Johansson <olof@lixom.net>,
        Stephen Warren <swarren@nvidia.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: RE: [PATCH v1 3/3] ARM: tegra: cpuidle driver for tegra
Thread-Topic: [PATCH v1 3/3] ARM: tegra: cpuidle driver for tegra
Thread-Index: AQHM3Efdz4WGVcb5lUWhYfrRza69QJYfx+nQ
Date: Fri, 27 Jan 2012 06:59:03 +0000
Message-ID: <B5906170F1614E41A8A28DE3B8D1214331791EA6@DBDE01.ent.ti.com>
References: <1327594923-21822-1-git-send-email-pdeschrijver@nvidia.com>
 <1327594923-21822-4-git-send-email-pdeschrijver@nvidia.com>
In-Reply-To: <1327594923-21822-4-git-send-email-pdeschrijver@nvidia.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [172.24.133.41]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 26, 2012 at 21:52:03, Peter De Schrijver wrote:
[...]
> +static int tegra_idle_enter_lp3(struct cpuidle_device *dev,
> +	struct cpuidle_driver *drv, int index)
> +{
> +	ktime_t enter, exit;
> +	s64 us;
> +
> +	local_irq_disable();
> +	local_fiq_disable();
> +
> +	enter = ktime_get();
> +
> +	tegra_cpu_wfi();
> +
> +	exit = ktime_sub(ktime_get(), enter);
> +	us = ktime_to_us(exit);
> +
> +	local_fiq_enable();
> +	local_irq_enable();
> +
> +	dev->last_residency = us;
> +
> +	return index;
> +}

You can probably drop local_irq_disable() and local_irq_enable().
