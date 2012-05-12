Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755804Ab2ELPls (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 11:41:48 -0400
Received: from imr4.ericy.com ([198.24.6.9]:45715 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753670Ab2ELPlo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 11:41:44 -0400
Date: Sat, 12 May 2012 08:38:05 -0700
From: Guenter Roeck <guenter.roeck@ericsson.com>
To: Amit Daniel Kachhap <amit.kachhap@linaro.org>
CC: "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "durgadoss.r@intel.com" <durgadoss.r@intel.com>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "rui.zhang@intel.com" <rui.zhang@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "khali@linux-fr.org" <khali@linux-fr.org>,
        "patches@linaro.org" <patches@linaro.org>
Subject: Re: [PATCH v4 2/5] hwmon: exynos4: Move thermal sensor driver to
 driver/thermal directory
Message-ID: <20120512153805.GB5769@ericsson.com>
References: <1336815645-29625-1-git-send-email-amit.kachhap@linaro.org>
 <1336815645-29625-3-git-send-email-amit.kachhap@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <1336815645-29625-3-git-send-email-amit.kachhap@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 12, 2012 at 05:40:42AM -0400, Amit Daniel Kachhap wrote:
> This movement is needed because the hwmon entries and corresponding
> sysfs interface is a duplicate of utilities already provided by
> driver/thermal/thermal_sys.c. The goal is to place it in thermal folder
> and add necessary functions to use the in-kernel thermal interfaces.
> 
> CC: Guenter Roeck <guenter.roeck@ericsson.com>
> Signed-off-by: Amit Daniel Kachhap <amit.kachhap@linaro.org>
> Signed-off-by: Donggeun Kim <dg77.kim@samsung.com>

Acked-by: Guenter Roeck <guenter.roeck@ericsson.com>

Some suggestions, possibly for later cleanup.

> -
> -       data = kzalloc(sizeof(struct exynos4_tmu_data), GFP_KERNEL);

If you use devm_kzalloc, you won't have to free it.

[ ...]

> -       data->mem = request_mem_region(data->mem->start,
> -                       resource_size(data->mem), pdev->name);

Same here, with devm_request_mem_region.

[ ... ]

> -       data->base = ioremap(data->mem->start, resource_size(data->mem));

and devm_ioremap

[ ... ]

> -       ret = request_irq(data->irq, exynos4_tmu_irq,

and devm_request_irq

Guenter
