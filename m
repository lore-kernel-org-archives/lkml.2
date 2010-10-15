Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932144Ab0JOQti (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 12:49:38 -0400
Received: from kroah.org ([198.145.64.141]:45036 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932107Ab0JOQtf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 12:49:35 -0400
Date: Fri, 15 Oct 2010 09:49:22 -0700
From: Greg KH <greg@kroah.com>
To: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
Cc: linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH resend] Add sc16is7x2 driver
Message-ID: <20101015164922.GB21576@kroah.com>
References: <4CAD818B.2070603@iis.fraunhofer.de> <20101014190133.GB1009@kroah.com> <4CB801B2.808@iis.fraunhofer.de> <20101015142709.GA18905@kroah.com> <4CB86E8F.3060907@iis.fraunhofer.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CB86E8F.3060907@iis.fraunhofer.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 15, 2010 at 05:09:03PM +0200, Manuel Stahl wrote:
> On 15.10.2010 16:27, Greg KH wrote:
>> On Fri, Oct 15, 2010 at 09:24:34AM +0200, Manuel Stahl wrote:
>>> On 14.10.2010 21:01, Greg KH wrote:
>>>> On Thu, Oct 07, 2010 at 10:15:07AM +0200, Manuel Stahl wrote:
>>>>> --- /dev/null
>>>>> +++ b/include/linux/spi/sc16is7x2.h
>>>>> @@ -0,0 +1,17 @@
>>>>> +#ifndef LINUX_SPI_SC16IS752_H
>>>>> +#define LINUX_SPI_SC16IS752_H
>>>>> +
>>>>> +#define SC16IS7X2_NR_GPIOS 8
>>>>> +
>>>>> +struct sc16is7x2_platform_data {
>>>>> +	unsigned int	uartclk;
>>>>> +	/* uart line number of the first channel */
>>>>> +	unsigned	uart_base;
>>>>> +	/* number assigned to the first GPIO */
>>>>> +	unsigned	gpio_base;
>>>>> +	char		*label;
>>>>> +	/* list of GPIO names (array length = SC16IS7X2_NR_GPIOS) */
>>>>> +	const char	*const *names;
>>>>> +};
>>>>> +
>>>>> +#endif
>>>>
>>>> Why is this needed in a .h file?  What other .c file uses this define
>>>> and structure?
>>>>
>>>> thanks,
>>>>
>>>> greg k-h
>>>
>>> The board setup code can pass information about the uart and gpio
>>> enumeration.
>>
>> What "board setup code"?  I don't see that here in the patch anywhere.
>
> SPI devices are generally set up for a specific hardware board. I.e. for 
> some ARM boards there is setup code in 
> linux/arch/arm/mach-at91/board-<xyz>.c
>
> I use the sc16is7x2 for a board that is not yet in vanilla, so the board 
> setup code is not included in the patch.

Then why not add this header (or move it to the header file) when your
board setup code is merged?  No need to have it there now, right?

Care to resend this driver changed that way?

thanks,

greg k-h
