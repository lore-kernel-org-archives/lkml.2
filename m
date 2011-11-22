Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755111Ab1KVSBx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 13:01:53 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45880 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752371Ab1KVSBw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 13:01:52 -0500
MIME-Version: 1.0
In-Reply-To: <CACxGe6sOd6MiyYaok6BsihJtp-NNsm3WQf+aUPGMRFRpSLw2mQ@mail.gmail.com>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
 <1321926047-14211-6-git-send-email-mturquette@linaro.org> <CACxGe6sOd6MiyYaok6BsihJtp-NNsm3WQf+aUPGMRFRpSLw2mQ@mail.gmail.com>
From: Mike Turquette <mturquette@linaro.org>
Date: Tue, 22 Nov 2011 10:01:30 -0800
Message-ID: <CAPtuhTheG-mvoGMaB2y9BSKF-abm2yigoN-SXaeCb+P5R6t_Dg@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] clk: export tree topology and clk data via sysfs
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Mike Turquette <mturquette@ti.com>, broonie@opensource.wolfsonmicro.com,
        sboyd@quicinc.com, eric.miao@linaro.org, linaro-dev@lists.linaro.org,
        linux-omap@vger.kernel.org, arnd.bergmann@linaro.org,
        jeremy.kerr@canonical.com, dsaxena@linaro.org, shawn.guo@freescale.com,
        linus.walleij@stericsson.com, skannan@quicinc.com,
        richard.zhao@linaro.org, linux-arm-kernel@lists.infradead.org,
        tglx@linutronix.de, aul@pwsan.com, linux@arm.linux.org.uk,
        magnus.damm@gmail.com, linux-kernel@vger.kernel.org,
        amit.kucheria@linaro.org, patches@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 8:37 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>
> On Nov 21, 2011 6:43 PM, "Mike Turquette" <mturquette@ti.com> wrote:
>>
>> Introduces kobject support for the common struct clk, exports per-clk
>> data via read-only callbacks and models the clk tree topology in sysfs.
>>
>> Also adds support for generating the clk tree in clk_init and migrating
>> nodes when input sources are switches in clk_set_parent.
>
> I'm not convinced this is a good idea. What is the use case for exporting
> the clock tree? If it is debug, then I suggest using debugfs to avoid abi
> issues.

Each clk exports clk_rate, clk_flags, clk_enable_count &
clk_prepare_count as Read-Only.  I think this is very reasonable to
have in sysfs, which maps the topology of the system with key details.

Others have requested to have knobs made available for actually
performing clk_enable/clk_disable and even clk_set_rate from
userspace.  I hate this idea and won't implement it.  I encourage
anyone that needs this to do it in debugfs.

Does that work-split make sense to you, or do you still not like the
idea of having topology and read-only info in sysfs?

Regards,
Mike

>
> g.
