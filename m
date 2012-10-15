Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754788Ab2JOUmp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Oct 2012 16:42:45 -0400
Received: from mail-ia0-f174.google.com ([209.85.210.174]:53193 "EHLO
	mail-ia0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab2JOUmn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Oct 2012 16:42:43 -0400
MIME-Version: 1.0
In-Reply-To: <20121007210359.29f40ecf@endymion.delvare>
References: <1347630103-4105-1-git-send-email-benjamin.tissoires@gmail.com>
	<20121007162838.01f36b7c@endymion.delvare>
	<CAN+gG=E3nmXZ9RL3wN2tvKqSOu5hWYLXLf+Z=ag7VvZGJfhQ-w@mail.gmail.com>
	<20121007210359.29f40ecf@endymion.delvare>
Date: Mon, 15 Oct 2012 22:42:41 +0200
Message-ID: <CAN+gG=H9OfEyVaOD6r3Q5CZHNY2d1gAUr=kBAgXs-qacUDqsOw@mail.gmail.com>
Subject: Re: [PATCH v1] i2c-hid: introduce HID over i2c specification implementation
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: Jean Delvare <khali@linux-fr.org>
Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>, Jiri Kosina <jkosina@suse.cz>,
        Stephane Chatty <chatty@enac.fr>, fabien.andre@gmail.com,
        scott.liu@emc.com.tw, Ben Dooks <ben-linux@fluff.org>,
        Wolfram Sang <w.sang@pengutronix.de>, linux-i2c@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 7, 2012 at 9:03 PM, Jean Delvare <khali@linux-fr.org> wrote:
> On Sun, 7 Oct 2012 18:57:36 +0200, Benjamin Tissoires wrote:
>> On Sun, Oct 7, 2012 at 4:28 PM, Jean Delvare <khali@linux-fr.org> wrote:
>> > On Fri, 14 Sep 2012 15:41:43 +0200, benjamin.tissoires wrote:
>> >> +     u16 readRegister = ihid->hdesc.wDataRegister;
>> >
>> > This is missing le16_to_cpu().
>>
>> I agree this is awful, but not putting it allows me to not have to
>> check the endianness when I'm using it.
>> But I may be totally wrong on this.
>
> I'm afraid I don't follow you. I want to see:
>
>         u16 readRegister = le16_to_cpu(ihid->hdesc.wDataRegister);
>
> If you don't do that, your driver is broken on bigendian systems. And
> there's no need to "check the endianness when you're using it", the
> above should be enough for things to work just fine.
>

a little bit late, but yes, you are entirely right. I was confused by
the fact that I only wanted to use the number coming from the device
to communicate with it, but as I made bit shifting within the CPU, I
need to convert it.
So forget my previous words here, it is fixed in v2.

Thanks
Benjamin

> --
> Jean Delvare
