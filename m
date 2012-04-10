Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758530Ab2DJDoy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Apr 2012 23:44:54 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40599 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754350Ab2DJDox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Apr 2012 23:44:53 -0400
Message-ID: <4F83ACB3.6010300@wwwdotorg.org>
Date: Mon, 09 Apr 2012 21:44:51 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Dong Aisheng <aisheng.dong@freescale.com>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>
Subject: Re: [PATCH 1/1] pinctrl: add some error checking for user interfaces
References: <1333967409-8168-1-git-send-email-b29396@freescale.com> <4F82FA2A.3090604@wwwdotorg.org> <20120410034927.GA674@shlinux2.ap.freescale.net>
In-Reply-To: <20120410034927.GA674@shlinux2.ap.freescale.net>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2012 09:49 PM, Dong Aisheng wrote:
> On Mon, Apr 09, 2012 at 11:03:06PM +0800, Stephen Warren wrote:
>> On 04/09/2012 04:30 AM, Dong Aisheng wrote:
>>> From: Dong Aisheng <dong.aisheng@linaro.org>
>>>
>>> This patch can avoid kernel oops in case the mux or config
>>> function is not supported by driver.
...
>>>  static int pinconf_pins_show(struct seq_file *s, void *what)
>>>  {
>>>  	struct pinctrl_dev *pctldev = s->private;
>>> +	const struct pinconf_ops *ops = pctldev->desc->confops;
>>>  	unsigned i, pin;
>>>  
>>> +	if (!ops || !ops->pin_config_get)
>>> +		return 0;
>>
>> I don't think this is necessary; it looks like this function (and those
>> it calls) always checks ops where they're used.
>
> Yes, it's true.
> But it will still dump all pins configs although there's no config value
> which is almost the same as another debug entry 'pins'.
> It looks it does not make too much sense to dump this info if no config support.
> The existing pinconf_group_show did like this way(no output).
> So i changed pinconf_pins_show in the same behavior as pinconf_group_show.
> 
> Do you think it's reasonable?

OK, I guess so.

I was thinking the file wouldn't be compiled without pin config support,
but that's only the core support and doesn't necessarily imply the
individual driver has support.
