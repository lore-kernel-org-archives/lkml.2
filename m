Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757198Ab2EVRMg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 13:12:36 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:40503 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750863Ab2EVRMf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 13:12:35 -0400
Message-ID: <4FBBC900.2070003@wwwdotorg.org>
Date: Tue, 22 May 2012 11:12:32 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Dong Aisheng <aisheng.dong@freescale.com>
CC: Dong Aisheng-B29396 <B29396@freescale.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linus.walleij@stericsson.com" <linus.walleij@stericsson.com>
Subject: Re: [PATCH RFC v2 2/2] pinctrl: add pinctrl gpio binding support
References: <1337346755-8761-1-git-send-email-b29396@freescale.com> <1337346755-8761-2-git-send-email-b29396@freescale.com> <4FB6AB9A.4080006@wwwdotorg.org> <20120522033501.GB27055@shlinux2.ap.freescale.net>
In-Reply-To: <20120522033501.GB27055@shlinux2.ap.freescale.net>
X-Enigmail-Version: 1.5pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2012 09:35 PM, Dong Aisheng wrote:
> On Sat, May 19, 2012 at 04:05:46AM +0800, Stephen Warren wrote:
> ...
>>> +			np_gpio = of_find_node_by_phandle(phandle);
>>> +			if (!np_gpio) {
>>> +				dev_err(pctldev->dev,
>>> +					"failed to find gpio node(%s)\n",
>>> +					np_gpio->name);
>>
>> Perhaps devm_kfree(ranges) here so that if this is called multiple times
>> due to deferred probe, the allocations from the failed attempts don't
>> accumulate. Same for other error paths.
>
> I checked a bit more, it seems the resource will be removed first if there's
> a deffer probe error.

Oh yes of course - that makes sense.
