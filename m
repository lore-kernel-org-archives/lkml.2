Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753759Ab0GFAAH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Jul 2010 20:00:07 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:55521 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751551Ab0GFAAC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Jul 2010 20:00:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=tyU6XBMx+wc80uwrTADTfdrPpdhdQ2JF4y4/2eUsEVX35Q9QPevH/cw1zN4yVaG7Kg
         CUo1ah+VnG13SzlFQRdYIfKaXCjlX/RaFSaNLu9TIbflM7f6b/dXuf0CJpybEYLHXnnr
         ZgwYwPJLV4nUUB8y7hn0cT4WgIdamv+/k27/I=
Message-ID: <4C3271FF.9080308@gmail.com>
Date: Mon, 05 Jul 2010 17:59:59 -0600
From: Robert Hancock <hancockrwd@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.4) Gecko/20100624 Fedora/3.1-1.fc13 Thunderbird/3.1
MIME-Version: 1.0
To: Mark Knecht <markknecht@gmail.com>
CC: Tejun Heo <tj@kernel.org>, Stan Hoeppner <stan@hardwarefreak.com>,
       Linux Kernel List <linux-kernel@vger.kernel.org>,
       "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
Subject: Re: Drives missing at boot
References: <AANLkTimVkG9TFgyOTTnrztBjqT4JoOzFaP268vWLAAm9@mail.gmail.com>	<4C2F5ECB.1040505@kernel.org>	<AANLkTinBn35687znO2_IxI3s1opkXrG2HpCRgsejNbMq@mail.gmail.com>	<4C2F87C1.8000701@hardwarefreak.com>	<AANLkTimVJEO-yF3GZ2ghX6DNPuAu-A-MNNO9x8Q1EpRc@mail.gmail.com>	<4C2F9292.708@hardwarefreak.com>	<AANLkTikPsRvvpSZirSygnZqyGKcS-Bz0eVeASZZqvZwH@mail.gmail.com>	<AANLkTintf2mwgBVuk_4GmfHTzyJebP2kyfcNGij_epy-@mail.gmail.com>	<4C31796C.8050209@kernel.org> <AANLkTinvNGha7SfaAWYIjUJwR9ZelCbHAWK0qvvllF9S@mail.gmail.com>
In-Reply-To: <AANLkTinvNGha7SfaAWYIjUJwR9ZelCbHAWK0qvvllF9S@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2010 10:48 AM, Mark Knecht wrote:
> On Sun, Jul 4, 2010 at 11:19 PM, Tejun Heo<tj@kernel.org>  wrote:
>> Hello,
>>
>> On 07/04/2010 12:31 AM, Mark Knecht wrote:
>>> OK, I don't know if this is related but so far I cannot get the
>>> machine to boot if I set BIOS SATA configuration to AHCI. I believe
>>> that I have AHCI support as well as SATA support built into the kernel
>>> but when I set the BIOS to AHCI the machine just hangs saying it finds
>>> no medium. I assume that means no hard drive. I have to set SATA
>>> support to enhanced and then IDE to get the machine to boot at all.
>>
>> That's odd.  Can you please attach kernel boot log w/ ahci mode?
>> Booting a recent live CD and saving boot log from there should do the
>> trick.
>>
>> Thanks.
>>
>> --
>> tejun
>>
>
> Hi Tehun,
>     Thanks for the help.
>
>     I tried a Gentoo install CD from last march. It's a 2.6.31 type
> kernel. Problem is the buffer depths are not big enough to capture the
> complete dmesg contents and I don't know a command line option to make
> it larger on the fly. If you know of one that's got a larger buffer -
> or a command to increase it at boot time - then let me know and I'll
> try again.
>
>     I'm attaching what I was able to catch for both AHCI and IDE
> settings in BIOS for the storage configuration option.
>
>     It seems to me that even in AHCI mode the machine does see all the
> hard drives. Maybe there's something about my boot partition that's
> having problems in AHCI mode only? If it sees /dev/sda then why
> wouldn't it find grub and at least show a grub menu?

On some machines changing from IDE to AHCI messes up the boot order 
selection in the BIOS - you may have to switch to AHCI, save settings, 
reboot, go back into the BIOS and then make sure the disk boot order 
settings are correct (whatever drive grub is installed on needs to be 
first).
