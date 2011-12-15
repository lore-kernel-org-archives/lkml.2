Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758799Ab1LOLNL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 06:13:11 -0500
Received: from bishop.asidev.net ([95.141.38.214]:42479 "EHLO
	bishop.asidev.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756110Ab1LOLNJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 06:13:09 -0500
X-Greylist: delayed 493 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Dec 2011 06:13:08 EST
Message-ID: <4EE9D44A.6010300@evidence.eu.com>
Date: Thu, 15 Dec 2011 12:04:42 +0100
From: Claudio Scordino <claudio@evidence.eu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: Alan Cox <alan@linux.intel.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>,
        Dave Bender <codehero@gmail.com>
Subject: Re: [PATCH] atmel_serial: fix spinlock lockup in RS485 code
References: <4EE9B42F.50004@evidence.eu.com> <4EE9C532.5050607@atmel.com>
In-Reply-To: <4EE9C532.5050607@atmel.com>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Il 15/12/2011 11:00, Nicolas Ferre ha scritto:
> On 12/15/2011 09:47 AM, Claudio Scordino :
>> Hi all.
>>
>> We have encountered a spinlock lockup in the RS485 part of the
>> atmel_serial driver.
>>
>> Here is the trace:
>>
>> [   68.030000] BUG: spinlock lockup on CPU#0, dnp_master/244, c07e82c0
>> [   68.040000] [<c002a790>] (unwind_backtrace+0x0/0xf0) from
>> [<c012f8f0>] (do_raw_spin_lock+0x10c/0x148)
>> [   68.050000] [<c012f8f0>] (do_raw_spin_lock+0x10c/0x148) from
>> [<c015152c>] (atmel_tasklet_func+0x10/0x708)
>> [   68.060000] [<c015152c>] (atmel_tasklet_func+0x10/0x708) from
>> [<c003bfd4>] (tasklet_action+0x8c/0xf4)
>> [   68.070000] [<c003bfd4>] (tasklet_action+0x8c/0xf4) from [<c003c630>]
>> (__do_softirq+0xa4/0x180)
>> [   68.080000] [<c003c630>] (__do_softirq+0xa4/0x180) from [<c003c764>]
>> (irq_exit+0x58/0xb0)
>> [   68.090000] [<c003c764>] (irq_exit+0x58/0xb0) from [<c0021084>]
>> (asm_do_IRQ+0x84/0xa4)
>> [   68.100000] [<c0021084>] (asm_do_IRQ+0x84/0xa4) from [<c002622c>]
>> (__irq_svc+0x4c/0x98)
>> [   68.110000] Exception stack(0xc341fdc8 to 0xc341fe10)
>> [   68.110000] fdc0:                   c07e82c0 00000000 00000200
>> c4818000 c341fe10 c07e82c0
>> [   68.120000] fde0: 00000000 c07e82c0 c38d3318 c341e000 bebcee00
>> 010a0b60 c07e83fc c341fe10
>> [   68.130000] fe00: c0151d54 c023d9c0 60000013 ffffffff
>> [   68.140000] [<c002622c>] (__irq_svc+0x4c/0x98) from [<c023d9c0>]
>> (_raw_spin_unlock+0x0/0x48)
>> [   68.140000] [<c023d9c0>] (_raw_spin_unlock+0x0/0x48) from
>> [<00000000>] (  (null))
>>
>> The soft lockup occurs later
>>
>> [  126.750000] BUG: soft lockup - CPU#0 stuck for 61s! [dnp_master:244]
>> [  126.750000] irq event stamp: 0
>> [  126.750000] hardirqs last  enabled at (0): [<   (null)>]   (null)
>> [  126.750000] hardirqs last disabled at (0): [<c0035e30>]
>> copy_process+0x308/0xe78
>> [  126.750000] softirqs last  enabled at (0): [<c0035e30>]
>> copy_process+0x308/0xe78
>> [  126.750000] softirqs last disabled at (0): [<   (null)>]   (null)
>>
>>
>> The following patch (already tested by Dave, who also reported the bug)
>> fixes the problem.
>>
>> Regards,
>>
>>      Claudio
>>
>>
>>
>>
>> Subject: atmel_serial: fix spinlock lockup in RS485 code
>>
>> Patch to fix a spinlock lockup in the driver that sometimes happens when
>> the
>> tasklet starts.
>>
>> Signed-off-by: Claudio Scordino<claudio@evidence.eu.com>
>> Signed-off-by: Dave Bender<codehero@gmail.com>
>> Tested-by: Dave Bender<codehero@gmail.com>
>
> Acked-by: Nicolas Ferre<nicolas.ferre@atmel.com>
>
> Claudio, can you please send the patch to Alan with my "Acked-by" and an
> addition to Linux stable just after the signature lines:
>
> Cc: stable<stable@kernel.org>

Dear Alan,

	here is the patch with all the acked-bys.

Many thanks,

	Claudio


Subject: atmel_serial: fix spinlock lockup in RS485 code

Patch to fix a spinlock lockup in the driver that sometimes happens when the
tasklet starts.

Signed-off-by: Claudio Scordino <claudio@evidence.eu.com>
Signed-off-by: Dave Bender <codehero@gmail.com>
Tested-by: Dave Bender <codehero@gmail.com>
Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
Acked-by: Alan Cox <alan@linux.intel.com>
Cc: stable <stable@kernel.org>
---
  drivers/tty/serial/atmel_serial.c |    5 +++--
  1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/tty/serial/atmel_serial.c b/drivers/tty/serial/atmel_serial.c
index 4c823f3..90c8e3a 100644
--- a/drivers/tty/serial/atmel_serial.c
+++ b/drivers/tty/serial/atmel_serial.c
@@ -212,8 +212,9 @@ void atmel_config_rs485(struct uart_port *port, struct serial_rs485 *rs485conf)
  {
  	struct atmel_uart_port *atmel_port = to_atmel_uart_port(port);
  	unsigned int mode;
+	unsigned long flags;
  
-	spin_lock(&port->lock);
+	spin_lock_irqsave(&port->lock, flags);
  
  	/* Disable interrupts */
  	UART_PUT_IDR(port, atmel_port->tx_done_mask);
@@ -244,7 +245,7 @@ void atmel_config_rs485(struct uart_port *port, struct serial_rs485 *rs485conf)
  	/* Enable interrupts */
  	UART_PUT_IER(port, atmel_port->tx_done_mask);
  
-	spin_unlock(&port->lock);
+	spin_unlock_irqrestore(&port->lock, flags);
  
  }
  
-- 
1.7.1

