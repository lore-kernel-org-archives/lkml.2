Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752486Ab1AYKd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 05:33:27 -0500
Received: from mx01.sz.bfs.de ([194.94.69.103]:10522 "EHLO mx01.sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751547Ab1AYKd0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 05:33:26 -0500
Message-ID: <4D3EA6EC.5050305@bfs.de>
Date: Tue, 25 Jan 2011 11:33:16 +0100
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Julia Lawall <julia@diku.dk>
CC: Vasiliy Kulikov <segooon@gmail.com>, Ryan Mallon <ryan@bluewatersys.com>,
        Russell King <linux@arm.linux.org.uk>, kernel-janitors@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Andrew Victor <linux@maxim.org.za>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] arch/arm/mach-at91/clock.c: Add missing IS_ERR test
References: <1295898922-18822-1-git-send-email-julia@diku.dk> <1295898922-18822-3-git-send-email-julia@diku.dk> <4D3DD964.9020107@bluewatersys.com> <Pine.LNX.4.64.1101242058430.3167@ask.diku.dk> <20110124200515.GA30963@albatros> <Pine.LNX.4.64.1101242108180.3167@ask.diku.dk>
In-Reply-To: <Pine.LNX.4.64.1101242108180.3167@ask.diku.dk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 24.01.2011 21:09, schrieb Julia Lawall:
> On Mon, 24 Jan 2011, Vasiliy Kulikov wrote:
> 
>> On Mon, Jan 24, 2011 at 21:00 +0100, Julia Lawall wrote:
>>> On Tue, 25 Jan 2011, Ryan Mallon wrote:
>>>
>>>> On 01/25/2011 08:55 AM, Julia Lawall wrote:
>>>>> @@ -224,7 +224,7 @@ void __init at91_clock_associate(const char *id, struct device *dev, const char
>>>>>  {
>>>>>  	struct clk *clk = clk_get(NULL, id);
>>>>>  
>>>>> -	if (!dev || !clk || !IS_ERR(clk_get(dev, func)))
>>>>> +	if (!dev || IS_ERR(clk) || !IS_ERR(clk_get(dev, func)))
>>>>>  		return;
>>>>
>>>> I think we want:
>>>>
>>>> 	if (!dev || !clk || IS_ERR(clk) || !IS_ERR(clk_get(dev, func)))
>>>> 		return;
>>>>
>>>> Since it is valid to return a NULL clk, and we don't want to try and
>>>> dereference it if that is the case.
>>>
>>> Looking at the given defintion of clk_get, I can't see how that could 
>>> happen:
>>
>> clk_get() is defined per-architecture, sometimes it is NULL only.
> 
> In this case there is a definition in the same file, so it doesn't seem 
> necessary to worry about possible other ones.  Unless there is some goal 
> in the future to remove the local one?
> 

Would it be more easy to return NULL in the error case of clk_get() instead
of ERR_PTR(-ENOENT) ?

So the default could be return NULL and an architecture depending solution
replacing that.

re,
 wh
