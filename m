Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755709Ab1KVT2O (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 14:28:14 -0500
Received: from mail-qy0-f174.google.com ([209.85.216.174]:43456 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754232Ab1KVT2M convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 14:28:12 -0500
MIME-Version: 1.0
In-Reply-To: <CAPtuhTheG-mvoGMaB2y9BSKF-abm2yigoN-SXaeCb+P5R6t_Dg@mail.gmail.com>
References: <1321926047-14211-1-git-send-email-mturquette@linaro.org>
 <1321926047-14211-6-git-send-email-mturquette@linaro.org> <CACxGe6sOd6MiyYaok6BsihJtp-NNsm3WQf+aUPGMRFRpSLw2mQ@mail.gmail.com>
 <CAPtuhTheG-mvoGMaB2y9BSKF-abm2yigoN-SXaeCb+P5R6t_Dg@mail.gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 22 Nov 2011 12:19:51 -0700
X-Google-Sender-Auth: G0deqs1Ygu_-GiXIjRfzeyzJwzA
Message-ID: <CACxGe6vK-vHvSbd9N2k3FZY4gGVS_DETx0BbfPgNghTkOncjpg@mail.gmail.com>
Subject: Re: [PATCH v3 5/5] clk: export tree topology and clk data via sysfs
To: Mike Turquette <mturquette@linaro.org>
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
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 22, 2011 at 11:01 AM, Mike Turquette <mturquette@linaro.org> wrote:
> On Tue, Nov 22, 2011 at 8:37 AM, Grant Likely <grant.likely@secretlab.ca> wrote:
>>
>> On Nov 21, 2011 6:43 PM, "Mike Turquette" <mturquette@ti.com> wrote:
>>>
>>> Introduces kobject support for the common struct clk, exports per-clk
>>> data via read-only callbacks and models the clk tree topology in sysfs.
>>>
>>> Also adds support for generating the clk tree in clk_init and migrating
>>> nodes when input sources are switches in clk_set_parent.
>>
>> I'm not convinced this is a good idea. What is the use case for exporting
>> the clock tree? If it is debug, then I suggest using debugfs to avoid abi
>> issues.
>
> Each clk exports clk_rate, clk_flags, clk_enable_count &
> clk_prepare_count as Read-Only.  I think this is very reasonable to
> have in sysfs, which maps the topology of the system with key details.
>
> Others have requested to have knobs made available for actually
> performing clk_enable/clk_disable and even clk_set_rate from
> userspace.  I hate this idea and won't implement it.  I encourage
> anyone that needs this to do it in debugfs.
>
> Does that work-split make sense to you, or do you still not like the
> idea of having topology and read-only info in sysfs?

Unless there is a solid real-world use case for exporting this data to
userspace, I do not think sysfs is a good idea.  As long as the usage
(beyond debug) is theoretical I think the whole thing should be in
debugfs.  It can always be moved at a later date If a real use case
does become important.

g.
