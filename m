Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101Ab0KXIYg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Nov 2010 03:24:36 -0500
Received: from eu1sys200aog119.obsmtp.com ([207.126.144.147]:45136 "EHLO
	eu1sys200aog119.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751175Ab0KXIYf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Nov 2010 03:24:35 -0500
Message-ID: <4CECCBAE.6080707@stericsson.com>
Date: Wed, 24 Nov 2010 09:24:14 +0100
From: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Lightning/1.0b1 Thunderbird/3.0.6
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Subject: Re: [PATCH 1/3] mfd: Added new regulator_data pointer to ab8500 board
 configuration
References: <1290536754-21775-1-git-send-email-bengt.g.jonsson@stericsson.com> <1290536754-21775-2-git-send-email-bengt.g.jonsson@stericsson.com> <20101123183037.GA19212@rakim.wolfsonmicro.main>
In-Reply-To: <20101123183037.GA19212@rakim.wolfsonmicro.main>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-11-23 19:30, Mark Brown wrote:
> On Tue, Nov 23, 2010 at 07:25:52PM +0100, Bengt Jonsson wrote:
>
>> The ab8500 regulator board configuration will be better separated
>> from the MFD board configuration. This patch adds a void pointer
>> for this purpose.
>
> Adding something completely typesafe seems like a real loss - if you
> want to point to something else at least point to a particular type -
> eg,
>
> struct foo;
>
> struct pdata {
> 	int other_stuff;
> 	struct foo *foo;
> };
>
I get your point, I'll try this out.
>>   	struct regulator_init_data *regulator[AB8500_NUM_REGULATORS];
>> +	void *regulator_data;
>
> It'd also help if you could articulate the problem you see with the
> current approach...
The problem I see is that ab8500-core defines the number of regulators 
which I can see no reason for. If someone wants to add or remove a 
regulator they have to make a change in include/linux/mfd/ab8500.c as 
well as in the regulator files.

I will add a better description in an updated patch.
