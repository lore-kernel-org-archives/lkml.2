Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab0DINCQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 09:02:16 -0400
Received: from qw-out-2122.google.com ([74.125.92.24]:27378 "EHLO
	qw-out-2122.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751431Ab0DINCM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 09:02:12 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=BFZXQ5iLtg/YKRWPHHI1nB6kxkDaSHsmiOruONuiPqBDelFhgAVadUh7hRNdyrf2td
         65dPKF9UgcUj2emiZWq3YT+n6LKZHwAt9Ktc1ASUrU+IsMHQfWyD85FQIHHwEda+wka5
         2T/IYuJRTeqE4ECjlX+jh0FmU7J8knm00bVhs=
MIME-Version: 1.0
In-Reply-To: <20100409125832.GA22814@redhat.com>
References: <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>
	 <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com>
	 <4BAB7659.1040408@redhat.com> <201004090821.10435.james@albanarts.com>
	 <1270810226.3764.34.camel@palomino.walls.org>
	 <20100409125832.GA22814@redhat.com>
Date: Fri, 9 Apr 2010 09:02:09 -0400
Message-ID: <m2q9e4733911004090602lbcd11b8dle65eaccc1bc34dce@mail.gmail.com>
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel IR 
	system?
From: Jon Smirl <jonsmirl@gmail.com>
To: Jarod Wilson <jarod@redhat.com>
Cc: Andy Walls <awalls@radix.net>, James Hogan <james@albanarts.com>,
       Mauro Carvalho Chehab <mchehab@redhat.com>, Pavel Machek <pavel@ucw.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, j@jannau.net,
       jarod@wilsonet.com, kraxel@redhat.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       superm1@ubuntu.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 9, 2010 at 8:58 AM, Jarod Wilson <jarod@redhat.com> wrote:
> On Fri, Apr 09, 2010 at 06:50:26AM -0400, Andy Walls wrote:
>> On Fri, 2010-04-09 at 08:21 +0100, James Hogan wrote:
>> > Hi,
>> >
>> > On Thursday 25 March 2010 14:42:33 Mauro Carvalho Chehab wrote:
>> > > Comments?
>> >
>> > I haven't seen this mentioned yet, but are there any plans for a sysfs
>> > interface to set up waking from suspend/standby on a particular IR scancode
>> > (for hardware decoders that support masking of comparing of the IR data), kind
>> > of analagous to the rtc framework's wakealarm sysfs file?
>>
>> This requires support at the hardware level.  (You can't have CPU code
>> running to decode IR pulses when your CPU is "asleep".)
>>
>> I know of two video chips supported under linux that provide such a
>> function.
>>
>> Wake-up from IR for these chips will rely on the kernel PCIe or USB
>> infrastructure supporting PCIe or USB Power Managment Events from
>> hardware.  It will take a huge amount of work and time to get the
>> respective linux video drivers to properly support suspend/resume
>> properly.
>>
>> If you're waiting for me to get that working, I'll advise you to plan on
>> getting off the couch and pushing the power switch for some time to
>> come. ;)
>>
>>
>>
>>
>> The MCE-USB, I *speculate*, can perform wakes.  It's driver would need
>> to support that, if it can.
>
> Yep, it can perform wakes, and the current lirc_mceusb does support it,
> though it requires some screwing around with echoing something into
> somewhere in sysfs (for the usb controller its attached to) to enable it,

You probably need to tell the USB system to leave the MSMCE's power
turned on during suspend. Maybe the MSMCE driver can tell the USB
subsystem to leave it powered across suspend when the driver loads.

> from what I recall... Making it Just Work would be a good idea.
>
> --
> Jarod Wilson
> jarod@redhat.com
>
>



-- 
Jon Smirl
jonsmirl@gmail.com
