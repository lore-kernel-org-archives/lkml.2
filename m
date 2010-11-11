Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755873Ab0KKL42 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 06:56:28 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46036 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753593Ab0KKL40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 06:56:26 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=JX6F0P41f9Hr3oSM0rQYGfOK6cE4ZmsXL0HyPp5PmkRDuHoiC+yeWRv3gYzD6XfJho
         KCzglYAtNk0kiLGwGodat4qoFD+0kubXvSmranCZ22QfQSuRNntgW02Vo1e0qSgAyyuY
         4QdK4QyRXcK8E4m/9da8GFDg9NgZbmzgD8f84=
Message-ID: <4CDBDD4A.9030702@gmail.com>
Date: Thu, 11 Nov 2010 04:10:50 -0800
From: Dirk Brandewie <dirk.brandewie@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101027 Fedora/3.1.6-1.fc13 Thunderbird/3.1.6
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: linux-kernel@vger.kernel.org, x86@kernel.org, dirk.brandewie@gmail.com
Subject: Re: [PATCH 4/6] ce4100: Add errata fixes for UART on CE4100
References: <cover.1289331834.git.dirk.brandewie@gmail.com> <395c11879580e72e3a47272ef8cf5e04fa334210.1289331834.git.dirk.brandewie@gmail.com> <alpine.LFD.2.00.1011111231430.2900@localhost6.localdomain6> <4CDBD91A.2010805@gmail.com> <alpine.LFD.2.00.1011111246200.2900@localhost6.localdomain6>
In-Reply-To: <alpine.LFD.2.00.1011111246200.2900@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/11/2010 03:47 AM, Thomas Gleixner wrote:
> On Thu, 11 Nov 2010, Dirk Brandewie wrote:
>
>> On 11/11/2010 03:34 AM, Thomas Gleixner wrote:
>>>
>>>
>>>> +	 * Over ride the legacy port configuration that comes from
>>>> +	 * asm/serial.h. Using the ioport driver then switching to the
>>>> +	 * PCI memmaped driver hangs the IOAPIC
>>>> +	 */
>>>> +	if (up->iotype !=  UPIO_MEM32) {
>>>> +		up->uartclk  = 14745600;
>>>> +		up->mapbase = 0xdffe0200;
>>>
>>>     What does the uartclk, mapbase fixups in the CONFIG_EARLY_PRINTK=n case ?
>>>
>> This is setup in the PCI driver patch #3 in the series
>
> I just can't find it there, that's why I'm asking :)
The weird clock is dealt with in:
+	[pbn_ce4100_1_115200] = {
+		.flags		= FL_BASE0,
+		.num_ports	= 1,
+		.base_baud	= 921600,
+		.reg_shift      = 2,
+	},

That map base is setup in the generic pci driver in setup_port(). I didn't need 
to do anything special.
--Dirk
>
> Thanks,
>
> 	tglx

