Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751836Ab1GZM5L (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jul 2011 08:57:11 -0400
Received: from mail.free-electrons.com ([88.190.12.23]:53140 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750946Ab1GZM5F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jul 2011 08:57:05 -0400
Message-ID: <4E2EBA11.6000700@free-electrons.com>
Date: Tue, 26 Jul 2011 14:58:57 +0200
From: David Wagner <david.wagner@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110424 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: linux-mtd@lists.infradead.org, dedekind1@gmail.com, dwmw2@infradead.org,
        linux-kernel@vger.kernel.org, linux-embedded@vger.kernel.org,
        tim.bird@am.sony.com
Subject: Re: [PATCH] UBI: new module ubiblk: block layer on top of UBI
References: <1308922482-14967-1-git-send-email-david.wagner@free-electrons.com> <1311683250-7921-1-git-send-email-david.wagner@free-electrons.com> <20110726123453.GA18513@infradead.org>
In-Reply-To: <20110726123453.GA18513@infradead.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/26/2011 02:34 PM, Christoph Hellwig wrote:
>> TODO:
>>  * the modules keeps a table of the devices which length is the
maximum number
>>    of UBI volumes.  It should make use of a linked list.
>
> A linked list isn't very nice either.  Try using idr, which gives you
> both an allocator for the minor number space, and a way to look up
> the structure by that index.
>

I'll take a look ; is it really worth it, though ? I look in the table
only when a volume is created, resized, or removed (that is, rarely) and
there are really few items (I bet, between 1 and 8 ; max possible is 4096).

>> Advantages of ubiblk over gluebi+mtdblock_ro:
>
> This section should be in the main commit log, and not that part with
> the changelog which gets dropped.

Will do.

>> +int major;
>
> Please don't use global variables with generic names.  In this case you
> should neither make it global nor give it a generic name.
>

fixed.


Thank you for your feedback :)

-- 
David Wagner, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com

