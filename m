Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab0DINCX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 09:02:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20738 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab0DINCS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 09:02:18 -0400
Message-ID: <4BBF253A.8030406@redhat.com>
Date: Fri, 09 Apr 2010 10:01:46 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Thunderbird 2.0.0.22 (X11/20090609)
MIME-Version: 1.0
To: Andy Walls <awalls@radix.net>
CC: James Hogan <james@albanarts.com>, Jon Smirl <jonsmirl@gmail.com>,
       Pavel Machek <pavel@ucw.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, j@jannau.net, jarod@redhat.com,
       jarod@wilsonet.com, kraxel@redhat.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       superm1@ubuntu.com
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR 	system?
References: <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>	 <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com>	 <4BAB7659.1040408@redhat.com>  <201004090821.10435.james@albanarts.com> <1270810226.3764.34.camel@palomino.walls.org>
In-Reply-To: <1270810226.3764.34.camel@palomino.walls.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi James,

Andy Walls wrote:
> On Fri, 2010-04-09 at 08:21 +0100, James Hogan wrote:
>> Hi,
>>
>> On Thursday 25 March 2010 14:42:33 Mauro Carvalho Chehab wrote:
>>> Comments?
>> I haven't seen this mentioned yet, but are there any plans for a sysfs 
>> interface to set up waking from suspend/standby on a particular IR scancode 
>> (for hardware decoders that support masking of comparing of the IR data), kind 
>> of analagous to the rtc framework's wakealarm sysfs file?
> 
> This requires support at the hardware level.  (You can't have CPU code
> running to decode IR pulses when your CPU is "asleep".)

The additions at IR core, if needed [1], shouldn't be hard, but the main changes should
happen at the hardware driver level.  There's no current plans for it, at least from
my side, but, let's see if some hardware driver developers want to implement it on
the corresponding driver.

[1] Basically, a keycode (like KEY_POWER) could be used to wake up the machine. So, by 
associating some scancode to KEY_POWER via ir-core, the driver can program the hardware 
to wake up the machine with the corresponding scancode. I can't see a need for a change at
ir-core to implement such behavior. Of course, some attributes at sysfs can be added
to enable or disable this feature, and to control the associated logic, but we first
need to implement the wakeup feature at the hardware driver, and then adding some logic
at ir-core to add the non-hardware specific code there.

-- 

Cheers,
Mauro
