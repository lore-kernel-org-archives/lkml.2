Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab0LUSeL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 13:34:11 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:57599 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752460Ab0LUSeJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 13:34:09 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=brfmxX23HiGkNXLB+1X6hkvImJwV2D+CmpC0kePooHyp0iuGRAV/N5AjcWtkNXbyw5
         UQMSewts3TzU0Lre9o3fFo8okuXJzuLtCNsbQjyaPij+SN4m5cet9OlS6Vabe3XokvJf
         CyZkvFWGXcWIzPnDCKn8ugLqCv47yyqzERUsc=
MIME-Version: 1.0
In-Reply-To: <201012211925.38201.arnd@arndb.de>
References: <d21ad74592c295d59f5806f30a053745b5765397.1292894256.git.tfransosi@gmail.com>
	<201012211925.38201.arnd@arndb.de>
Date: Tue, 21 Dec 2010 16:34:04 -0200
Message-ID: <AANLkTikbvST_B+4x3Xt=gxFhM1TBOrXVc1HjZT3zTXrt@mail.gmail.com>
Subject: Re: [PATCH] drivers/media/video/v4l2-compat-ioctl32.c: Check the
 return value of copy_to_user
From: Thiago Farina <tfransosi@gmail.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org,
        Guennadi Liakhovetski <g.liakhovetski@gmx.de>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-media@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 4:25 PM, Arnd Bergmann <arnd@arndb.de> wrote:
> On Tuesday 21 December 2010 02:18:06 Thiago Farina wrote:
>> diff --git a/drivers/media/video/v4l2-compat-ioctl32.c b/drivers/media/video/v4l2-compat-ioctl32.c
>> index e30e8df..55825ec 100644
>> --- a/drivers/media/video/v4l2-compat-ioctl32.c
>> +++ b/drivers/media/video/v4l2-compat-ioctl32.c
>> @@ -206,7 +206,9 @@ static struct video_code __user *get_microcode32(struct video_code32 *kp)
>>          * user address is invalid, the native ioctl will do
>>          * the error handling for us
>>          */
>> -       (void) copy_to_user(up->loadwhat, kp->loadwhat, sizeof(up->loadwhat));
>> +       if (copy_to_user(up->loadwhat, kp->loadwhat, sizeof(up->loadwhat)))
>> +               return NULL;
>> +
>>         (void) put_user(kp->datasize, &up->datasize);
>>         (void) put_user(compat_ptr(kp->data), &up->data);
>>         return up;
>
> Did you read the comment above the code you changed?
>
Yes, I read, but I went ahead.

> You can probably change this function to look at the return code of
> copy_to_user, but then you need to treat the put_user return code
> the same, and change the comment.
>

Right, I will do the same with put_user, but I'm afraid of changing the comment.
