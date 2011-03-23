Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933104Ab1CWXGE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Mar 2011 19:06:04 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:36962 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932994Ab1CWXGC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Mar 2011 19:06:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=WyR8vR9OZV36k3CAZXSsjVZVhgUwI2XSZSuYj0BUwQC9YTPPzqX1wzP4tkItYD2PGZ
         R62GvjMnk05F+oeHJCjGTz4lBNbvPdQj5Br0QFZb2IFQ952Pau2Ra0WX2ld+kk9oLr3F
         +XG/3AKcgymo2iU6oQ7IK47pk44cDVnWUJKNM=
Message-ID: <4D8A7D7B.1080001@gmail.com>
Date: Wed, 23 Mar 2011 23:08:43 +0000
From: Stuart Swales <stuart.swales.croftnuisk@gmail.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-GB; rv:1.9.2.15) Gecko/20110303 Lightning/1.0b2 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Geert Uytterhoeven <geert@linux-m68k.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] adfs: add hexadecimal filetype suffix option
References: <4D2DEDDB.1070605@gmail.com>	<20110119154915.a0bb2878.akpm@linux-foundation.org>	<AANLkTimpYyErnvEjSCevMCcKTW5ffyi9V5EB3U8RwuBG@mail.gmail.com> <20110323135835.0c2e296c.akpm@linux-foundation.org>
In-Reply-To: <20110323135835.0c2e296c.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The file typing code is using -1 (truncated to __u16) to represent the 
case when no explicit 12-bit file type was set on the file, such as is 
the case where the file has explicit 32-bit load and execute addresses 
(Acorn specific legacy stuff, started with the BBC Micro).  It would 
seem to be best if the -1 were replaced by 0xffffu.

Stuart

On 23/03/2011 20:58, Andrew Morton wrote:
> On Wed, 23 Mar 2011 21:36:48 +0100
> Geert Uytterhoeven<geert@linux-m68k.org>  wrote:
>
>> On Thu, Jan 20, 2011 at 00:49, Andrew Morton<akpm@linux-foundation.org>  wrote:
>>> On Wed, 12 Jan 2011 18:07:23 +0000
>>> Stuart Swales<stuart.swales.croftnuisk@gmail.com>  wrote:
>>>> From: Stuart Swales<stuart.swales.croftnuisk@gmail.com>
>>
>>>> +static inline int append_filetype_suffix(char *buf, __u16 filetype)
>>>> +{
>>>> + __ __ if ((__u16) -1 == filetype)
>>>
>>> unneeded cast.
>>
>> My compiler tends to disagree. On current mainline, it says:
>>
>> fs/adfs/adfs.h: In function ___append_filetype_suffix___:
>> fs/adfs/adfs.h:115: warning: comparison is always false due to limited
>> range of data type
>>
>
> hm, OK, I'll add a cast.
>
> The code seems a bit fishy - it wants 0xffff but the comment says it's
> handling a 12-bit quantity.  Obviously the all-ones pattern has some
> magical out-of-band meaning here, but it is not explained what that
> meaning *is*.  Perhaps that is described elsewhere.
>


-- 
Stuart Swales
