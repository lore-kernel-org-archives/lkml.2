Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756292Ab2ADQWd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 11:22:33 -0500
Received: from imr4.ericy.com ([198.24.6.9]:59341 "EHLO imr4.ericy.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756103Ab2ADQWb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 11:22:31 -0500
Message-ID: <1325694036.26706.27.camel@groeck-laptop>
Subject: RE: [linux-pm] [lm-sensors] [RFC PATCH 2/3] thermal: exynos4:
 Register the tmu sensor with the thermal interface layer
From: Guenter Roeck <guenter.roeck@ericsson.com>
Reply-To: guenter.roeck@ericsson.com
To: "R, Durgadoss" <durgadoss.r@intel.com>
CC: Amit Kachhap <amit.kachhap@linaro.org>,
        Donggeun Kim <dg77.kim@samsung.com>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linaro-dev@lists.linaro.org" <linaro-dev@lists.linaro.org>,
        "patches@linaro.org" <patches@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "lm-sensors@lm-sensors.org" <lm-sensors@lm-sensors.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-pm@lists.linux-foundation.org" 
	<linux-pm@lists.linux-foundation.org>
Date: Wed, 4 Jan 2012 08:20:36 -0800
In-Reply-To: <4D68720C2E767A4AA6A8796D42C8EB5901B976@BGSMSX101.gar.corp.intel.com>
References: <1324468798-20423-1-git-send-email-amit.kachhap@linaro.org>
	 <1324468798-20423-3-git-send-email-amit.kachhap@linaro.org>
	 <1325629553.26706.11.camel@groeck-laptop>
	 <CAK44p20XeLVkJyox2SsDqyy=RYgEQNpyGGypwTMPXpueQT1T3g@mail.gmail.com>
	 <4D68720C2E767A4AA6A8796D42C8EB5901B976@BGSMSX101.gar.corp.intel.com>
Organization: Ericsson
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-01-04 at 05:23 -0500, R, Durgadoss wrote:
> Hi Amit Daniel,
> 
> > Hi Guenter,
> > 
> > The main idea of this work is to leave the current userspace based
> > notification scheme and add the kernel based cooling scheme on top of
> > it. Anyway, It is a good idea to move the file hwmon/exynos4_tmu.c as
> 
> But, What I feel is, kernel based cooling scheme will work only for
> Controlling 'CPU' frequency. But in SoC's there are other devices that
> Contribute to Thermal. For example, GPU, Display, Battery (during charging)
> etc.. In this case, we need a user space to control these devices. So, in a
> way, the user space notification mechanism is a unified solution for
> throttling all devices and keeps the kernel code light weight.
> 
> I am also curious to know why the existing mechanism did not work for you ?
> 
That is one question. 

For me, the main concern is that the proposed implementation creates
duplicate hwmon entries for the same device, which is simply messy. If
both the kernel thermal mechanism and the userspace mechanism are
needed, I think it would make more sense to use a thermal driver and
have that thermal driver generate the necessary userspace events.

Thanks,
Guenter

> Thanks,
> Durga
> 
> > this creates 2 hwmon entries.
> > Adding CC: Donggeun Kim to know his opinion.
> > 
> > Thanks,
> > Amit Daniel
> [snip.]


