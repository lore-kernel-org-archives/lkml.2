Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab2JJMrX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Oct 2012 08:47:23 -0400
Received: from arroyo.ext.ti.com ([192.94.94.40]:54360 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751955Ab2JJMrW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Oct 2012 08:47:22 -0400
Message-ID: <50756DFD.4070203@ti.com>
Date: Wed, 10 Oct 2012 18:15:49 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Sekhar Nori <nsekhar@ti.com>
CC: Murali Karicheri <m-karicheri2@ti.com>, <khilman@ti.com>,
        <davinci-linux-open-source@linux.davincidsp.com>,
        <mturquette@linaro.org>, <linux-c6x-dev@linux-c6x.org>,
        <arnd@arndb.de>, <linus.walleij@linaro.org>,
        <linux-kernel@vger.kernel.org>, <rob.herring@calxeda.com>,
        <linux-keystone@list.ti.com>, <viresh.linux@gmail.com>,
        <linux@arm.linux.org.uk>, <akpm@linux-foundation.org>,
        <shawn.guo@linaro.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 02/13] clk: davinci - add PSC clock driver
References: <1348682889-9509-1-git-send-email-m-karicheri2@ti.com> <1348682889-9509-3-git-send-email-m-karicheri2@ti.com> <50756B96.1070008@ti.com>
In-Reply-To: <50756B96.1070008@ti.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/10/2012 6:05 PM, Sekhar Nori wrote:

>> +struct clk *clk_register_davinci_psc(struct device *dev, const char *name,
>> +			const char *parent_name,
>> +			struct clk_davinci_psc_data *psc_data,
>> +			spinlock_t *lock)
> 
> Why do you need the lock to be provided from outside of this file? You
> can initialize a lock for serializing writes to PSC registers within
> this file, no?

Looking again, it seems like the common clock framework defines an
"enable_lock" in drivers/clk/clk.c to serialize the clock enable/disable
calls. Unless I am missing something, this lock seems unnecessary.

Thanks,
Sekhar
