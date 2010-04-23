Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757490Ab0DWVFL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 17:05:11 -0400
Received: from 5-161-237-24-mvl.swc.gci.net ([24.237.161.5]:38073 "EHLO
	mail.adialaska.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757387Ab0DWVFI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 17:05:08 -0400
Message-ID: <4BD20B7E.2070201@gmail.com>
Date: Fri, 23 Apr 2010 13:05:02 -0800
From: Kent Overstreet <kent.overstreet@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10pre) Gecko/20100421 Shredder/3.0.5pre
MIME-Version: 1.0
Newsgroups: gmane.linux.kernel
To: Randy Dunlap <randy.dunlap@oracle.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] bcache: ver 3
References: <20100423194107.GA20322@moria> <20100423133910.d36e2b22.randy.dunlap@oracle.com>
In-Reply-To: <20100423133910.d36e2b22.randy.dunlap@oracle.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/23/2010 12:39 PM, Randy Dunlap wrote:

>> +#define label(l, foo)	if (0) { l: foo; }
>
> I'd prefer that macro to go away.

I kind of like it, the way I use it it's shorthand for "return with x status"; 
it just makes return codes and exiting cleaner. But if you still hate it after 
you've read the functions where it's used, I can take it out.

>> +	return d[i / keys_per_page] + (i % keys_per_page);
>
> That builds OK on i386?  or does it need udivdi3() and/or umoddi3()?

If my understanding is correct, those are only needed for 64 bits, i indexes 
into a single node so 32 bits is plenty.

>
>> +}
>
>> +static int lookup_dev(struct cache_device *c, struct bio *bio)
>> +{
>> +	int dev;
>> +	for (dev = 0; dev<  256; dev++)
>
> Use a macro for 256.. in lots of places.

Yes, definitely.

> 		bcache: cannot allocate memory
> "kmalloc error" sounds like kmalloc() had an internal error.

Agreed.

> Need to document the sysfs interfaces:

Ok, I'll start on that.

>> +	err = "vmalloc error";
>
> 		"cannot vmalloc memory";

Done.
