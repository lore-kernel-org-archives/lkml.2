Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755284Ab0DIKuA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 06:50:00 -0400
Received: from mail1.radix.net ([207.192.128.31]:47317 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754776Ab0DIKt6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 06:49:58 -0400
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR 	system?
From: Andy Walls <awalls@radix.net>
To: James Hogan <james@albanarts.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>, Jon Smirl <jonsmirl@gmail.com>,
       Pavel Machek <pavel@ucw.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, j@jannau.net, jarod@redhat.com,
       jarod@wilsonet.com, kraxel@redhat.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       superm1@ubuntu.com
In-Reply-To: <201004090821.10435.james@albanarts.com>
References: <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>
	 <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com>
	 <4BAB7659.1040408@redhat.com>  <201004090821.10435.james@albanarts.com>
Content-Type: text/plain
Date: Fri, 09 Apr 2010 06:50:26 -0400
Message-Id: <1270810226.3764.34.camel@palomino.walls.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-09 at 08:21 +0100, James Hogan wrote:
> Hi,
> 
> On Thursday 25 March 2010 14:42:33 Mauro Carvalho Chehab wrote:
> > Comments?
> 
> I haven't seen this mentioned yet, but are there any plans for a sysfs 
> interface to set up waking from suspend/standby on a particular IR scancode 
> (for hardware decoders that support masking of comparing of the IR data), kind 
> of analagous to the rtc framework's wakealarm sysfs file?

This requires support at the hardware level.  (You can't have CPU code
running to decode IR pulses when your CPU is "asleep".)

I know of two video chips supported under linux that provide such a
function.

Wake-up from IR for these chips will rely on the kernel PCIe or USB
infrastructure supporting PCIe or USB Power Managment Events from
hardware.  It will take a huge amount of work and time to get the
respective linux video drivers to properly support suspend/resume
properly.

If you're waiting for me to get that working, I'll advise you to plan on
getting off the couch and pushing the power switch for some time to
come. ;)




The MCE-USB, I *speculate*, can perform wakes.  It's driver would need
to support that, if it can.

Regards,
Andy

