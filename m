Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752703Ab0JGXoE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 19:44:04 -0400
Received: from mail.windriver.com ([147.11.1.11]:61759 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751842Ab0JGXoD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 19:44:03 -0400
Message-ID: <4CAE5B40.3070701@windriver.com>
Date: Thu, 07 Oct 2010 18:44:00 -0500
From: Jason Wessel <jason.wessel@windriver.com>
User-Agent: Thunderbird 2.0.0.24 (X11/20100411)
MIME-Version: 1.0
To: Elvis Dowson <elvis.dowson@mac.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Subject: Re: kgdb errors with serial console
References: <BDD07355-7199-4A2E-8426-F6D43EA5D313@mac.com> <4CAE4BB6.7080509@windriver.com> <7BA01CAF-DD25-4AB6-9498-8AB89E2EDDE1@mac.com>
In-Reply-To: <7BA01CAF-DD25-4AB6-9498-8AB89E2EDDE1@mac.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 07 Oct 2010 23:44:01.0683 (UTC) FILETIME=[84E46E30:01CB6679]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/07/2010 06:07 PM, Elvis Dowson wrote:
> On Oct 8, 2010, at 2:37 AM, Jason Wessel wrote:
>
>   
>> It would probably also be good to test if the debugger is working at all
>> on your serial port.
>>
>> Configure the debugger with:
>> # echo ttyS2 > /sys/module/kgdboc/parameters/kgdboc
>> kgdb: Registered I/O driver kgdboc.
>> # echo g > /proc/sysrq-trigger
>> SysRq : DEBUG
>>
>> And now to exit debugger you must blindly and perfectly type
>> $D#44+
>>
>> Nothing will be echoed because at this stage the kernel serial polling
>> driver would just be collecting characters.
>>
>> After typing that the kernel should return back to the running state and
>> print something like:
>> +$OK#9a#
>>     
>
> Cool, I tried all the commands that you suggested and it worked perfectly. I got the same outputs. 
>
> So, if I understand correctly, I boot into the kernel without the kgbdwait option, and then manually launch the kgdb and then connect from Eclipse using gdb.
>
> The system waits at the root login prompt. 
>   

Probably just set a break point at sys_sync.

Of course if you are willing to try something a bit more complex you can
probably make use of being able to interactively break in with the
eclipse gdb plugin, assuming your serial port is connected to a linux
host, and it appeared that way based on your description.

On your host you could set up the following:


git clone git://git.kernel.org/pub/scm/utils/kernel/kgdb/agent-proxy.git
cd agent-proxy
make
./agent-proxy 4440^4441 0 /dev/ttyUSB0,115200 &

telnet localhost 4440

Now in your gdbinit file you replace the target remote with

target remote localhost:4441

The agent proxy should take care of sending the sysrq g for you, and the
telnet window will provide you a look at the target console.

Jason.

