Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751151Ab2KOXIs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 18:08:48 -0500
Received: from mail.wdtv.com ([66.118.69.84]:52315 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750874Ab2KOXIr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 18:08:47 -0500
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Thu, 15 Nov 2012 18:08:46 EST
From: Gene Heskett <gheskett@wdtv.com>
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Subject: Re: [PATCH] x86, microcode, AMD: Add support for family 16h processors
Date: Thu, 15 Nov 2012 18:01:22 -0500
Cc: Boris Ostrovsky <boris.ostrovsky@amd.com>, hpa@zytor.com, mingo@elte.hu,
        tglx@linutronix.de, herrmann.der.user@googlemail.com, bp@alien8.de,
        linux-kernel@vger.kernel.org
References: <1353004910-2204-1-git-send-email-boris.ostrovsky@amd.com> <20121115204503.GB18032@khazad-dum.debian.net>
In-Reply-To: <20121115204503.GB18032@khazad-dum.debian.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 7bit
Message-Id: <201211151801.23160.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 15 November 2012, Henrique de Moraes Holschuh wrote:
>On Thu, 15 Nov 2012, Boris Ostrovsky wrote:
>> Add valid patch size for family 16h processors
>> 
>> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@amd.com>
>
>Is this something that needs to go to -stable ?

IMO, and if I had an oar in this water, yes.  Its been missing since the 
Intel folks started playing with it a couple years back up the log.  I 
have the amd_ucode files in my /lib/firmware tree,

root@coyote:/opt/os9# ls -l /lib/firmware/amd-ucode/
total 76
-rw-r--r-- 1 root root   642 2012-01-17 11:50 INSTALL
-rw-r--r-- 1 root root  9987 2012-01-17 11:50 LICENSE
-rw-r--r-- 1 root root 12404 2012-01-17 11:50 microcode_amd.bin
-rw-r--r-- 1 root root  1526 2012-01-17 11:50 microcode_amd.bin.README
-rw-r--r-- 1 root root  2644 2012-01-17 11:50 microcode_amd_fam15h.bin
-rw-r--r-- 1 root root   510 2012-01-17 11:50 
microcode_amd_fam15h.bin.README
-rw-r--r-- 1 root root  2012 2009-01-20 04:48 microcode_amd.phenom-V83
-rw-r--r-- 1 root root 15020 2012-01-17 11:50 microcode_amd_solaris.bin
-rw-r--r-- 1 root root  1685 2012-01-17 11:50 
microcode_amd_solaris.bin.README
-rw-r--r-- 1 root root  6227 2012-01-17 11:50 README

but I can't recall the last time I saw the code sign in during dmesg.
Old, slow 4 core phenom here.  AMD was forgotten about when the loading 
of it was moved from the kernel options to /etc/init.d/microcode.  For 
an AMD user, that was not a show stopper, but it wasn't a Good Thing(TM) 
either.

>
>>  #define F1XH_MPB_MAX_SIZE 2048
>>  #define F14H_MPB_MAX_SIZE 1824
>>  #define F15H_MPB_MAX_SIZE 4096
>> 
>> +#define F16H_MPB_MAX_SIZE 3458
>> 
>>  	switch (c->x86) {
>> 
>>  	case 0x14:
>> @@ -198,6 +199,9 @@ static unsigned int verify_patch_size(int cpu, u32
>> patch_size,
>> 
>>  	case 0x15:
>>  		max_size = F15H_MPB_MAX_SIZE;
>>  		break;
>> 
>> +	case 0x16:
>> +		max_size = F16H_MPB_MAX_SIZE;
>> +		break;
>> 
>>  	default:
>>  		max_size = F1XH_MPB_MAX_SIZE;
>>  		break;
>
>Because it looks like without this patch, some valid microcode updates
>would be rejected by the kernel...


Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
My web page: <http://coyoteden.dyndns-free.com:85/gene> is up!
Some people's mouths work faster than their brains.  They say things they
haven't even thought of yet.
