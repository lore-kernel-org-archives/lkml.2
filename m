Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758224Ab0EUJlu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 05:41:50 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:26279 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225Ab0EUJls convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 05:41:48 -0400
Date: Fri, 21 May 2010 11:42:18 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCH 5/8] USB: gadget: f_fs: use usb_string_ids_n()
In-reply-to: <4BF56AFF.1010406@ru.mvista.com>
To: Sergei Shtylyov <sshtylyov@mvista.com>
Cc: linux-usb@vger.kernel.org, Kyungmin Park <kyungmin.park@samsung.com>,
       Marek Szyprowski <m.szyprowski@samsung.com>,
       linux-kernel@vger.kernel.org
Message-id: <op.vc1uksfa7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.10 (Linux)
References: <cover.1274187425.git.m.nazarewicz@samsung.com>
 <6577770c2519efd2193ed6454dcd895472bba404.1274187425.git.m.nazarewicz@samsung.com>
 <f888a55a4bd4d631c0d36e8463bb5bbb8e9d7a3d.1274187425.git.m.nazarewicz@samsung.com>
 <d38bd775a3b1c58255e19fda826cae7aa66a0a20.1274187425.git.m.nazarewicz@samsung.com>
 <906519813412e3970e06499f0dbe2823280ed54a.1274187425.git.m.nazarewicz@samsung.com>
 <a2865e8e9c3a9a305833ffea9caaec661082d5cf.1274187425.git.m.nazarewicz@samsung.com>
 <4BF56AFF.1010406@ru.mvista.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Michal Nazarewicz wrote:
>> @@ -1393,25 +1396,17 @@ static int functionfs_bind(struct ffs_data *ffs, struct usb_composite_dev *cdev)
>>  	ffs->ep0req->complete = ffs_ep0_complete;
>>  	ffs->ep0req->context = ffs;
>>
>> -	/* Get strings identifiers */
>> -	for (count = ffs->strings_count, i = 0; i < count; ++i) {
>> -		struct usb_gadget_strings **lang;
>> -
>> -		int id = usb_string_id(cdev);
>> -		if (unlikely(id < 0)) {
>> -			usb_ep_free_request(cdev->gadget->ep0, ffs->ep0req);
>> -			ffs->ep0req = NULL;
>> -			return id;
>> +	lang = ffs->stringtabs;
>> +	while (*lang) {
>> +		struct usb_string *str = (*lang)->strings;
>> +		int id = first_id;
>> +		for (; str->s; ++id, ++str) {
>> +			str->id = id;
>>  		}

On Thu, 20 May 2010 19:01:51 +0200, Sergei Shtylyov <sshtylyov@mvista.com> wrote:
>     {} not needed here.

Thanks.

I'll wait for some other comments and resend the patchset
or this single patch or whatever will be appropriate.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
