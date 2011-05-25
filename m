Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757839Ab1EYOEi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 May 2011 10:04:38 -0400
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:47340 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757001Ab1EYOEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 May 2011 10:04:37 -0400
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Message-ID: <4DDD0D25.8010102@cam.ac.uk>
Date: Wed, 25 May 2011 15:07:33 +0100
From: Jonathan Cameron <jic23@cam.ac.uk>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110509 Lightning/1.0b3pre Thunderbird/3.1.10
MIME-Version: 1.0
To: Anatolij Gustschin <agust@denx.de>
CC: linux-kernel@vger.kernel.org, akpm@linux-foundation.org, dzu@denx.de
Subject: Re: [PATCH 1/2] misc/eeprom: add driver for 93xx46 EEPROMs over GPIO
References: <1306252963-20746-1-git-send-email-agust@denx.de>	<4DDCCC82.90604@cam.ac.uk> <20110525153527.2811487d@wker>
In-Reply-To: <20110525153527.2811487d@wker>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/25/11 14:35, Anatolij Gustschin wrote:
> On Wed, 25 May 2011 10:31:46 +0100
> Jonathan Cameron <jic23@cam.ac.uk> wrote:
> 
>> On 05/24/11 17:02, Anatolij Gustschin wrote:
>>> 93xx46 EEPROMs can be connected using GPIO lines. Add a generic
>>> 93xx46 EEPROM driver using common GPIO API for such configurations.
>>> A platform is supposed to register appropriate 93xx46 gpio device
>>> providing GPIO interface description and using this driver
>>> read/write/erase access to the EEPROM chip can be easily done
>>> over sysfs files.
>> Could you explain why this makes more sense than an spi driver and
>> use of spi_gpio ?
>>
>> It's microwire compatible according to random google provided datasheet,
>> which iirc is a particular form of spi (half duplex, spi mode 0 according
>> to wikipedia)
>>
>> That would give us a more generally useful driver.
> 
> I thought about using spi_gpio first, then I decided to
> do it in an independent driver since on the hardware the
> driver was written for we additionally need to control
> logic to hold pixel link chips in reset when eeprom access
> is performed. Putting appropriate hacks to spi_gpio driver 
> didn't seem to be right approach. Controlling this logic
> from user space is error-prone, too.
Why would you need to put hacks in the spi bus driver?

Surely they would still be in your eeprom driver.
Basically hold the pin down - do spi transfer - raise it again

Might need some callbacks to platform data (From the eeprom driver)
to deal with this case...
