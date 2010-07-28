Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752857Ab0G1NAg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jul 2010 09:00:36 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:44169 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752314Ab0G1NAd convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jul 2010 09:00:33 -0400
Date: Wed, 28 Jul 2010 15:02:01 +0200
From: =?utf-8?B?TWljaGHFgiBOYXphcmV3aWN6?= <m.nazarewicz@samsung.com>
Subject: Re: [PATCHv5 3/3] USB: gadget: storage_common: fixed warning building
 mass storage function
In-reply-to: <AANLkTikW8eSn3fgRqJsXwp=+ZMjKgojHDP6+DsDMtg4y@mail.gmail.com>
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Greg KH <greg@kroah.com>, David Brownell <david-b@pacbell.net>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Message-id: <op.vgj05nev7p4s8u@pikus>
Organization: Samsung Electronics
MIME-version: 1.0
Content-type: text/plain; charset=utf-8; format=flowed; delsp=yes
Content-transfer-encoding: 8BIT
User-Agent: Opera Mail/10.60 (Linux)
References: <38424b23c94ddcff6f1808161912f362c2ccae39.1280316431.git.m.nazarewicz@samsung.com>
 <7b3ddf05e135e8147d1011a81f9069d9cd78aa62.1280316431.git.m.nazarewicz@samsung.com>
 <d7a11c97d1b28c7a0336c747de57a9a17dcc7604.1280316431.git.m.nazarewicz@samsung.com>
 <AANLkTikW8eSn3fgRqJsXwp=+ZMjKgojHDP6+DsDMtg4y@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 28 Jul 2010 14:25:59 +0200, Andy Shevchenko <andy.shevchenko@gmail.com> wrote:

> On Wed, Jul 28, 2010 at 3:13 PM, Michal Nazarewicz
> <m.nazarewicz@samsung.com> wrote:
>> The "nofua" attribute is used in the File-Storage Gadget but the
>> functions handling it are defined in storage_common.c (which may be
>> not a bad thing if anyone will want to port tho "nofua" attribute to
>> mass storage function) which causes the following warnings:
>>
>> drivers/usb/gadget/storage_common.c:718: \
>>  warning: ‘fsg_show_nofua’ defined but not used
>> drivers/usb/gadget/storage_common.c:782: \
>>  warning: ‘fsg_store_nofua’ defined but not used
>>
>> Adding __maybe_unused fixes this issue.
> It's a bit odd.
>
> Why the warning happens for those two only?
> There are two more parameters (four methods) to handle 'ro' and 'file'
> which are done in the same way.

Those are the only ones that are not used by the mass storage function.

The warning is issued when drivers using mass storage function are built.
File-Storage Gadget compiles fine.

-- 
Best regards,                                        _     _
| Humble Liege of Serenely Enlightened Majesty of  o' \,=./ `o
| Computer Science,  Michał "mina86" Nazarewicz       (o o)
+----[mina86*mina86.com]---[mina86*jabber.org]----ooO--(_)--Ooo--
