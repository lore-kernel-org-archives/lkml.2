Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab2KEGed (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Nov 2012 01:34:33 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:41852 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751027Ab2KEGec (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Nov 2012 01:34:32 -0500
MIME-Version: 1.0
In-Reply-To: <CAPEGOOKZTxR725UtoeEXDeCaS4RgvBHfymJYzknaopwsoWMh1A@mail.gmail.com>
References: <1352091026-5441-1-git-send-email-huawei.yang@gmail.com>
	<CAPEGOOKZTxR725UtoeEXDeCaS4RgvBHfymJYzknaopwsoWMh1A@mail.gmail.com>
Date: Mon, 5 Nov 2012 14:34:31 +0800
Message-ID: <CAFCUKTRvxhdOdzpNEgEDD6CrkioCgJ63DyMVVjWszYOmmQ46SA@mail.gmail.com>
Subject: Re: [PATCH 1/1] staging: usbip: remove an unnecessary lock in
 usbip_event_happened. The variable "happened" is local. So I think there is
 no need to lock here.
From: harvey yang <harvey.huawei.yang@gmail.com>
To: Prashant Shah <kerneldev100@gmail.com>
Cc: Matt Mooney <mfm@muteddisk.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I think no need to make 'happened' static as we just check 'ud->event'
feild. Maybe making this function inline would make more sense.

inline int usbip_event_happened(struct usbip_device *ud)
{
        return ud->event ? 1 : 0;
}

Thanks
Harvey


On Mon, Nov 5, 2012 at 1:34 PM, Prashant Shah <kerneldev100@gmail.com> wrote:
> Hi,
>
>>         int happened = 0;
>>
>> -       spin_lock(&ud->lock);
>>         if (ud->event != 0)
>>                 happened = 1;
>> -       spin_unlock(&ud->lock);
>>
>>         return happened;
>
> I am guessing locking was intended to protect ud->event along with
> happened so that (checking the value of ud->event and setting value of
> happened) was atomic.
>
> return ud->event != 0 ? 1 : 0;
>
> Regards.
