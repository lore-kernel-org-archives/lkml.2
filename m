Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754568Ab1JMKIT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Oct 2011 06:08:19 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:45312 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab1JMKIS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Oct 2011 06:08:18 -0400
Message-ID: <4E96B88E.6030109@monstr.eu>
Date: Thu, 13 Oct 2011 12:08:14 +0200
From: Michal Simek <monstr@monstr.eu>
Reply-To: monstr@monstr.eu
User-Agent: Thunderbird 2.0.0.22 (X11/20090625)
MIME-Version: 1.0
To: "Ted Ts'o" <tytso@mit.edu>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        monstr@monstr.eu, linux-serial@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@suse.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Korsgaard <jacmet@sunsite.dk>
Subject: Re: Using serial driver 16550A in poll mode without interrupt connected
References: <4E95902B.7080204@monstr.eu> <20111012145153.5490b592@lxorguk.ukuu.org.uk> <20111012151937.GL11548@thunk.org>
In-Reply-To: <20111012151937.GL11548@thunk.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ted Ts'o wrote:
> On Wed, Oct 12, 2011 at 02:51:53PM +0100, Alan Cox wrote:
>>> Driver is probed with no IRQ (NO_IRQ = -1 on Microblaze)
>>> 83e00000.serial: ttyS0 at MMIO 0x83e01003 (irq = -1) is a 16550A
>> Zero means no IRQ. NO_IRQ is a legacy internal thing for the old IDE code
>> so not something other code should be using. Setting the IRQ to -1 is
>> bogus and will confuse the rest of the kernel.
>>
>>> Is it possible to use serial driver without IRQ - or blocking IRQ, etc.?
>> Within limits - it kills your power management and data rates because of
>> the continual polling.
> 
> It was something that I implemented years ago primarily for crappy
> hardware that didn't get interrupts right.  It's not something which
> where I would advise anyone to intentionally design hardware to use.

It shouldn't be crappy hardware in our case because in FPGA you can connect it yourself.
It is pretty easy to connect IRQ and choose interrupt number.

> 
> If you have really deep FIFO's (i.e., a kilobyte or more), and you're
> primarily interested in throughput, not latency, and/or you are trying
> to support tens or hundreds of serial ports for some kind of modem
> pool, there is a place for a polled implementation. 

I don't personally care about throughput or latency or even how deep FIFO is.
It could be several bytes - just send command and receive status or so.
Or if this need large fifo - you can just add it to your hw design.

For example our interrupt controller supports up to 32 interrupt lines.
If someone decides to use more that 32 serial IPs(include some lines for timer, etc)
we don't have support for IRQ cascades and for getting status over serial line will
be easier to use polling. As you write below there should be a lot of interrupts too.

See the Comtrol
> Rockport for an example of hardware and with a linux driver that will
> handle this.  It's basically a "NAPI for serial ports" sort of
> approach to minimize the overhead of potentially hundreds of thousands
> of interrupts per second if you are driving large numbers of ports
> (and at that point, power management is the least of your concerns
> :-).  But you need special hardware to do this, not a random 16550A
> with a pathetically small 16 byte FIFO.

Can you point me to that files? Is it in the mainline kernel?

Thanks,
Michal


-- 
Michal Simek, Ing. (M.Eng)
w: www.monstr.eu p: +42-0-721842854
Maintainer of Linux kernel 2.6 Microblaze Linux - http://www.monstr.eu/fdt/
Microblaze U-BOOT custodian
