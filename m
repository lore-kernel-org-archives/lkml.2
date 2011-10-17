Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab1JQMbX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 08:31:23 -0400
Received: from ppsw-41.csi.cam.ac.uk ([131.111.8.141]:57377 "EHLO
	ppsw-41.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415Ab1JQMbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 08:31:22 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4E9C201D.30905@cam.ac.uk>
Date: Mon, 17 Oct 2011 13:31:25 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20111003 Thunderbird/7.0.1
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Linus Walleij <linus.ml.walleij@gmail.com>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, zdevai@gmail.com
Subject: Re: [PATCH] staging:iio:proof of concept in kernel interface.
References: <20111013204410.GA17160@sirena.org.uk> <4E985C60.9020308@cam.ac.uk> <CAKnu2MrUkY2upFh5d6GGTNUr-=r_JKcxh5OQNV63bdOCa4F+zg@mail.gmail.com> <4E9BF8D9.8030301@cam.ac.uk> <20111017101959.GC3042@opensource.wolfsonmicro.com> <4E9C0423.5010909@cam.ac.uk> <20111017104642.GD3042@opensource.wolfsonmicro.com> <4E9C0DD7.7080105@cam.ac.uk> <20111017111807.GA27266@opensource.wolfsonmicro.com> <4E9C1249.5020408@cam.ac.uk> <20111017120813.GB27266@opensource.wolfsonmicro.com>
In-Reply-To: <20111017120813.GB27266@opensource.wolfsonmicro.com>
X-Enigmail-Version: 1.4a1pre
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/11 13:08, Mark Brown wrote:
> On Mon, Oct 17, 2011 at 12:32:25PM +0100, Jonathan Cameron wrote:
>> On 10/17/11 12:18, Mark Brown wrote:
> 
>>>  - Some voltage inputs hard wired to particular system supplies.
> 
>> Hard wired in the pmic?  (e.g. do not vary from device to device).
>> These I'm happy to see have names.  If it were a normal IIO device their
>> access attributes would be something like:
> 
>> in_voltage0_supply3V_raw
>> in_voltage1_supply2.8V_raw
> 
> Yes, though the names are more symbolic than that (eg, "USB").
> 
>> (have insist on indexing even with named channels because it is needed as
>> events codes don't want to carry a string.).
> 
> This is orthogonal to the request interface, though.
No it isn't - because it will effect the numbering of the gneral purpose ones.
> 
>>>  - One or more temperature inputs wired to particular place (eg, chip
>>>    and battery).
> 
>> Not hard wired so to my mind these are just general purpose temperature inputs.
>> Hence naming doesn't make sense (at least not outside of board file or DT).
> 
> No, they're hard wired - like I say they're wired to a particular place.
If it isn't physically in the pmic package then it doesn't belong in the driver.
> 
>> There are some complexities to deal with that make me wonder if direct indexing
>> into a driver provided table isn't easier.  The other is channel types.
> 
> It's not great for usability if you've got to apply an additional layer
> of translation on top of mapping the schematic onto the hardware.
Agreed.  Lets see how ti comes out.
> 
>> Is it so bad to insist that the dt writer or equivalent actually looks at the
>> driver in question and picks the underlying channel index directly?
> 
> We certainly can't put Linux specific channel numbers into the device
> tree.
Fine so numbering is based on Linux specific channel numbers based on the channel
type rather than a single index.  Thus as a minimum we need everything given
in my last proposed structure.

Note the numbering is still going to be Linux specific just within a given type
of channel. ADC channels regularly have completely inconsistent (and/or stupid) names
in device data sheets.

0...4
1...5
AUXA....AUXD
TEMP_EXT1...TEMP_EXT5 (all of which are just normal adc channels that some
designer decided would be used only for connecting analog temperature sensors.)

All of these get mapped to 0...4.  Anything else leads to totally unpredictable
guessing games when trying to find the channel.

Naming should be restricted for the rare case where it really really is physically
mounted in the same chip package and hence can never be used for anything else.
Sure if the adc has special features that mean it really is only useful for one
thing (like a resolver channel) then it is fine to mark it as a more specific type.

Jonathan

