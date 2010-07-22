Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759554Ab0GVOQQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jul 2010 10:16:16 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:10877 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759506Ab0GVOQL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jul 2010 10:16:11 -0400
Date: Thu, 22 Jul 2010 16:17:34 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv4 1/2] usb: gadget: storage: strict coversion of 'ro'
 parameter
In-reply-to: <Pine.LNX.4.44L0.1007221002510.1725-100000@iolanthe.rowland.org>
To: Andy Shevchenko <andy.shevchenko@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        David Brownell <dbrownell@users.sourceforge.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, linux-usb@vger.kernel.org
Message-id: <op.vf80nklo7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <Pine.LNX.4.44L0.1007221002510.1725-100000@iolanthe.rowland.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, 22 Jul 2010, Andy Shevchenko wrote:
>> @@ -735,8 +735,8 @@ static ssize_t fsg_store_ro(struct device *dev, struct device_attribute *attr,
>>  		LDBG(curlun, "read-only status change prevented\n");
>>  		rc = -EBUSY;
>>  	} else {
>> -		curlun->ro = !!i;
>> -		curlun->initially_ro = !!i;
>> +		curlun->ro = ro;
>> +		curlun->initially_ro = ro;
>>  		LDBG(curlun, "read-only status set to %d\n", curlun->ro);
>>  	}
>>  	up_read(filesem);

On Thu, 22 Jul 2010 16:07:14 +0200, Alan Stern <stern@rowland.harvard.edu> wrote:
> Strictly speaking, this changes the behavior when a non-binary value is
> specified.  For example, if somebody were to write "10" then the old
> code would set the value to True and the new code would set the value
> to False -- and neither would reject it as they probably should.
> That's okay; people who write ambiguous or invalid values deserve what
> they get.

If anyone considers that an issue, it would be solved by:

+		curlun->ro = !!ro;
+		curlun->initially_ro = !!ro;

The "!!" where there for that purpose in the first place.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
