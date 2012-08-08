Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757846Ab2HHDXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 23:23:01 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:57982 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757793Ab2HHDW5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 23:22:57 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1207281218190.23545-100000@netrider.rowland.org>
References: <5013E074.20007@gmail.com>
	<Pine.LNX.4.44L0.1207281218190.23545-100000@netrider.rowland.org>
Date: Wed, 8 Aug 2012 08:52:56 +0530
Message-ID: <CAP2rAF-8wC0BkCieCi6S59kYbPgum=H8bp+_MM+RnGhsq0yAAQ@mail.gmail.com>
Subject: Re: Kernel Oops while disconnecting USB peripheral (always)
From: Sarbojit Ganguly <unixman.linuxboy@gmail.com>
To: Daniel Mack <zonque@gmail.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Takashi Iwai <tiwai@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sorry guys I was away due to personal emergency, however now I am back
and will check the reply ASAP.

On 28 July 2012 21:49, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Sat, 28 Jul 2012, Daniel Mack wrote:
>
>> Hmm, interesting. Thanks for sharing this. I personally never saw this
>> bug kicking in, but if I understand your findings correctly, we would
>> need something like the following patch for snd-usb and the storage driver?
>>
>> Sarbojit, could you give this a test and see whether your kernel still
>> crashes in any of the two drivers?
>
>
>> --- a/drivers/usb/storage/usb.c
>> +++ b/drivers/usb/storage/usb.c
>> @@ -1025,9 +1025,14 @@ void usb_stor_disconnect(struct usb_interface *intf)
>>  {
>>         struct us_data *us = usb_get_intfdata(intf);
>>
>> +       if (!us)
>> +               return;
>
> This can never happen.  The disconnect routine gets called only once,
> so us will not be NULL.
>
>> +
>>         US_DEBUGP("storage_disconnect() called\n");
>>         quiesce_and_remove_host(us);
>>         release_everything(us);
>> +
>> +       usb_set_intfdata(intf, NULL);
>>  }
>>  EXPORT_SYMBOL_GPL(usb_stor_disconnect);
>
> Alan Stern
>



-- 
Regards,
Sarbojit
