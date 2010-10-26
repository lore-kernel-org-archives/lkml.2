Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755331Ab0JZIzf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Oct 2010 04:55:35 -0400
Received: from relay01-haj2.antispameurope.com ([83.246.65.51]:58009 "EHLO
	relay01-haj2.antispameurope.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752092Ab0JZIzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Oct 2010 04:55:32 -0400
Message-ID: <4CC6977C.1020908@iis.fraunhofer.de>
Date: Tue, 26 Oct 2010 10:55:24 +0200
From: Manuel Stahl <manuel.stahl@iis.fraunhofer.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.11) Gecko/20101013 Lightning/1.0b2 Thunderbird/3.1.5
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: linux-serial@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH resend] Add sc16is7x2 driver
References: <4CAD818B.2070603@iis.fraunhofer.de> <20101014190133.GB1009@kroah.com> <4CB801B2.808@iis.fraunhofer.de> <20101015142709.GA18905@kroah.com> <4CB86E8F.3060907@iis.fraunhofer.de> <20101015164922.GB21576@kroah.com> <4CBC177E.8020407@iis.fraunhofer.de> <20101019153748.GB4589@kroah.com>
In-Reply-To: <20101019153748.GB4589@kroah.com>
Content-Type: multipart/mixed;
 boundary="------------010905090505080100050504"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------010905090505080100050504
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
X-MIME-Autoconverted: from 8bit to quoted-printable by iis.fhg.de id KAA09444

On 19.10.2010 17:37, Greg KH wrote:
> On Mon, Oct 18, 2010 at 11:46:38AM +0200, Manuel Stahl wrote:
>> On 15.10.2010 18:49, Greg KH wrote:
>>> On Fri, Oct 15, 2010 at 05:09:03PM +0200, Manuel Stahl wrote:
>>>> On 15.10.2010 16:27, Greg KH wrote:
>>>>> On Fri, Oct 15, 2010 at 09:24:34AM +0200, Manuel Stahl wrote:
>>>>>> On 14.10.2010 21:01, Greg KH wrote:
>>>>>>> On Thu, Oct 07, 2010 at 10:15:07AM +0200, Manuel Stahl wrote:
>>>>>>>> --- /dev/null
>>>>>>>> +++ b/include/linux/spi/sc16is7x2.h
>>>>>>>> @@ -0,0 +1,17 @@
>>>>>>>> +#ifndef LINUX_SPI_SC16IS752_H
>>>>>>>> +#define LINUX_SPI_SC16IS752_H
>>>>>>>> +
>>>>>>>> +#define SC16IS7X2_NR_GPIOS 8
>>>>>>>> +
>>>>>>>> +struct sc16is7x2_platform_data {
>>>>>>>> +	unsigned int	uartclk;
>>>>>>>> +	/* uart line number of the first channel */
>>>>>>>> +	unsigned	uart_base;
>>>>>>>> +	/* number assigned to the first GPIO */
>>>>>>>> +	unsigned	gpio_base;
>>>>>>>> +	char		*label;
>>>>>>>> +	/* list of GPIO names (array length =3D SC16IS7X2_NR_GPIOS) */
>>>>>>>> +	const char	*const *names;
>>>>>>>> +};
>>>>>>>> +
>>>>>>>> +#endif
>>>>>>>
>>>>>>> Why is this needed in a .h file?  What other .c file uses this de=
fine
>>>>>>> and structure?
>>>>>>>
>>>>>>> thanks,
>>>>>>>
>>>>>>> greg k-h
>>>>>>
>>>>>> The board setup code can pass information about the uart and gpio
>>>>>> enumeration.
>>>>>
>>>>> What "board setup code"?  I don't see that here in the patch anywhe=
re.
>>>>
>>>> SPI devices are generally set up for a specific hardware board. I.e.=
 for
>>>> some ARM boards there is setup code in
>>>> linux/arch/arm/mach-at91/board-<xyz>.c
>>>>
>>>> I use the sc16is7x2 for a board that is not yet in vanilla, so the b=
oard
>>>> setup code is not included in the patch.
>>>
>>> Then why not add this header (or move it to the header file) when you=
r
>>> board setup code is merged?  No need to have it there now, right?
>>
>> Cause everyone who want's to use this driver for his board needs the
>> header. The board I use is a prototype, nearly the same as some
>> Atmel Demo board, but with the sc16is752 attached to the SPI port.
>> Therefore I don't see any benefit in publishing my board setup code.
>
> How nice, you are saying that we need a .h file in the kernel for no
> other reason than to support out-of-tree code?  Well, feel free to
> resend this driver, and watch as the .h file is removed as it's not
> needed by any in-tree code...

OK, let's take an example: max3100
This is the driver I took as a template. It consists of=20
drivers/serial/max3100.c and include/linux/serial_max3100.h

And huh, "grep -R serial_max3100.h *" gives what? Only max3100.c
So do we need to remove serial_max3100.h as it's not used anywhere else?

Regards,
--=20
Manuel Stahl
Fraunhofer-Institut IIS
Leistungsoptimierte Systeme

Nordostpark 93
D90411 N=FCrnberg
Telefon  +49 (0)911/58061-6419
Fax      +49 (0)911/58061-6398
E-Mail   manuel.stahl@iis.fraunhofer.de

http://www.iis.fraunhofer.de
http://www.smart-power.fraunhofer.de

--------------010905090505080100050504
Content-Type: text/x-vcard; charset=utf-8;
 name="manuel_stahl.vcf"
Content-Disposition: attachment;
 filename="manuel_stahl.vcf"
Content-Transfer-Encoding: quoted-printable

begin:vcard
fn:Manuel Stahl
n:Stahl;Manuel
email;internet:manuel.stahl@iis.fraunhofer.de
tel;work:+49 911 58061-6419
x-mozilla-html:FALSE
version:2.1
end:vcard


--------------010905090505080100050504--
