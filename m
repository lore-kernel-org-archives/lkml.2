Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab0CTUWI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 16:22:08 -0400
Received: from authsmtp-0-5.virt.iitsp.net ([66.197.170.103]:55095 "EHLO
	authsmtp-0-5.virt.iitsp.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752230Ab0CTUWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 16:22:06 -0400
Message-ID: <4BA52E9F.2080005@lbsd.net>
Date: Sat, 20 Mar 2010 20:22:55 +0000
From: Nigel Kukard <nkukard@lbsd.net>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.5) Gecko/20091201 IceDove/3.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [BUG] kernel 2.6.33-rc4 OOPS's with large initramfs
References: <4B519F14.7020104@lbsd.net> <4B5CD711.7050204@zytor.com> <4BA51022.4010309@lbsd.net> <4BA51A48.6010509@zytor.com> <4BA52B6F.2060402@lbsd.net> <4BA52D01.1070506@zytor.com>
In-Reply-To: <4BA52D01.1070506@zytor.com>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


    

>>> How much RAM are you giving your VM?  The default for Qemu is 128 MB,
>>> and if you have a 110 MB initramfs it's hardly surprising that you get
>>> an out of memory error.
>>>       
>> The kernel now boots where it booted for my 64bit box.
>>
>> The main problem though is the instant reboots for bzip2 and lzma
>> compressed initramfs images. The change for printf to /usr/bin/printf
>> both render the sane end result when run with the same commandline being
>> run in the makefile, so this isn't the issue.
>>
>>     
> Oh, you have *that* problem.
>
> What printf is being used?

coreutils 8.4 and 7.5 and bash all give me the same result for the
commandline being run. This was just one of the things I tried and it
didn't fix the problem.

Here is what is run from the buildlog...
  (cat arch/x86/boot/compressed/vmlinux.bin | lzma -9 && printf
\\150\\111\\241\\007) > arch/x86/boot/compressed/vmlinux.bin.lzma || (rm
-f arch/x86/boot/compressed/vmlinux.bin.lzma ; false)

I tested printf out...
# printf \\150\\111\\241\\007 | xxd
0000000: 6849 a107                                hI..

coreutils 7.5
# /usr/bin/printf \\150\\111\\241\\007 | xxd
0000000: 6849 a107                                hI..

coreutils 8.4
# /usr/bin/printf \\150\\111\\241\\007 | xxd
0000000: 6849 a107                                hI..


That confirms it? its not the b0rked printf issue afaics :)

-N


