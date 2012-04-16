Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab2DPXLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 19:11:23 -0400
Received: from na3sys009aog117.obsmtp.com ([74.125.149.242]:38631 "EHLO
	na3sys009aog117.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753504Ab2DPXLW convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 19:11:22 -0400
MIME-Version: 1.0
In-Reply-To: <20120412064920.GH2445@S2101-09.ap.freescale.net>
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
 <1334192572-12499-14-git-send-email-mturquette@linaro.org> <20120412064920.GH2445@S2101-09.ap.freescale.net>
From: "Turquette, Mike" <mturquette@ti.com>
Date: Mon, 16 Apr 2012 16:10:56 -0700
Message-ID: <CAJOA=zMPQK-W_nbRztXCNdLHoTJU73ZnrxAS8VvvmzgdaVS2mQ@mail.gmail.com>
Subject: Re: [PATCH 13/13] clk: basic: improve parent_names & return errors
To: Shawn Guo <shawn.guo@linaro.org>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>, patches@linaro.org,
        Sascha Hauer <s.hauer@pengutronix.de>, Rajendra Nayak <rnayak@ti.com>,
        linux-kernel@vger.kernel.org, Saravana Kannan <skannan@codeaurora.org>,
        Olof Johansson <olof@lixom.net>, linaro-dev@lists.linaro.org,
        arnd.bergmann@linaro.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 11, 2012 at 11:49 PM, Shawn Guo <shawn.guo@linaro.org> wrote:
> On Wed, Apr 11, 2012 at 06:02:51PM -0700, Mike Turquette wrote:
> ...
>> @@ -175,23 +188,32 @@ struct clk *clk_register_divider(struct device *dev, const char *name,
>>       div->flags = clk_divider_flags;
>>       div->lock = lock;
>>
>> +     /* allocate the temporary parent_names */
>>       if (parent_name) {
>> -             div->parent[0] = kstrdup(parent_name, GFP_KERNEL);
>> -             if (!div->parent[0])
>> -                     goto out;
>> +             parent_names[0] = kstrdup(parent_name, GFP_KERNEL);
>> +             if (!parent_names[0]) {
>> +                     pr_err("%s: could not allocate parent_names\n",
>> +                                     __func__);
>> +                     goto fail_parent_names;
>> +             }
>>       }
>
> Why do we need to copy the parent_names here at all?  clk_register()
> has done that for each basic clk.

Yes, this was a braindead change on my part.  I'll remove the kstrdup
in my next series (the rest of this patch will stay in).

Thanks,
Mike

> Regards,
> Shawn
