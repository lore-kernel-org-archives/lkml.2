Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752233Ab1AQKQL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Jan 2011 05:16:11 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58719 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751212Ab1AQKQI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Jan 2011 05:16:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:from:date
         :x-google-sender-auth:message-id:subject:to:cc:content-type
         :content-transfer-encoding;
        b=ijc/k0MS3GIBkzJzNq4l8QYYhD8eI5GXkDQG5Xba3adYZ83PmcJ+bF1infSoZMk9Eo
         q9OSENtFNCzKPbAw9kqjLfAYMxgC0/lEglyWTWSfYM+tNT61pIXM+ZvJDrDwlsAGo5MF
         Wi8KacxZdcWuz2QcSxB63JNau9Db5rorIDteo=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=TF9uYEv2Y3qwMKham=K2cCxo4UOTn8Vf+S-KC@mail.gmail.com>
References: <1294745487-29138-1-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-2-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-3-git-send-email-manjunatha_halli@ti.com>
 <1294745487-29138-4-git-send-email-manjunatha_halli@ti.com>
 <20110111112434.GE2385@legolas.emea.dhcp.ti.com> <AANLkTi=TF9uYEv2Y3qwMKham=K2cCxo4UOTn8Vf+S-KC@mail.gmail.com>
From: halli manjunatha <manjunatha_halli@ti.com>
Date: Mon, 17 Jan 2011 15:45:46 +0530
X-Google-Sender-Auth: hR0H0wEoghL0Oas5tnxXBm26rsY
Message-ID: <AANLkTimRLGYugF+2=-nFvLeXdnLOy8Morx_wxzVTt9w5@mail.gmail.com>
Subject: Re: [RFC V10 3/7] drivers:media:radio: wl128x: FM Driver Common sources
To: Hans Verkuil <hverkuil@xs4all.nl>, mchehab@infradead.org
Cc: linux-kernel@vger.kernel.org, linux-media@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Hans and Mauro,

If there are no major comments for the V10 of FM V4L2 driver, is it
possible to take this driver (V10) to mainline?

Since the files are becoming big to be posted as patches and
maintaining it that way is a bit difficult. We can submit the patches
to mainline to fix minor comments and also to add newer features
(complete scan, stop seek) as patches once this driver makes its way
in to mainline.

Please let me know your views on this.

Thanks,
Manju


On Tue, Jan 11, 2011 at 6:12 PM, Raja Mani <rajambsc@gmail.com> wrote:
> balbi,
>
>  Agree , interrupt pkts could have handled in thread context . But in
> the current way , FM driver never create any additional task in the
> system
>  to handle FM interrupt. In fact, there is no task being created in
> this driver to handle FM RDS data, AF,etc.
>
>  This method is suitable for light weight system where we want to
> reduce number of thread in the system.
>
>  On Tue, Jan 11, 2011 at 4:54 PM, Felipe Balbi <balbi@ti.com> wrote:
>> Hi,
>>
>> On Tue, Jan 11, 2011 at 06:31:23AM -0500, manjunatha_halli@ti.com wrote:
>>> From: Manjunatha Halli <manjunatha_halli@ti.com>
>>>
>>> These are the sources for the common interfaces required by the
>>> FM V4L2 driver for TI WL127x and WL128x chips.
>>>
>>> These implement the FM channel-8 protocol communication with the
>>> chip. This makes use of the Shared Transport as its transport.
>>>
>>> Signed-off-by: Manjunatha Halli <manjunatha_halli@ti.com>
>>> Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
>>
>> looks like this is implementing a "proprietary" (by that I mean: for
>> this driver only) IRQ API. Why aren't you using GENIRQ with threaded
>> IRQs support ?
>>
>> Core IRQ Subsystem would handle a lot of stuff for you.
>>
>> --
>> balbi
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-media" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Regards,
> Raja.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-media" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



-- 
Regards
Halli
