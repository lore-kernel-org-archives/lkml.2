Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758008Ab2D1ACh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 20:02:37 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:47908 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756824Ab2D1ACg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 20:02:36 -0400
Message-ID: <4F9B3398.9060701@lwfinger.net>
Date: Fri, 27 Apr 2012 19:02:32 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120328 Thunderbird/11.0.1
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Paul Mackerras <paulus@samba.org>, linuxppc-dev@lists.ozlabs.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression in 32-bit ppc kernel
References: <4F973026.3020103@lwfinger.net>  <1335311621.15830.42.camel@pasglop> <4F976352.4060001@lwfinger.net>  <1335327081.21961.28.camel@pasglop> <4F98117C.7080309@lwfinger.net>  <1335390257.21961.53.camel@pasglop> <4F9ABD67.3060704@lwfinger.net> <1335565573.20866.7.camel@pasglop>
In-Reply-To: <1335565573.20866.7.camel@pasglop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/27/2012 05:26 PM, Benjamin Herrenschmidt wrote:
> On Fri, 2012-04-27 at 10:38 -0500, Larry Finger wrote:
>
>> Sorry, I was unable to find anything in debugfs to help me learn about interrupt
>> mapping. The value of CONFIG_NR_IRQS is already 512. I have not tried reducing
>> it to 128. The setting for CONFIG_SPARSE_IRQ was on, and changing it to off did
>> not make any difference.
>>
>> I finished the bisection, which led to
>>
>> commit a79dd5ae5a8f49688d65b89a859f2b98a7ee5538
>> Author: Benjamin Herrenschmidt<benh@kernel.crashing.org>
>> Date:   Thu Dec 15 11:13:03 2011 +1100
>>
>>       tty/serial/pmac_zilog: Fix suspend&  resume
>>
>> As this seemed to be an improbable result, I did the full test by checking out
>> the previous commit (43ca5d3). That resulted in a "good" result. Then I used
>> quilt to add commit a79dd5a as a patch and the fault returned. I then noticed
>> that you said in the commit message that "I removed some code for handling
>> unexpected interrupt which should never be hit...". It appears that my box does
>> indeed hit such an unexpected interrupt.
>>
>> I could always get rid of the fault by disabling CONFIG_SERIAL_PMACZILOG, but I
>> would like to fix the problem if possible.
>
> Right, it should be fixed. I need to understand where the unexpected
> interrupt comes from. Can you tell me (or remind me) what specific
> machine model you are using ? Are you putting the console on the serial
> port ?

It is a 15" Powerbook G4. I think they call it a Titanium. The console is not on 
a serial port. In fact, the reason that I did not think this patch was a problem 
is because the serial port does not appear to be connected to an external port. 
I was unaware that there was a serial port on the motherboard. There is a modem 
jack, but no 9 or 25-pin connectors that would indicate a standard serial port.

There are two stack dumps with the same trace. I posted the first, but the 
second is preceded by the lines

[<c02adca0] pmz_interrupt
Disabling IRQ #23
ttyPZ1: IrDA setup for 57600 bps, dongle version: 4
ttyPZ1: IrDA setup for 115200 bps, dongle version: 4
irq23: nobody cared (try booting with the "irqpoll" option

As I am not sure how to put options in with yaboot, I have not tried that.

Larry


