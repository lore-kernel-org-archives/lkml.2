Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753061Ab1HSKpM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 06:45:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48351 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751976Ab1HSKpI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 06:45:08 -0400
Content-Type: text/plain; charset=utf-8; format=flowed; delsp=yes
To: "Per Forlin" <per.forlin@linaro.org>
Cc: "Felipe Balbi" <balbi@ti.com>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        "Per Forlin" <per.forlin@stericsson.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Subject: Re: [PATCH v4] usb: gadget: storage_common: make FSG_NUM_BUFFERS
 variable size
References: <1313659726-9406-1-git-send-email-per.forlin@stericsson.com>
 <op.v0esx9lx3l0zgt@mnazarewicz-glaptop>
 <CAJ0pr18LYtsPXghNeL_z4qvpd9Td3KtGR4R-x2dfu8s_S+dfYg@mail.gmail.com>
Date: Fri, 19 Aug 2011 12:45:04 +0200
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
From: "Michal Nazarewicz" <mina86@mina86.com>
Message-ID: <op.v0gitehx3l0zgt@mnazarewicz-glaptop>
In-Reply-To: <CAJ0pr18LYtsPXghNeL_z4qvpd9Td3KtGR4R-x2dfu8s_S+dfYg@mail.gmail.com>
User-Agent: Opera Mail/11.50 (Linux)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Aug 2011 10:39:24 +0200, Per Forlin <per.forlin@linaro.org>  
wrote:

> 2011/8/18 Michal Nazarewicz <mina86@mina86.com>:
>> On Thu, 18 Aug 2011 11:28:46 +0200, Per Forlin wrote:
>>>
>>> diff --git a/drivers/usb/gadget/f_mass_storage.c
>>> b/drivers/usb/gadget/f_mass_storage.c
>>> index 5b93395..3e546d9 100644
>>> --- a/drivers/usb/gadget/f_mass_storage.c
>>> +++ b/drivers/usb/gadget/f_mass_storage.c
>>> @@ -363,7 +363,6 @@ struct fsg_common {
>>>        struct fsg_buffhd       *next_buffhd_to_fill;
>>>        struct fsg_buffhd       *next_buffhd_to_drain;
>>> -       struct fsg_buffhd       buffhds[FSG_NUM_BUFFERS];
>>>        int                     cmnd_size;
>>>        u8                      cmnd[MAX_COMMAND_SIZE];
>>> @@ -407,6 +406,8 @@ struct fsg_common {
>>>        char inquiry_string[8 + 16 + 4 + 1];
>>>        struct kref             ref;
>>> +       /* Must be the last entry */
>>> +       struct fsg_buffhd       buffhds[0];
>>
>> I would rather see it as “struct fsg_buffhd *buffhds;” since this change
>> requires both mass_storage.c and multi.c to be changed.
>>
> If the allocation of buffhds is done separately in fsg_common_init().
> mass_storage.c and multi.c doesn't need to be changed. But it's little
> tricky to know whether buffhds should be allocated or not.

They should be always allocated.  If the code allocate fsg_common itself,  
the
case is obvious.  If caller passes a pointer to fsg_common structure, it is
assumed that the structure is not initialised, thus the function need to
allocate buffers.

-- 
Best regards,                                         _     _
.o. | Liege of Serenely Enlightened Majesty of      o' \,=./ `o
..o | Computer Science,  Michal "mina86" Nazarewicz    (o o)
ooo +-----<email/xmpp: mnazarewicz@google.com>-----ooO--(_)--Ooo--
