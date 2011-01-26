Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752520Ab1AZJgr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 04:36:47 -0500
Received: from mail.sysgo.com ([195.145.229.155]:52068 "EHLO mail.sysgo.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752213Ab1AZJgp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 04:36:45 -0500
Message-ID: <4D3FEB2A.8010000@sysgo.com>
Date: Wed, 26 Jan 2011 10:36:42 +0100
From: David Engraf <david.engraf@sysgo.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.13) Gecko/20101208 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] serio: allow registered drivers to get status flag
References: <4D358E31.4080700@sysgo.com> <20110118195710.GA27152@core.coreip.homeip.net> <4D37FAEF.8080504@sysgo.com>
In-Reply-To: <4D37FAEF.8080504@sysgo.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 20.01.2011 10:05, schrieb David Engraf:
> Am 18.01.2011 20:57, schrieb Dmitry Torokhov:
>> On Tue, Jan 18, 2011 at 01:57:21PM +0100, David Engraf wrote:
>>> Parse the status byte information to the registered serio drivers as
>>> well as the character bytes.
>>>
>>> Signed-off-by: David Engraf<david.engraf@sysgo.com>
>>>
>>
>>> --- linux-2.6.37/drivers/input/serio/serport.c.orig 2011-01-18
>>> 12:33:41.421709232 +0100
>>> +++ linux-2.6.37/drivers/input/serio/serport.c 2011-01-18
>>> 13:33:24.521711214 +0100
>>> @@ -116,8 +116,8 @@ static void serport_ldisc_close(struct t
>>>
>>> /*
>>> * serport_ldisc_receive() is called by the low level tty driver when
>>> characters
>>> - * are ready for us. We forward the characters, one by one to the
>>> 'interrupt'
>>> - * routine.
>>> + * are ready for us. We forward the characters and flags, one by one
>>> to the
>>> + * 'interrupt' routine.
>>> */
>>>
>>> static void serport_ldisc_receive(struct tty_struct *tty, const
>>> unsigned char *cp, char *fp, int count)
>>> @@ -132,7 +132,7 @@ static void serport_ldisc_receive(struct
>>> goto out;
>>>
>>> for (i = 0; i< count; i++)
>>> - serio_interrupt(serport->serio, cp[i], 0);
>>> + serio_interrupt(serport->serio, cp[i], fp[i]);
>>>
>>
>> Hi David,
>>
>> The flags argument that serio_interrupt() accepts not the raw protocol
>> data, but sanitized, protocol-independent SERIO_TIMEOUT, SERIO_PARITY
>> and SERIO_FRAME bits.
>>
>> Thanks.
>>
>
> Hi Dmitry,
>
> I've updated the patch so that the raw protocol is converted to the
> SERIO_ bits. The raw protocol can parse only one flag, so I don't need
> to store multiple SERIO_ bits in the character flag variable.
>
> Thanks
> - David
>
>
> Signed-off-by: David Engraf<david.engraf@sysgo.com>
>

Hi Dmitry,

is my last patch okay for you? Just want to know if I can give you 
further help on this and if it is planned to integrate my patch.

Thanks
- David

