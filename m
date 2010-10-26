Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757898Ab0JZOui (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 10:50:38 -0400
Received: from kroah.org ([198.145.64.141]:53038 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755116Ab0JZOuf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 10:50:35 -0400
Date: Tue, 26 Oct 2010 07:51:07 -0700
From: Greg KH <greg@kroah.com>
To: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
Cc: linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH resend] Add sc16is7x2 driver
Message-ID: <20101026145107.GA18531@kroah.com>
References: <4CAD818B.2070603@iis.fraunhofer.de> <20101014190133.GB1009@kroah.com> <4CB801B2.808@iis.fraunhofer.de> <20101015142709.GA18905@kroah.com> <4CB86E8F.3060907@iis.fraunhofer.de> <20101015164922.GB21576@kroah.com> <4CBC177E.8020407@iis.fraunhofer.de> <20101019153748.GB4589@kroah.com> <4CC6977C.1020908@iis.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC6977C.1020908@iis.fraunhofer.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 26, 2010 at 10:55:24AM +0200, Manuel Stahl wrote:
> On 19.10.2010 17:37, Greg KH wrote:
>> On Mon, Oct 18, 2010 at 11:46:38AM +0200, Manuel Stahl wrote:
>>> On 15.10.2010 18:49, Greg KH wrote:
>>>> On Fri, Oct 15, 2010 at 05:09:03PM +0200, Manuel Stahl wrote:
>>>>> On 15.10.2010 16:27, Greg KH wrote:
>>>>>> On Fri, Oct 15, 2010 at 09:24:34AM +0200, Manuel Stahl wrote:
>>>>>>> On 14.10.2010 21:01, Greg KH wrote:
>>>>>>>> On Thu, Oct 07, 2010 at 10:15:07AM +0200, Manuel Stahl wrote:
>>>>>>>>> --- /dev/null
>>>>>>>>> +++ b/include/linux/spi/sc16is7x2.h
>>>>>>>>> @@ -0,0 +1,17 @@
>>>>>>>>> +#ifndef LINUX_SPI_SC16IS752_H
>>>>>>>>> +#define LINUX_SPI_SC16IS752_H
>>>>>>>>> +
>>>>>>>>> +#define SC16IS7X2_NR_GPIOS 8
>>>>>>>>> +
>>>>>>>>> +struct sc16is7x2_platform_data {
>>>>>>>>> +	unsigned int	uartclk;
>>>>>>>>> +	/* uart line number of the first channel */
>>>>>>>>> +	unsigned	uart_base;
>>>>>>>>> +	/* number assigned to the first GPIO */
>>>>>>>>> +	unsigned	gpio_base;
>>>>>>>>> +	char		*label;
>>>>>>>>> +	/* list of GPIO names (array length = SC16IS7X2_NR_GPIOS) */
>>>>>>>>> +	const char	*const *names;
>>>>>>>>> +};
>>>>>>>>> +
>>>>>>>>> +#endif
>>>>>>>>
>>>>>>>> Why is this needed in a .h file?  What other .c file uses this define
>>>>>>>> and structure?
>>>>>>>>
>>>>>>>> thanks,
>>>>>>>>
>>>>>>>> greg k-h
>>>>>>>
>>>>>>> The board setup code can pass information about the uart and gpio
>>>>>>> enumeration.
>>>>>>
>>>>>> What "board setup code"?  I don't see that here in the patch anywhere.
>>>>>
>>>>> SPI devices are generally set up for a specific hardware board. I.e. for
>>>>> some ARM boards there is setup code in
>>>>> linux/arch/arm/mach-at91/board-<xyz>.c
>>>>>
>>>>> I use the sc16is7x2 for a board that is not yet in vanilla, so the board
>>>>> setup code is not included in the patch.
>>>>
>>>> Then why not add this header (or move it to the header file) when your
>>>> board setup code is merged?  No need to have it there now, right?
>>>
>>> Cause everyone who want's to use this driver for his board needs the
>>> header. The board I use is a prototype, nearly the same as some
>>> Atmel Demo board, but with the sc16is752 attached to the SPI port.
>>> Therefore I don't see any benefit in publishing my board setup code.
>>
>> How nice, you are saying that we need a .h file in the kernel for no
>> other reason than to support out-of-tree code?  Well, feel free to
>> resend this driver, and watch as the .h file is removed as it's not
>> needed by any in-tree code...
>
> OK, let's take an example: max3100
> This is the driver I took as a template. It consists of 
> drivers/serial/max3100.c and include/linux/serial_max3100.h
>
> And huh, "grep -R serial_max3100.h *" gives what? Only max3100.c
> So do we need to remove serial_max3100.h as it's not used anywhere else?

Yup, that sounds like a great idea, I'll go queue up that patch when I
get back from my travels at the moment.

thanks,

greg k-h
