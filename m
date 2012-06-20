Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932385Ab2FTUKy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 16:10:54 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:52856 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758030Ab2FTUKc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 16:10:32 -0400
From: Florian Fainelli <florian@openwrt.org>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Kelvin Cheung <keguang.zhang@gmail.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, wuzhangjin@gmail.com, zhzhl555@gmail.com
Subject: Re: [PATCH V7 2/4] MIPS: Add board support for Loongson1B
Date: Wed, 20 Jun 2012 22:10:26 +0200
Message-ID: <1463808.aB2kcWCEuH@bender>
Organization: OpenWrt
User-Agent: KMail/4.8.3 (Linux/3.2.0-25-generic; KDE/4.8.3; x86_64; ; )
In-Reply-To: <4FE225F3.4080806@mvista.com>
References: <1339757617-2187-1-git-send-email-keguang.zhang@gmail.com> <20120620192551.GC29446@linux-mips.org> <4FE225F3.4080806@mvista.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 June 2012 23:35:15 Sergei Shtylyov wrote:
> Hello.
> 
> On 06/20/2012 11:25 PM, Ralf Baechle wrote:
> 
> >> +#include <linux/clk.h>
> 
> >> +static LIST_HEAD(clocks);
> >> +static DEFINE_MUTEX(clocks_mutex);
> >> +
> >> +struct clk *clk_get(struct device *dev, const char *name)
> >> +{
> >> +	struct clk *c;
> >> +	struct clk *ret = NULL;
> >> +
> >> +	mutex_lock(&clocks_mutex);
> >> +	list_for_each_entry(c, &clocks, node) {
> >> +		if (!strcmp(c->name, name)) {
> >> +			ret = c;
> >> +			break;
> >> +		}
> >> +	}
> >> +	mutex_unlock(&clocks_mutex);
> >> +
> >> +	return ret;
> >> +}
> >> +EXPORT_SYMBOL(clk_get);
> 
> > This redefines a function that already is declared in <linux/clk.h> and
> > defined in drivers/clk/clkdev.c.  Why?
> 
>     Because he doesn't support clkdev? clkdev support is optional.

I don't think it is a good idea not to support clkdev for new targets. Ralf 
what do you think about it?


> 
> >> +int clk_register(struct clk *clk)
> >> +{
> >> +	mutex_lock(&clocks_mutex);
> >> +	list_add(&clk->node, &clocks);
> >> +	if (clk->ops->init)
> >> +		clk->ops->init(clk);
> >> +	mutex_unlock(&clocks_mutex);
> >> +
> >> +	return 0;
> >> +}
> >> +EXPORT_SYMBOL(clk_register);
> 
> > Same here.
> 
> >    Ralf
> 
> WBR, Sergei
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
-- 
Florian
