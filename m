Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753804Ab1AZRql (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 12:46:41 -0500
Received: from mx1.redhat.com ([209.132.183.28]:30787 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753469Ab1AZRqj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 12:46:39 -0500
Message-ID: <4D405CAD.5040107@redhat.com>
Date: Wed, 26 Jan 2011 15:41:01 -0200
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101208 Red Hat/3.1.7-3.el6_0 Lightning/1.0b2 Thunderbird/3.1.7
MIME-Version: 1.0
To: Mark Lord <kernel@teksavvy.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-input@vger.kernel.org, linux-media@vger.kernel.org,
        Gerd Hoffmann <kraxel@redhat.com>
Subject: Re: 2.6.36/2.6.37: broken compatibility with userspace input-utils
 ?
References: <4D3E59CA.6070107@teksavvy.com> <4D3E5A91.30207@teksavvy.com> <20110125053117.GD7850@core.coreip.homeip.net> <4D3EB734.5090100@redhat.com> <20110125164803.GA19701@core.coreip.homeip.net> <AANLkTi=1Mh0JrYk5itvef7O7e7pR+YKos-w56W5q4B8B@mail.gmail.com> <20110125205453.GA19896@core.coreip.homeip.net> <4D3F4804.6070508@redhat.com> <4D3F4D11.9040302@teksavvy.com> <20110125232914.GA20130@core.coreip.homeip.net> <20110126020003.GA23085@core.coreip.homeip.net> <4D4004F9.6090200@redhat.com> <4D403693.50702@teksavvy.com>
In-Reply-To: <4D403693.50702@teksavvy.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 26-01-2011 12:58, Mark Lord escreveu:
> On 11-01-26 06:26 AM, Mauro Carvalho Chehab wrote:
> ..
>> However, as said previously in this thread, input-kbd won't work with any
>> RC table that uses NEC extended (and there are several devices on the
>> current Kernels with those tables), since it only reads up to 16 bits.
>>
>> ir-keytable works with all RC tables, if you use a kernel equal or upper to
>> 2.6.36, due to the usage of the new ioctl's.
> 
> Is there a way to control the key repeat rate for a device
> controlled by ir-kbd-i2c ?
> 
> It appears to be limited to a max of between 4 and 5 repeats/sec somewhere,
> and I'd like to fix that.

It depends on what device do you have. Several I2C chips have the repeat
logic inside the I2C microcontroller PROM firmware. or at the remote
controller itself. So, there's nothing we can do to change it.

I have even one device here (I think it is a saa7134-based Kworld device) 
that doesn't send any repeat event at all for most keys (I think it only
sends repeat events for volume - Can't remember the specific details anymore -
too many devices!).

The devices that produce repeat events can be adjusted via the normal
input layer tools like kbdrate.

Thanks,
Mauro
