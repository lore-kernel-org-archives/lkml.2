Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949Ab0JHEcj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 00:32:39 -0400
Received: from void.printf.net ([89.145.121.20]:56493 "EHLO void.printf.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751279Ab0JHEcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 00:32:39 -0400
From: Chris Ball <cjb@laptop.org>
To: Man Spaz <man.spaz@ymail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Tips on debugging suspend/resume failure
References: <103889.39682.qm@web120217.mail.ne1.yahoo.com>
Date: Fri, 08 Oct 2010 00:37:11 -0400
In-Reply-To: <103889.39682.qm@web120217.mail.ne1.yahoo.com> (Man Spaz's
	message of "Thu, 7 Oct 2010 21:09:21 -0700 (PDT)")
Message-ID: <m339shmhag.fsf@pullcord.laptop.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1.90 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

   > But the question remains, how to get debug out? Is there a dmesg
   > buffer that can persist if DRAM is being refreshed perhaps?

The most promising attempts involve using GPU RAM to store dmesg,
since it persists across a soft reboot and isn't going to be
overwritten as long as you get to it before the video driver does
after the crash.  (Which you can ensure by blacklisting the driver.)

   > Is there another way to skin this mongrel, I mean cat? 

The most basic tool is probably CONFIG_PM_TRACE, which uses the
real-time clock to store a signature for the last driver to init
during suspend/resume -- after the crash, the kernel will interpret
the RTC hash it placed to give you a hint as to what might be failing.

The real answer, though, is to just keep trying to find any way at all
to get usable serial output, including by finding a different machine
with the same problem that has a serial port.

- Chris.
-- 
Chris Ball   <cjb@laptop.org>   <http://printf.net/>
One Laptop Per Child
