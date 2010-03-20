Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752015Ab0CTUIa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 16:08:30 -0400
Received: from authsmtp-0-5.virt.iitsp.net ([66.197.170.103]:39678 "EHLO
	authsmtp-0-5.virt.iitsp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750808Ab0CTUI3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 16:08:29 -0400
Message-ID: <4BA52B6F.2060402@lbsd.net>
Date: Sat, 20 Mar 2010 20:09:19 +0000
From: Nigel Kukard <nkukard@lbsd.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091201 IceDove/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [BUG] kernel 2.6.33-rc4 OOPS's with large initramfs
References: <4B519F14.7020104@lbsd.net> <4B5CD711.7050204@zytor.com> <4BA51022.4010309@lbsd.net> <4BA51A48.6010509@zytor.com>
In-Reply-To: <4BA51A48.6010509@zytor.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>>>> Generating a initramfs with the following, one of about 30Mb, one of 77Mb.
>>>> find . | cpio -o -H newc > ../initramfs.cpio
>>>>
>>>> Only difference is adding of more files to the 77Mb image.
>>>>
>>>> It makes no difference if its compiled into kernel or used as initrd.
>>>> Compression types makes no difference either.
>>>>
>>>> Tested on 2.6.32.3->2.6.33-rc4 , all fail with the below.
>>>>
>>>> The 30Mb initramfs loads fine, the 77Mb image throws the following...
>>>>
>>>>     
>>>>         
>>> What are the exact compressed and uncompressed files (or is that an
>>> uncompressed initramfs)?
>>>   
>>>       
>> Ok ... I revisited this, sorry for the delay, all tests done on kernel
>> 2.6.33.1
>>
>> (initramfs uploaded, link below)
>>
>> It is generated using two commands...
>> find . | cpio -o --quiet -H newc -A -O ../initramfs.cpio
>>
>> and the kernel modules are appended to this using...
>> find . | cpio -o --quiet -H newc -A -O ../initramfs.cpio
>>
>> The exact size is ..
>> % ls -la initramfs.cpio
>> -rw-r--r-- 1 nkukard nkukard 115944448 Mar 19 22:15 initramfs.cpio
>>
>>     
> How much RAM are you giving your VM?  The default for Qemu is 128 MB,
> and if you have a 110 MB initramfs it's hardly surprising that you get
> an out of memory error.

The kernel now boots where it booted for my 64bit box.

The main problem though is the instant reboots for bzip2 and lzma
compressed initramfs images. The change for printf to /usr/bin/printf
both render the sane end result when run with the same commandline being
run in the makefile, so this isn't the issue.

-N
