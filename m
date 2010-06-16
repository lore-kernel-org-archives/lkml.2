Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756192Ab0FPJ3X (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 05:29:23 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:53846 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755776Ab0FPJ3U convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 05:29:20 -0400
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Date: Wed, 16 Jun 2010 11:30:09 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH] USB: gadget: g_fs: possible invalid pointer reference bug
 fixed
In-reply-to: <4C17519C.5080209@ru.mvista.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: linux-usb@vger.kernel.org,
       David Brownell <dbrownell@users.sourceforge.net>,
       Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <op.vedzcjyz7p4s8u@pikus>
Organization: Samsung Electronics
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <f8fbee30a711b740b5875514715c3c58b4eb196c.1276170819.git.m.nazarewicz@samsung.com>
 <4C17519C.5080209@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Michal Nazarewicz wrote:
>> diff --git a/drivers/usb/gadget/g_ffs.c b/drivers/usb/gadget/g_ffs.c
>> index 2f26470..da3a9e4 100644
>> --- a/drivers/usb/gadget/g_ffs.c
>> +++ b/drivers/usb/gadget/g_ffs.c
>> @@ -392,6 +392,17 @@ static int __gfs_do_config(struct usb_configuration *c,
>>  	if (unlikely(ret < 0))
>>  		return ret;
>>
>> +	/* After previous do_configs there may be some invalid
>> +	 * pointers in c->interface array.  This happens every time
>> +	 * a user space function with fewer interfaces than a user
>> +	 * space function that was run before the new one is run.  The
>> +	 * compasit's set_config() assumes that if there is no more
>> +	 * then MAX_CONFIG_INTERFACES interfaces in a configuration
>> +	 * then there is a NULL pointer after the last interface in
>> +	 * c->interface array.  We need to make sure this is true. */

On Tue, 15 Jun 2010 12:10:36 +0200, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
>     According to CodingStyle, the preferred style of the multi-line comments
> is this:
>
> /*
>   * bla
>   * bla
>   */

You are of course correct but on the other hand I have consistently used
the incorrect form so far also in g_ffs.c so...  I think correcting only
this comment would bring inconsistency so I should rather resend it with
other (two) comments corrected as well.  Anyone thinks I should do that?

And I promise, I will remember to use the correct format in my future
files.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
