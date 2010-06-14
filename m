Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755950Ab0FNJre (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 05:47:34 -0400
Received: from hera.kernel.org ([140.211.167.34]:33987 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753295Ab0FNJrd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 05:47:33 -0400
Message-ID: <4C15FA6F.1070506@kernel.org>
Date: Mon, 14 Jun 2010 11:46:23 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jiri Slaby <jirislaby@gmail.com>
CC: mingo@elte.hu, tglx@linutronix.de, bphilips@suse.de, yinghai@kernel.org,
       akpm@linux-foundation.org, torvalds@linux-foundation.org,
       linux-kernel@vger.kernel.org, jeff@garzik.org,
       linux-ide@vger.kernel.org, stern@rowland.harvard.edu, gregkh@suse.de,
       khali@linux-fr.org
Subject: Re: [PATCH 09/12] irq: implement IRQ expecting
References: <1276443098-20653-1-git-send-email-tj@kernel.org> <1276443098-20653-10-git-send-email-tj@kernel.org> <4C15F4B7.5040601@gmail.com> <4C15F9D0.40706@kernel.org>
In-Reply-To: <4C15F9D0.40706@kernel.org>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Mon, 14 Jun 2010 09:46:25 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2010 11:43 AM, Tejun Heo wrote:
> Hello,
> 
> On 06/14/2010 11:21 AM, Jiri Slaby wrote:
>> On 06/13/2010 05:31 PM, Tejun Heo wrote:
>>> --- a/kernel/irq/spurious.c
>>> +++ b/kernel/irq/spurious.c
>> ...
>>
>>> @@ -25,9 +26,43 @@ enum {
>>>  	/* IRQ polling common parameters */
>>>  	IRQ_POLL_SLOW_INTV		= 3 * HZ,	/* not too slow for ppl, slow enough for machine */
>>>  	IRQ_POLL_INTV			= HZ / 100,	/* from the good ol' 100HZ tick */
>>> +	IRQ_POLL_QUICK_INTV		= HZ / 1000,	/* pretty quick but not too taxing */
>>>  
>>>  	IRQ_POLL_SLOW_SLACK		= HZ,
>>>  	IRQ_POLL_SLACK			= HZ / 1000,	/* 10% slack */
>>> +	IRQ_POLL_QUICK_SLACK		= HZ / 10000,	/* 10% slack */
>>
>> Hi. These are zeros on most systems (assuming distros set HZ=100 and
>> 250), what is their purpose then?
> 
> On every tick and no slack.  :-)

Hmmm... but yeah, it would be better to make IRQ_POLL_SLACK HZ / 250
so that we at least have one tick slack on 250HZ configs which are
pretty common these days.

Thanks.

-- 
tejun
