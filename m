Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272Ab0DJBCo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 21:02:44 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20411 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751135Ab0DJBCh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 21:02:37 -0400
Message-ID: <4BBFCDDE.7050405@redhat.com>
Date: Fri, 09 Apr 2010 22:01:18 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Jon Smirl <jonsmirl@gmail.com>
CC: Andy Walls <awalls@radix.net>,
       Devin Heitmueller <dheitmueller@kernellabs.com>,
       James Hogan <james@albanarts.com>, Pavel Machek <pavel@ucw.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, j@jannau.net, jarod@redhat.com,
       jarod@wilsonet.com, kraxel@redhat.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR 	system?
References: <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>	 <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com>	 <4BAB7659.1040408@redhat.com> <201004090821.10435.james@albanarts.com>	 <1270810226.3764.34.camel@palomino.walls.org>	 <4BBF253A.8030406@redhat.com>	 <g2k829197381004091455m20368cc6r63df4a4f00d36b45@mail.gmail.com>	 <1270851240.3038.51.camel@palomino.walls.org>	 <4BBFB925.7080606@redhat.com> <l2y9e4733911004091718s4404d983o3894f78a75d996f3@mail.gmail.com>
In-Reply-To: <l2y9e4733911004091718s4404d983o3894f78a75d996f3@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jon Smirl wrote:
> On Fri, Apr 9, 2010 at 7:32 PM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> 
>> [1] Yet, none of the in-hardware decoders allow resume, AFAIK. With a software
>> decoder, the IR IRQ might be used to wake, but this means that everything,
>> even a glitch, would wake the hardware, so this won't work neither.
> 
> On my embedded hardware there is 100KB of static RAM on the CPU die.
> It is preserved even in deep sleep. An IR pulse can wake the CPU and
> run code in this 100KB RAM. Then the CPU can decide whether it wants
> to power on main RAM and restore the OS. But implementing this is
> outside the scope of the Linux kernel.
> 
> In someways this is how an MSMCE behaves in suspend. There is code
> running on the MCU inside the MSMCE receiver. Too bad we can't tell it
> a pattern to watch for and then trigger USB wake up. It is easy to
> build a MSMCE clone, maybe someone will clone it and add the wakeup
> pattern match. An enterprising hacker can probably change the firmware
> in the existing devices.

Waking up the entire hardware just because an IRQ was triggered doesn't seem
a good idea on PC's. Here, I had to put the IR sensors behind the table
to avoid receiving too many noise from my room's lamp.
If I put it on the right place, I start receiving several of glitches per
second. I doubt this would be useful for suspend/resume operations.

-- 

Cheers,
Mauro
