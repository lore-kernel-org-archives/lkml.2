Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762726Ab2DLUjA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 16:39:00 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:54942 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756068Ab2DLUi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 16:38:59 -0400
Message-ID: <4F873D5F.5020901@gmail.com>
Date: Thu, 12 Apr 2012 13:38:55 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Andreas Schwab <schwab@linux-m68k.org>,
        Grant Likely <grant.likely@secretlab.ca>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        David Daney <david.daney@cavium.com>
Subject: Re: [PATCH] iqrdomain: Improve formatting in debugfs.
References: <1334016417-18748-1-git-send-email-ddaney.cavm@gmail.com>	<20120411070332.6F3C03E081E@localhost> <m2k41kycy0.fsf@igel.home>
In-Reply-To: <m2k41kycy0.fsf@igel.home>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/2012 12:20 PM, Andreas Schwab wrote:
> Grant Likely<grant.likely@secretlab.ca>  writes:
>
>> diff --git a/kernel/irq/irqdomain.c b/kernel/irq/irqdomain.c
>> index 9310a8d..eb05e40 100644
>> --- a/kernel/irq/irqdomain.c
>> +++ b/kernel/irq/irqdomain.c
>> @@ -643,8 +643,8 @@ static int virq_debug_show(struct seq_file *m, void *private)
>>   	void *data;
>>   	int i;
>>
>> -	seq_printf(m, "%-5s  %-7s  %-15s  %-18s  %s\n", "virq", "hwirq",
>> -		      "chip name", "chip data", "domain name");
>> +	seq_printf(m, "%-5s  %-7s  %-15s  %-*s  %s\n", "irq", "hwirq",
>> +		      "chip name", 2 * sizeof(void *) + 2, "chip data", "domain name");
>
> kernel/irq/irqdomain.c:647:9: warning: field width specifier ‘*’ expects argument of type ‘int’, but argument 6 has type ‘long unsigned int’ [-Wformat]
>

My original patch assigned the size to an int variable and then passed 
that to the seq_printf(), thus avoiding this issue.  I suspect something 
like:

s/2 * sizeof(void *) + 2/(int)(2 * sizeof(void *) + 2)/

Would do the trick.

David Daney

