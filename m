Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932150Ab1DAPjp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:39:45 -0400
Received: from ns2.coplanar.net ([199.27.182.4]:37144 "EHLO titan.coplanar.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755508Ab1DAPjo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:39:44 -0400
Message-ID: <4D95F1B0.9060304@coplanar.net>
Date: Fri, 01 Apr 2011 11:39:28 -0400
From: Jeremy Jackson <jerj@coplanar.net>
Organization: Coplanar Networks
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
CC: Randy Dunlap <rdunlap@xenotime.net>, linux-kernel@vger.kernel.org
Subject: Re: signal to PID 1 from serial console like KeyboardRequest or CAD
References: <4D8CD3D4.90900@coplanar.net> <20110331125706.9159a13d.rdunlap@xenotime.net> <20110401053757.GA9866@core.coreip.homeip.net>
In-Reply-To: <20110401053757.GA9866@core.coreip.homeip.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (titan.coplanar.net [199.27.182.2]); Fri, 01 Apr 2011 11:39:40 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2011 01:37 AM, Dmitry Torokhov wrote:
> On Thu, Mar 31, 2011 at 12:57:06PM -0700, Randy Dunlap wrote:
>> On Fri, 25 Mar 2011 13:41:40 -0400 Jeremy Jackson wrote:
>>
>>> Hi,
>>>
>>> Sent to linux-console with no reply for over a week...
>>>
>>> I ran into a problem recently on a Linux server with a remote serial
>>> console.  /sbin/init (actually Upstart) was in a state where nothing
>>> (useful) was running.  I had to power cycle the machine to get back to
>>> the boot prompt.  This has the side-effect of triggering raid rebuilds.
>>>
>>> It would be nice to have what Ctrl-Alt-Del does at the VGA console with
>>> PS/2 or USB keyboard. This sends a SIGINT to PID 1, and most distros
>>> have this set to do "shutdown -r now" which attempts a clean reboot.
>>
>> so C_A_D works at console via PS/2 or USB keyboard, but not on a remote
>> serial console?  Could it be an issue with whatever remote/serial software
>> you are using?
>
> I believe it is simply a matter of console keymap and assigning "boot"
> value to the desired combination.

The VGA console/keyboard isn't an issue here, C_A_D works great.  The 
problem is, that functionality isn't available when using *serial* console.

>>> Once upon a time there was KeyboardRequest, which would send a SIGWINCH
>>> to PID 1 (when pressing Alt-UP_arrow?).  I don't see any sign of this
>>> feature in Linux 2.6.32 though.
>>
>> I couldn't find it in 2.4.37 either.
>>
>> Can 'loadkeys' help you any?
>>
>>> Looking at the Sysrq handlers in the kernel I don't see any keystrokes
>>> that send SIGINT to PID 1 either.
>>>
>>> So, I'm wondering if it makes sense to add a Sysrq key to send a signal
>>> to PID1 ?
>>
>> Dmitry, any ideas?
>
> We have SysRq bindings to unmount filesystems and reboot, isn't that
> enough?

Reboot isn't clean... it doesn't signal MD-raid to "unmount" does it? 
SysRq powerOff does cleanly shutdown md-raid, but who will drive to the 
datacenter to press the power button to turn it back on?

I guess there are two ways to achieve clean (md-raid) reboot when using 
serial console... a new SysRq to reboot "clean", or a new SysRq to 
signal init.  Looking at ctrlaltdel(8), perhaps it could just one SysRq, 
and let userspace (/sbin/init) configure it as needed.


-- 
Coplanar Networks
http://www.coplanar.net
(519)489-4903
