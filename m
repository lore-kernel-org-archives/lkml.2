Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754012Ab1AZTaW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 14:30:22 -0500
Received: from ironport2-out.teksavvy.com ([206.248.154.183]:16672 "EHLO
	ironport2-out.pppoe.ca" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753897Ab1AZTaU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 14:30:20 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: ApIBAI8EQE1Ld/sX/2dsb2JhbAAMhAbNfZEDgSODOHQEhRc
X-IronPort-AV: E=Sophos;i="4.60,381,1291611600"; 
   d="scan'208";a="89334251"
Message-ID: <4D40764B.5040306@teksavvy.com>
Date: Wed, 26 Jan 2011 14:30:19 -0500
From: Mark Lord <kernel@teksavvy.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-GB; rv:1.9.2.13) Gecko/20101207 Thunderbird/3.1.7
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <20110125164803.GA19701@core.coreip.homeip.net> <AANLkTi=1Mh0JrYk5itvef7O7e7pR+YKos-w56W5q4B8B@mail.gmail.com> <20110125205453.GA19896@core.coreip.homeip.net> <4D3F4804.6070508@redhat.com> <4D3F4D11.9040302@teksavvy.com> <20110125232914.GA20130@core.coreip.homeip.net> <20110126020003.GA23085@core.coreip.homeip.net> <4D4004F9.6090200@redhat.com> <4D403693.50702@teksavvy.com> <4D405CAD.5040107@redhat.com> <20110126175918.GA29268@core.coreip.homeip.net>
In-Reply-To: <20110126175918.GA29268@core.coreip.homeip.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-01-26 12:59 PM, Dmitry Torokhov wrote:
> On Wed, Jan 26, 2011 at 03:41:01PM -0200, Mauro Carvalho Chehab wrote:
>> Em 26-01-2011 12:58, Mark Lord escreveu:
>>> On 11-01-26 06:26 AM, Mauro Carvalho Chehab wrote:
>>> ..
>>>> However, as said previously in this thread, input-kbd won't work with any
>>>> RC table that uses NEC extended (and there are several devices on the
>>>> current Kernels with those tables), since it only reads up to 16 bits.
>>>>
>>>> ir-keytable works with all RC tables, if you use a kernel equal or upper to
>>>> 2.6.36, due to the usage of the new ioctl's.
>>>
>>> Is there a way to control the key repeat rate for a device
>>> controlled by ir-kbd-i2c ?
>>>
>>> It appears to be limited to a max of between 4 and 5 repeats/sec somewhere,
>>> and I'd like to fix that.
>>
>> It depends on what device do you have. Several I2C chips have the repeat
>> logic inside the I2C microcontroller PROM firmware. or at the remote
>> controller itself. So, there's nothing we can do to change it.
>>
>> I have even one device here (I think it is a saa7134-based Kworld device) 
>> that doesn't send any repeat event at all for most keys (I think it only
>> sends repeat events for volume - Can't remember the specific details anymore -
>> too many devices!).
>>
>> The devices that produce repeat events can be adjusted via the normal
>> input layer tools like kbdrate.
>>
> 
> Unfortunately kbdrate affects all connected devices and I am not sure if
> there is a utility allowing to set rate on individual devices. But here
> is the main part: 
> 
> static int input_set_rate(int fd,
> 			  unsigned int delay, unsigned int period)
> {
> 	unsigned int rep[2] = { delay, period };
> 
> 	if (ioctl(fd, EVIOCSREP, rep) < 0) {
> 		perror("evdev ioctl");
> 		return -1;
> 	}
> 	return 0;
> }
> 

Okay, if that's still a global in this day and age,
then I suppose I'll just have to special-case it here in my copy.

The hardware itself is capable of much faster repeat rates,
and prior to 2.6.36 I used to patch it for intelligent ramp-up
on repeats inside ir-kbd-i2c.

As of 2.6.36 that stopped working, and is now limited somewhere
to no more than one repeat every 210msecs.

Cheers
