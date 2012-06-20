Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757936Ab2FTTgn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 15:36:43 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38258 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757885Ab2FTTgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 15:36:41 -0400
Message-ID: <4FE225F3.4080806@mvista.com>
Date: Wed, 20 Jun 2012 23:35:15 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120614 Thunderbird/13.0.1
MIME-Version: 1.0
To: Ralf Baechle <ralf@linux-mips.org>
CC: Kelvin Cheung <keguang.zhang@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, wuzhangjin@gmail.com, zhzhl555@gmail.com
Subject: Re: [PATCH V7 2/4] MIPS: Add board support for Loongson1B
References: <1339757617-2187-1-git-send-email-keguang.zhang@gmail.com> <1339757617-2187-3-git-send-email-keguang.zhang@gmail.com> <20120620192551.GC29446@linux-mips.org>
In-Reply-To: <20120620192551.GC29446@linux-mips.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 06/20/2012 11:25 PM, Ralf Baechle wrote:

>> +#include <linux/clk.h>

>> +static LIST_HEAD(clocks);
>> +static DEFINE_MUTEX(clocks_mutex);
>> +
>> +struct clk *clk_get(struct device *dev, const char *name)
>> +{
>> +	struct clk *c;
>> +	struct clk *ret = NULL;
>> +
>> +	mutex_lock(&clocks_mutex);
>> +	list_for_each_entry(c, &clocks, node) {
>> +		if (!strcmp(c->name, name)) {
>> +			ret = c;
>> +			break;
>> +		}
>> +	}
>> +	mutex_unlock(&clocks_mutex);
>> +
>> +	return ret;
>> +}
>> +EXPORT_SYMBOL(clk_get);

> This redefines a function that already is declared in <linux/clk.h> and
> defined in drivers/clk/clkdev.c.  Why?

    Because he doesn't support clkdev? clkdev support is optional.

>> +int clk_register(struct clk *clk)
>> +{
>> +	mutex_lock(&clocks_mutex);
>> +	list_add(&clk->node, &clocks);
>> +	if (clk->ops->init)
>> +		clk->ops->init(clk);
>> +	mutex_unlock(&clocks_mutex);
>> +
>> +	return 0;
>> +}
>> +EXPORT_SYMBOL(clk_register);

> Same here.

>    Ralf

WBR, Sergei
