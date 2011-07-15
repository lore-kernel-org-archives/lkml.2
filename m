Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932717Ab1GOFOk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 01:14:40 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:50393 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932309Ab1GOFOj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 01:14:39 -0400
Message-ID: <4E1FCCB4.4080205@gmail.com>
Date: Fri, 15 Jul 2011 15:14:28 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Grant Likely <grant.likely@secretlab.ca>,
        Jeremy Kerr <jeremy.kerr@canonical.com>,
        Grant Likely <grant@secretlab.ca>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-sh@vger.kernel.org,
        patches@opensource.wolfsonmicro.com
Subject: Re: [PATCH 6/6] clk: Add initial WM831x clock driver
References: <20110711025344.GA27497@opensource.wolfsonmicro.com> <1310352837-4277-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1310352837-4277-6-git-send-email-broonie@opensource.wolfsonmicro.com> <20110715025339.GO2927@ponder.secretlab.ca> <20110715050503.GL32716@opensource.wolfsonmicro.com>
In-Reply-To: <20110715050503.GL32716@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15/07/11 15:05, Mark Brown wrote:
> On Thu, Jul 14, 2011 at 08:53:39PM -0600, Grant Likely wrote:
>> On Mon, Jul 11, 2011 at 11:53:57AM +0900, Mark Brown wrote:
>>> +	if (clkdata->xtal_ena)
>>> +		return 0;
>>> +	else
>>> +		return -EPERM;
>>> +}
>> Nit: return clkdata->xtal_ena ? 0 : -EPERM;
>> Just makes for more concise code.
> I have an extremely strong dislike of the ternery operator, I find it
> does nothing for legibility.
>
I prefer this:

     if (!clkdata->xtal_ena)
         return -EPERM;

     return 0;
}

Which makes the error check clear and makes the success case visible 
right at the bottom of the function.

~Ryan

