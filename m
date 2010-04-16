Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757592Ab0DPDBL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 23:01:11 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54385
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757282Ab0DPDBJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 23:01:09 -0400
Date: Thu, 15 Apr 2010 20:01:13 -0700 (PDT)
Message-Id: <20100415.200113.215578006.davem@davemloft.net>
To: fthain@telegraphics.com.au
Cc: joe@perches.com, p_gortmaker@yahoo.com, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org
Subject: Re: another cleanup patch gone wrong
From: David Miller <davem@davemloft.net>
In-Reply-To: <alpine.OSX.2.00.1004161214270.271@localhost>
References: <alpine.OSX.2.00.1004161214270.271@localhost>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Finn Thain <fthain@telegraphics.com.au>
Date: Fri, 16 Apr 2010 12:34:24 +1000 (EST)

> 
> ...but this one was already merged, unfortunately.
> 
>> Use printk_once
>> Add #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> Convert printks without KERN_<level> to pr_info and pr_cont
>> 
>> Signed-off-by: Joe Perches <joe@perches.com>
>> Signed-off-by: David S. Miller <davem@davemloft.net>
>> 
>> 
>> diff --git a/drivers/net/mac8390.c b/drivers/net/mac8390.c
>> index 517cee4..8bd09e2 100644 (file)
>> --- a/drivers/net/mac8390.c
>> +++ b/drivers/net/mac8390.c
>> @@ -17,6 +17,8 @@
>>  /* 2002-12-30: Try to support more cards, some clues from NetBSD driver */
>>  /* 2003-12-26: Make sure Asante cards always work. */
>>  
>> +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
>> +
> 
> Why the macro? You only used it once.

It gets expanded internally into all of the pr_*() calls.

> The pr_xxx naming convention belongs to a kernel-wide include file. Is it 
> really a good idea to start repurposing it in .c files?

This is exactly how it can be used, and there is much
precedent for this now.

>> -                       printk("Don't know how to access card memory!\n");
>> +                       pr_info("Don't know how to access card memory!\n");
> 
> No, this is pr_err. The driver sets dev->mem_start expecting it to work, 
> obviously.

It was an unspecified printk() so Joe's conversion is equal
and that's a good way for him to have made these changes.

If we want to mark this as KERN_ERR or whatever, that's entirely
a seperate change.

I think your objections to Joe's changes are completely uncalled
for and his changes were good ones.
