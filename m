Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab1HSLmN (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 07:42:13 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:53360 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753041Ab1HSLmJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 07:42:09 -0400
MIME-Version: 1.0
In-Reply-To: <op.v0gitehx3l0zgt@mnazarewicz-glaptop>
References: <1313659726-9406-1-git-send-email-per.forlin@stericsson.com>
	<op.v0esx9lx3l0zgt@mnazarewicz-glaptop>
	<CAJ0pr18LYtsPXghNeL_z4qvpd9Td3KtGR4R-x2dfu8s_S+dfYg@mail.gmail.com>
	<op.v0gitehx3l0zgt@mnazarewicz-glaptop>
Date: Fri, 19 Aug 2011 13:42:08 +0200
Message-ID: <CAJ0pr1_3xdm3qB=AkcuriMpV6RP-47pg+YLNB7YwPuagA0vnEg@mail.gmail.com>
Subject: Re: [PATCH v4] usb: gadget: storage_common: make FSG_NUM_BUFFERS
 variable size
From: Per Forlin <per.forlin@linaro.org>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Felipe Balbi <balbi@ti.com>, Greg Kroah-Hartman <gregkh@suse.de>,
        Per Forlin <per.forlin@stericsson.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/8/19 Michal Nazarewicz <mina86@mina86.com>:
> On Fri, 19 Aug 2011 10:39:24 +0200, Per Forlin <per.forlin@linaro.org>
> wrote:
>
>> 2011/8/18 Michal Nazarewicz <mina86@mina86.com>:
>>>
>>> On Thu, 18 Aug 2011 11:28:46 +0200, Per Forlin wrote:
>>>>
>>>> diff --git a/drivers/usb/gadget/f_mass_storage.c
>>>> b/drivers/usb/gadget/f_mass_storage.c
>>>> index 5b93395..3e546d9 100644
>>>> --- a/drivers/usb/gadget/f_mass_storage.c
>>>> +++ b/drivers/usb/gadget/f_mass_storage.c
>>>> @@ -363,7 +363,6 @@ struct fsg_common {
>>>>       struct fsg_buffhd       *next_buffhd_to_fill;
>>>>       struct fsg_buffhd       *next_buffhd_to_drain;
>>>> -       struct fsg_buffhd       buffhds[FSG_NUM_BUFFERS];
>>>>       int                     cmnd_size;
>>>>       u8                      cmnd[MAX_COMMAND_SIZE];
>>>> @@ -407,6 +406,8 @@ struct fsg_common {
>>>>       char inquiry_string[8 + 16 + 4 + 1];
>>>>       struct kref             ref;
>>>> +       /* Must be the last entry */
>>>> +       struct fsg_buffhd       buffhds[0];
>>>
>>> I would rather see it as “struct fsg_buffhd *buffhds;” since this change
>>> requires both mass_storage.c and multi.c to be changed.
>>>
>> If the allocation of buffhds is done separately in fsg_common_init().
>> mass_storage.c and multi.c doesn't need to be changed. But it's little
>> tricky to know whether buffhds should be allocated or not.
>
> They should be always allocated.  If the code allocate fsg_common itself,
> the
> case is obvious.  If caller passes a pointer to fsg_common structure, it is
> assumed that the structure is not initialised, thus the function need to
> allocate buffers.
>
Is it true that fsg_common_init() will never be called twice to
initialise the same fsg_common structure. It is always called once
followed by release.
If this is the case it is safe to only:
if (common->buffhds)
  common->buffhds = kzalloc()

Thanks,
Per
