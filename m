Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752976Ab1EFMLt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 May 2011 08:11:49 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:37933 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab1EFMLr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 May 2011 08:11:47 -0400
Message-ID: <4DC3E580.9090500@petalogix.com>
Date: Fri, 06 May 2011 14:11:44 +0200
From: Michal Simek <michal.simek@petalogix.com>
Reply-To: michal.simek@petalogix.com
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: johnlinn@comcast.net
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@kroah.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        joe@perches.com, grant likely <grant.likely@secretlab.ca>,
        John Linn <john.linn@xilinx.com>
Subject: Re: [PATCH V4] tty/serial: add support for Xilinx PS UART
References: <1013673718.2094564.1304113268455.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
In-Reply-To: <1013673718.2094564.1304113268455.JavaMail.root@sz0140a.emeryville.ca.mail.comcast.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

johnlinn@comcast.net wrote:
>>> Yes I'll have a look at it, sorry for the hassle.  
>>>
>>> I'm assuming I need to try it against linus
>>> tree as something may have changed. Or some other tree?
>> Or you are assuimg NO_IRQ is defined everywhere which it isn't. The
>> kernel mainstream just uses zero as intended not a define for it.
>>
>> Alan
> 
> Ahh... maybe I see, it's only defined in ARM and that's what I was building
> for.  I'm a little slow sometimes, but I'll get there.
> 
> Gotcha, replace with 0. Thanks.

I don't agree with this change. NO_IRQ for microblaze, arm and other is -1. BTW: 
For ppc is 0. Using NO_IRQ seems to me reasonable.

you are including linux/irq.h which include asm/irq.h for all platforms except 
s390. I think that is better to find out where the real problem is instead of 
using any hardcoded value.

If I look at xuartps_get_port function then you don't even need to initialize it 
to NO_IRQ because if there is no IRQ connected driver is not probed. That's why
"port->irq = res2->start;" is enough.
I would suggest to completely remove that line from xuartps_get_port


Michal




-- 
Michal Simek, Ing. (M.Eng)
PetaLogix - Linux Solutions for a Reconfigurable World
w: www.petalogix.com p: +61-7-30090663,+42-0-721842854 f: +61-7-30090663
