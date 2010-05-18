Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754806Ab0ERATR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 20:19:17 -0400
Received: from p01c12o147.mxlogic.net ([208.65.145.70]:57124 "EHLO
	p01c12o147.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752559Ab0ERATQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 20:19:16 -0400
X-MXL-Hash: 4bf1dd042d41a738-b0ac1a862432c9007ff7323b56f70c0a4f7097e7
X-MXL-Hash: 4bf1dcf536e15f89-b639b68b4840240860f1a87aa9561706b32beaf4
From: H Hartley Sweeten <hartleys@visionengravers.com>
To: Mike Frysinger <vapier.adi@gmail.com>, Oskar Schirmer <os@emlix.com>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       =?utf-8?B?RGFuaWVsIEdsw7Zja25lcg==?= <dg@emlix.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Oliver Schneidewind <osw@emlix.com>,
       Michael Hennerich <michael.hennerich@analog.com>
Date: Mon, 17 May 2010 19:18:28 -0500
Subject: RE: [PATCH] ad7877: fix spi word size to 16 bit
Thread-Topic: [PATCH] ad7877: fix spi word size to 16 bit
Thread-Index: Acr2G7Nsy0RSdnHBQFqMSyH2ZEz7YQAAP5ng
Message-ID: <0D753D10438DA54287A00B0270842697636F0E1458@AUSP01VMBX24.collaborationhost.net>
References: <1273142265-11929-1-git-send-email-os@emlix.com>
 	<n2j8bd0f97a1005061126h7fecc32btad9986c0e38246f2@mail.gmail.com>
 	<4BE3E02E.1090500@emlix.com>
 <h2l8bd0f97a1005071123u782bab2doee5c122dbd4c8642@mail.gmail.com>
 	<20100513075335.GD30110@core.coreip.homeip.net>
 <20100515181523.GA3081@emlix.com>
 	<AANLkTinn6VgvujPP3gGsteBGckIFgljn7B35DV6n8kwL@mail.gmail.com>
 	<20100517072935.GA14891@emlix.com>
 <AANLkTimeAn9ALs4KxBNwwk-B419OwZ0BUwoKcoEfUbGw@mail.gmail.com>
In-Reply-To: <AANLkTimeAn9ALs4KxBNwwk-B419OwZ0BUwoKcoEfUbGw@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-Spam: [F=0.2288846189; CM=0.500; S=0.228(2010050402)]
X-MAIL-FROM: <hartleys@visionengravers.com>
X-SOURCE-IP: [216.166.12.72]
X-AnalysisOut: [v=1.0 c=1 a=B-1wmBd5vvoA:10 a=0qYQvVkOOIcA:10 a=VphdPIyG4k]
X-AnalysisOut: [EA:10 a=IkcTkHD0fZMA:10 a=jM3uHZP82BWpxjlUuN2t4A==:17 a=XO]
X-AnalysisOut: [z3PDFBkUSvFmGLoiIA:9 a=gvVWoxAfJT6qqOMFW6gA:7 a=aCoytqtZQ8]
X-AnalysisOut: [7wkN_FXNdVubITrQIA:4 a=QEXdDO2ut3YA:10 a=9X4zYPs0J0jg8jLU:]
X-AnalysisOut: [21 a=RvHC5ijErnWmIA_U:21 a=rMIKJmVGj0KuOKtO:21]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by alpha.home.local id o4I0JRaS024778

On Monday, May 17, 2010 4:50 PM, Mike Frysinger wrote:
> 2010/5/17 Oskar Schirmer:
>> On Sun, May 16, 2010 at 15:25:34 -0400, Mike Frysinger wrote:
>>> On Sat, May 15, 2010 at 14:15, Oskar Schirmer wrote:
>>>> On Thu, May 13, 2010 at 00:53:35 -0700, Dmitry Torokhov wrote:
>>>>> On Fri, May 07, 2010 at 02:23:07PM -0400, Mike Frysinger wrote:
>>>>>> On Fri, May 7, 2010 at 05:41, Daniel GlÃ¶ckner wrote:
>>>>>>> On 05/06/2010 08:26 PM, Mike Frysinger wrote:
>>>>>>>> i think it'd be a better idea to do something like:
>>>>>>>> Â  if (spi->bits_per_word != 16) {
>>>>>>>> Â  Â  if (spi->bits_per_word) {
>>>>>>>> Â  Â  Â  dev_err(&spi->dev, "Invalid SPI settings; bits_per_word must be 16\n");
>>>>>>>> Â  Â  Â  return -EINVAL;
>>>>>>>> Â  Â  }
>>>>>>>> Â  Â  spi->bits_per_word = 16;
>>>>>>>> Â  Â  spi_setup(spi);
>>>>>>>> Â  }
>>>>>>>
>>>>>>> There is no way to set bits_per_word using struct spi_board_info. The
>>>>>>> description of that structure in spi.h explicitly lists the wordsize as
>>>>>>> one of the parameters drivers should set themself in probe().
>>>>>> >
>>>>>>> Only struct bfin5xx_spi_chip allows to set this value in the board code.
>>>>>>
>>>>>> an obvious shortcoming in the SPI framework that should be fixed, but
>>>>>> that doesnt make any difference to the above code now does it ? Â it'll
>>>>>> operate correctly regardless of the SPI bus master.
>>>>>
>>>>> So is the updated patch coming?
>>>>
>>>> The basic question I see is, whether it is in the
>>>> responsibility of ad7877 to check a wrong setting
>>>> possibly caused in board specific code. If so,
>>>> then the proposal by Mike should be used, but if not
>>>> so, it would introduce unneeded code.
>>>>
>>>> Remember: both versions end up in correctly setting
>>>> bits_per_word, with the difference merely in feedback
>>>> level.
>>>
>>> imo, unsupported board settings should always be detected & rejected.
>>> all SPI master drivers do this (detect & reject unsupported SPI slave
>>> settings).
>>
>> please note, that bits_per_word is not a board setting,
>> it's a demand of the device. consequently, there is no one
>> to set unsupported values and thus none to be detected.
>>
>> the only architecture setting bits_per_word thru spi_chip
>> is blackfin, but I cannot see a good reason, why the board
>> settings should engage with a fixed demand of the device?
>
> you're telling me that every single SPI device out there can only ever
> operate in one specific bit length or lacks optional settings ?  i
> find that hard to believe which means it does make sense to let the
> boards pick a length when appropriate.
>
> the board settings also function as default setup values so when using
> generic things like the spidev driver, there is no kernel driver to
> request the desired bitmode.
>
> the simple code i posted addresses your concerns as well as reject
> invalid settings (wherever they may originate).  if you're not going
> to post an updated patch, i'll take the simple one Michael committed
> and post that.

Just my 0.02, I haven't been following this thread very closely...

I believe it's the spi "device", i.e. the protocol, drivers responsibility
to supply the bits_per_word that it will operate with.  The spi master
driver simply validates it if can support the requested size.  If the
bits_per_word is left at the default (0) it indicates that the protocol
words are eight bit bytes.

If a protocol driver can support multiple word sizes it should probably
also support a "setup" callback during the driver probe so that the
underlying board support can provide the desired word size.  This is what
the libertas_spi driver does (drivers/net/wireless/libertas/if_spi.c).
That driver does nothing with the bits_per_word value but the callbacks in
arch/arm/mach-pxa/cm-x270.c and em-x270.c do.  They both set the bits_per_word
to 16 and then call spi_setup.  They also probably should be checking the
return value of spi_setup to make sure that the requested mode is supported
by the master driver, but they probably don't since it is already known...

If the ad7877 "only" supports 16-bit word sizes it should be setting the
bits_per_word to indicate this.  If the underlying master driver does not
support that word size it will return an error when spi_setup is called.

Just my 0.02... 

Regards,
Hartley
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
