Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062Ab1FUQk5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 12:40:57 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54635 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756993Ab1FUQkz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 12:40:55 -0400
MIME-Version: 1.0
X-Originating-IP: [87.194.181.195]
In-Reply-To: <m239j3tb3w.fsf@bob.laptop.org>
References: <BANLkTikMc1WfJMJ2NeBr1E62dGjCj1Cd_w@mail.gmail.com>
	<20110621101725.GA670@rere.qmqm.pl>
	<m239j3tb3w.fsf@bob.laptop.org>
Date: Tue, 21 Jun 2011 17:40:53 +0100
Message-ID: <BANLkTik7CqKJUGNbvTO-WbfzVR2MxT=j3A@mail.gmail.com>
Subject: Re: [PATCH] cb710: fix #ifdef HAVE_EFFICIENT_UNALIGNED_ACCESS
From: James Hogan <james@albanarts.com>
To: Chris Ball <cjb@laptop.org>
Cc: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirq-linux@rere.qmqm.pl>,
        linux-kernel@vger.kernel.org, linux-mmc@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

2011/6/21 Chris Ball <cjb@laptop.org>:
> Hi,
>
> On Tue, Jun 21 2011, Michał Mirosław wrote:
>> On Tue, Jun 21, 2011 at 10:55:34AM +0100, James Hogan wrote:
>>> HAVE_EFFICIENT_UNALIGNED_ACCESS is a config option, therefore it needs
>>> the CONFIG_ before it when used by the preprocessor.
>>>
>>> Signed-off-by: James Hogan <james@albanarts.com>
>>> ---
>>>  drivers/misc/cb710/sgbuf2.c |    2 +-
>>>  1 files changed, 1 insertions(+), 1 deletions(-)
>>>
>>> diff --git a/drivers/misc/cb710/sgbuf2.c b/drivers/misc/cb710/sgbuf2.c
>>> index d019746..2a40d0e 100644
>>> --- a/drivers/misc/cb710/sgbuf2.c
>>> +++ b/drivers/misc/cb710/sgbuf2.c
>>> @@ -47,7 +47,7 @@ static uint32_t sg_dwiter_read_buffer(struct
>>> sg_mapping_iter *miter)
>>>
>>>  static inline bool needs_unaligned_copy(const void *ptr)
>>>  {
>>> -#ifdef HAVE_EFFICIENT_UNALIGNED_ACCESS
>>> +#ifdef CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS
>>>      return false;
>>>  #else
>>>      return ((ptr - NULL) & 3) != 0;
>>
>> Acked-by: Michał Mirosław <mirq-linux@rere.qmqm.pl>
>
> Thanks, pushed to mmc-next for 3.0.
>
> (James, your patch was corrupt due to a hard line break on the @@
> line -- please fix that next time around.)

Ahh, sorry about that Chris, I thought I had that problem sorted!

Thanks
James

>
> - Chris.
> --
> Chris Ball   <cjb@laptop.org>   <http://printf.net/>
> One Laptop Per Child
>



-- 
James Hogan
