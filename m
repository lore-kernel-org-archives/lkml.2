Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758016Ab1DAPrZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Apr 2011 11:47:25 -0400
Received: from ns2.coplanar.net ([199.27.182.4]:40330 "EHLO titan.coplanar.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751316Ab1DAPrY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Apr 2011 11:47:24 -0400
Message-ID: <4D95F37E.8080107@coplanar.net>
Date: Fri, 01 Apr 2011 11:47:10 -0400
From: Jeremy Jackson <jerj@coplanar.net>
Organization: Coplanar Networks
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.14) Gecko/20110223 Thunderbird/3.1.8
MIME-Version: 1.0
To: Randy Dunlap <rdunlap@xenotime.net>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: signal to PID 1 from serial console like KeyboardRequest or CAD
References: <4D8CD3D4.90900@coplanar.net>	<20110331125706.9159a13d.rdunlap@xenotime.net>	<20110401053757.GA9866@core.coreip.homeip.net>	<4D95F1B0.9060304@coplanar.net> <20110401084218.d803b38d.rdunlap@xenotime.net>
In-Reply-To: <20110401084218.d803b38d.rdunlap@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.3.4 (titan.coplanar.net [199.27.182.2]); Fri, 01 Apr 2011 11:47:21 -0400 (EDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2011 11:42 AM, Randy Dunlap wrote:
> On Fri, 01 Apr 2011 11:39:28 -0400 Jeremy Jackson wrote:
>
>> On 04/01/2011 01:37 AM, Dmitry Torokhov wrote:
>>> On Thu, Mar 31, 2011 at 12:57:06PM -0700, Randy Dunlap wrote:
>>>> On Fri, 25 Mar 2011 13:41:40 -0400 Jeremy Jackson wrote:
>>>>
>>>>> Hi,
>>>>>
>>>>> Sent to linux-console with no reply for over a week...
>>>>>
>>>>> I ran into a problem recently on a Linux server with a remote serial
>>>>> console.  /sbin/init (actually Upstart) was in a state where nothing
>>>>> (useful) was running.  I had to power cycle the machine to get back to
>>>>> the boot prompt.  This has the side-effect of triggering raid rebuilds.
>>>>>
>>>>> It would be nice to have what Ctrl-Alt-Del does at the VGA console with
>>>>> PS/2 or USB keyboard. This sends a SIGINT to PID 1, and most distros
>>>>> have this set to do "shutdown -r now" which attempts a clean reboot.
>>>>
>>>> so C_A_D works at console via PS/2 or USB keyboard, but not on a remote
>>>> serial console?  Could it be an issue with whatever remote/serial software
>>>> you are using?
>>>
>>> I believe it is simply a matter of console keymap and assigning "boot"
>>> value to the desired combination.
>>
>> The VGA console/keyboard isn't an issue here, C_A_D works great.  The
>> problem is, that functionality isn't available when using *serial* console.
>
> That's why I asked whether it could be an issue with the serial interface
> software.  E.g., minicom handles/processes certain keystrokes, other apps do things
> differently, etc...

OK I guess I should clarify... when using Linux serial console, you can 
send BREAK <letter> to use SysRq functions.  In minicom, META-F sends 
break.  This works fine for all the existing functions linux offers, r = 
reboot immediate, i = kill all tasks, etc.  But, there is no function 
available to reboot *clean*, or to signal PID 1 (/sbin/init) to do same. 
  So, minicom is working/configured properly, Linux just doesn't offer a 
feature similar to C_A_D via serial.

-- 
Coplanar Networks
http://www.coplanar.net
(519)489-4903
