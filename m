Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937349Ab0CPBa6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 21:30:58 -0400
Received: from www.wytron.com.tw ([211.75.82.101]:41201 "EHLO
	www.wytron.com.tw" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937335Ab0CPBaz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 21:30:55 -0400
X-Greylist: delayed 2761 seconds by postgrey-1.27 at vger.kernel.org; Mon, 15 Mar 2010 21:30:54 EDT
Message-ID: <4B9ED52F.6050407@wytron.com.tw>
Date: Tue, 16 Mar 2010 08:47:43 +0800
From: Thomas Chou <thomas@wytron.com.tw>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: nios2-dev@sopc.et.ntust.edu.tw, Tobias Klauser <tklauser@distanz.ch>,
       gregkh@suse.de, linux-kernel@vger.kernel.org,
       linux-serial@vger.kernel.org
Subject: Re: [Nios2-dev] [PATCHv3 1/2] serial: Add driver for the Altera 
 JTAG UART
References: <cover.1267807169.git.klto@zhaw.ch>	<15dc056891fb785001073bab4f9a0d0f3bf99af1.1267807169.git.klto@zhaw.ch> <20100312124835.724eb806.akpm@linux-foundation.org>
In-Reply-To: <20100312124835.724eb806.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 192.168.1.18
X-SA-Exim-Mail-From: thomas@wytron.com.tw
X-SA-Exim-Scanned: No (on www.wytron.com.tw); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/13/2010 04:48 AM, Andrew Morton wrote:
>> +config SERIAL_ALTERA_JTAGUART
>> +	bool "Altera JTAG UART support"
>> +	select SERIAL_CORE
>> +	help
>> +	  This driver supports the Altera JTAG UART port.
>> +
> So this driver will be available on all CPU architectures.
>
> I'm guessing that the hardware _isn't_ available on all CPU
> architectures?  Maybe that's wrong.
>
>    
It is true that this driver is used mostly with nios2, soft-core 
coldfire and arm. But peripherals on FPGA can be made available to 
almost any CPU architecture. So I think it might make sense to let it 
available to all. Or should we put a "default n" ?

>> +#include<linux/platform_device.h>
>> +#include<linux/io.h>
>> +#include<linux/altera_jtaguart.h>
>>      
>
> Does it make sense to put altera_jtaguart.h into include/linux?  Could
> we put it in drivers/serial/?
>
>
>    
There is only a platform data structure declaration in the header, which 
should be passed through platform device data to the driver. If we put 
it in drivers/serial/, then we will need to include 
"../../../drivers/serial/altera_jtaguart.h" .

I have written this driver in parallel with the altera_uart driver. We 
could have passed the data ( base, irq, freq ) using platform resources. 
But I don't know if there is a way to pass ( freq )? Please let me know 
if you have any suggestions.

- Thomas
