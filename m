Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab0F3Orj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jun 2010 10:47:39 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:63540 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754235Ab0F3Orh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jun 2010 10:47:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=P4fgbis/SOuwBsg8thzmcX+TPGTU5UonG2kzNU9GLX93Us+PeYL4YRmlDrKFMJKL15
         4uo3Jz0vHiKkMKBiuIjqU+XaLIowGbuUZQQO1jIjVPbVgVg+ztyVBv2QiNJA7+szEyAc
         Z94RfNibowB2cJZbAYIz15M0xyN86buNfndSs=
MIME-Version: 1.0
In-Reply-To: <20100630063844.GB27891@liondog.tnic>
References: <AANLkTingidlvRUaD4FwNDybaZ29Qrr_507Pto1vVqo-a@mail.gmail.com>
	<20100630063844.GB27891@liondog.tnic>
Date: Wed, 30 Jun 2010 08:47:36 -0600
Message-ID: <AANLkTinu1rzaHY4udBxVWRTCHB0XDicF5tz6FFnsUhfD@mail.gmail.com>
Subject: Re: 2.6.34 Northbridge Chipset Errors on HP Proliant 4 x Opteron in 
	x86_64 mode
From: Jeffrey Merkey <jeffmerkey@gmail.com>
To: Borislav Petkov <bp@alien8.de>, Jeffrey Merkey <jeffmerkey@gmail.com>,
       linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 30, 2010 at 12:38 AM, Borislav Petkov <bp@alien8.de> wrote:
> From: Jeffrey Merkey <jeffmerkey@gmail.com>
> Date: Tue, Jun 29, 2010 at 03:13:03PM -0600
>
>> On a 4 x Opteron HP Proliant Server with a CCISS array controller in
>> x86_64 mode, under very heavy (saturated) disk IO, 2.6.34 reports the
>> following error:
>>
>> Jun 29 02:02:08  kernel: Northbridge Error, node 0, core: 0
>> Jun 29 02:02:08  kernel: ECC/ChipKill ECC error.
>> Jun 29 02:02:08  kernel: EDAC amd64 MC0: CE ERROR_ADDRESS= 0xc7358280
>> Jun 29 02:02:08  kernel: EDAC amd64: get_channel_from_ecc_syndrome:
>> error reading F3x180.
>> Jun 29 02:02:08  kernel: EDAC MC0: CE page 0xc7358, offset 0x280,
>> grain 0, syndrome 0xa4c1, row 3, channel 0, label "": amd64_edac
>> Jun 29 02:03:21  kernel: Northbridge Error, node 0
>> Jun 29 02:03:21  kernel: ECC/ChipKill ECC error.
>> Jun 29 02:03:21  kernel: EDAC amd64 MC0: CE ERROR_ADDRESS= 0xc7358280
>> Jun 29 02:03:21  kernel: EDAC amd64: get_channel_from_ecc_syndrome:
>> error reading F3x180.
>
> It looks like you don't have extended PCI config space accesses enabled
> on that machine. Can you send me the whole dmesg?
>
>> Jun 29 02:03:21  kernel: EDAC MC0: CE page 0xc7358, offset 0x280,
>> grain 0, syndrome 0xa4c1, row 3, channel 0, label "": amd64_edac
>>
>> The error is reproduceable by subjecting the server to excessive disk
>> loads > 350 MB/S stream to disk.
>
> DRAM ECC errors. It looks most probably like the first DIMM on node 0,
> whichever that is, might be slowly failing.
>
> Pinpointing it is not that straightforward, here's what you can do:
>
> Try to figure which it is by looking at the silkscreen labels on the
> motherboard. They're normally named like "DIMM_Ax" where x is in (1,
> 2, ...) or "DIMM_Bx" or a similar scheme. If the layout on the mobo is
> sane, I'm guessing the first DIMM in that naming scheme should be it.
> Try swapping it out to see if the errors disappear.
>
> --
> Regards/Gruss,
>    Boris.
>

This makes sense.  I replaced the DIMM modules in this unit because
one of them had failed.  Looks like its twin
is slowly failing as well.  I have a spare and will replce today and
see if the error persists.

Thanks

Jeff
