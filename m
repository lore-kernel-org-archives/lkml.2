Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753472Ab0DIWNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 18:13:39 -0400
Received: from mail1.radix.net ([207.192.128.31]:33431 "EHLO mail1.radix.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751444Ab0DIWNe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 18:13:34 -0400
Subject: Re: [RFC] What are the goals for the architecture of an in-kernel
 IR  system?
From: Andy Walls <awalls@radix.net>
To: Devin Heitmueller <dheitmueller@kernellabs.com>
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
       James Hogan <james@albanarts.com>, Jon Smirl <jonsmirl@gmail.com>,
       Pavel Machek <pavel@ucw.cz>,
       Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Krzysztof Halasa <khc@pm.waw.pl>,
       hermann pitton <hermann-pitton@arcor.de>,
       Christoph Bartelmus <lirc@bartelmus.de>, j@jannau.net, jarod@redhat.com,
       jarod@wilsonet.com, kraxel@redhat.com, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, linux-media@vger.kernel.org,
       superm1@ubuntu.com
In-Reply-To: <g2k829197381004091455m20368cc6r63df4a4f00d36b45@mail.gmail.com>
References: <9e4733910912060952h4aad49dake8e8486acb6566bc@mail.gmail.com>
	 <9e4733910912151338n62b30af5i35f8d0963e6591c@mail.gmail.com>
	 <4BAB7659.1040408@redhat.com> <201004090821.10435.james@albanarts.com>
	 <1270810226.3764.34.camel@palomino.walls.org> <4BBF253A.8030406@redhat.com>
	 <g2k829197381004091455m20368cc6r63df4a4f00d36b45@mail.gmail.com>
Content-Type: text/plain
Date: Fri, 09 Apr 2010 18:14:00 -0400
Message-Id: <1270851240.3038.51.camel@palomino.walls.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.5 (2.24.5-2.fc10) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-04-09 at 17:55 -0400, Devin Heitmueller wrote:
> On Fri, Apr 9, 2010 at 9:01 AM, Mauro Carvalho Chehab
> <mchehab@redhat.com> wrote:
> > [1] Basically, a keycode (like KEY_POWER) could be used to wake up the machine. So, by
> > associating some scancode to KEY_POWER via ir-core, the driver can program the hardware
> > to wake up the machine with the corresponding scancode. I can't see a need for a change at
> > ir-core to implement such behavior. Of course, some attributes at sysfs can be added
> > to enable or disable this feature, and to control the associated logic, but we first
> > need to implement the wakeup feature at the hardware driver, and then adding some logic
> > at ir-core to add the non-hardware specific code there.
> 
> Really?  Have you actually seen any hardware where a particular scan
> code can be used to wake up the hardware?  The only hardware I have
> seen has the ability to unsuspend on arrival of IR traffic, but you
> didn't have the granularity to dictate that it only wake up on
> particular scancodes.

The CX23888 and CX23102 can do it.  Basically any IR pulse pattern your
heart desires; within reason.  And any carrier freq you want too; within
reason.

But let's be real, the cx23885, cx231xx, and cx25840 modules are nowhere
near properly supporing suspend/resume for their main video and DMA
functions, AFAIK.

Regards,
Andy


