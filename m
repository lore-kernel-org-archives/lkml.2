Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758026Ab0FBNcW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jun 2010 09:32:22 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:50988 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753891Ab0FBNcV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jun 2010 09:32:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=ArrfrmWIxZaNW+dP2U186QCoKcdtGANUH87oPK/aOX3BhUrh7hjapqsGNxW4H9lKUv
         b4WHFr6wCgOc2FW8y4QG8ECPikRXyT2H2DI6caEXXqWnpHVV9vRdFc/r5sMzmz88K6hf
         f5AVOOmlAhIxBiCf8vmGg59UXulLfk3xn331U=
Message-ID: <4C065D78.7080806@gmail.com>
Date: Wed, 02 Jun 2010 06:32:40 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.4pre) Gecko/20091114 Lightning/1.0pre Thunderbird/3.0b4
MIME-Version: 1.0
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
CC: Matthew Garrett <mjg59@srcf.ucam.org>, x86@kernel.org, tglx@linutronix.de,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH]X86:reboot.c Add some dmi entries to pci_reboot_dmi_table.
References: <20100601200704.GA16091@srcf.ucam.org>	<4C056AE6.3000409@gmail.com>	<20100601202130.GA16391@srcf.ucam.org>	<4C056E0C.2030709@gmail.com>	<20100601203351.GA16575@srcf.ucam.org>	<4C0572B4.6000201@gmail.com>	<20100601211219.GA17719@srcf.ucam.org>	<4C057AE9.9020307@gmail.com>	<20100601212901.GA18390@srcf.ucam.org>	<4C057EF0.2030808@gmail.com>	<20100601214820.GB18864@srcf.ucam.org> <20100602130827.12c28744@lxorguk.ukuu.org.uk>
In-Reply-To: <20100602130827.12c28744@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/02/2010 05:08 AM, Alan Cox wrote:
> On Tue, 1 Jun 2010 22:48:20 +0100
> Matthew Garrett<mjg59@srcf.ucam.org>  wrote:
>
>> On Tue, Jun 01, 2010 at 02:43:12PM -0700, Justin P. Mattock wrote:
>>> On 06/01/2010 02:29 PM, Matthew Garrett wrote:
>>>> So, just to be clear, you run this as root and it immediately returns
>>>> you to the prompt? This seems unlikely.
>>>
>>> yep.. with the above code
>>> I (save to a file) then
>>> non-root gcc reboot.c -o reboot
>>> then su
>>> ./reboot
>>> just bake to the command prompt
>>
>> Are you running some sort of security policy that might block hardware
>> access?
>
> 	Try
>
> 	if (iopl(...))
> 		perror
>
> ... (or strace it running as root)
>


o.k. here's the code with perror, and strace:


#include <sys/io.h>
#include <stdio.h>

int main() {
	iopl(3);
	outb(0xfe, 0x64);
	perror("something broke");
}

output in terminal:
something broke: Success


strace:

execve("./reboot", ["./reboot"], [/* 42 vars */]) = 0
brk(0)                                  = 0x601000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f0f50247000
access("/etc/ld.so.preload", R_OK)      = -1 ENOENT (No such file or 
directory)
open("/etc/ld.so.cache", O_RDONLY)      = 3
fstat(3, {st_mode=S_IFREG|0644, st_size=80596, ...}) = 0
mmap(NULL, 80596, PROT_READ, MAP_PRIVATE, 3, 0) = 0x7f0f50233000
close(3)                                = 0
open("/lib64/libc.so.6", O_RDONLY)      = 3
read(3, 
"\177ELF\2\1\1\3\0\0\0\0\0\0\0\0\3\0>\0\1\0\0\0p\355\241.;\0\0\0"...,
832) = 832
fstat(3, {st_mode=S_IFREG|0755, st_size=1838360, ...}) = 0
mmap(0x3b2ea00000, 3664040, PROT_READ|PROT_EXEC,
MAP_PRIVATE|MAP_DENYWRITE, 3, 0) = 0x3b2ea00000
mprotect(0x3b2eb75000, 2097152, PROT_NONE) = 0
mmap(0x3b2ed75000, 20480, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_DENYWRITE, 3, 0x175000) = 0x3b2ed75000
mmap(0x3b2ed7a000, 18600, PROT_READ|PROT_WRITE,
MAP_PRIVATE|MAP_FIXED|MAP_ANONYMOUS, -1, 0) = 0x3b2ed7a000
close(3)                                = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f0f50232000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f0f50231000
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f0f50230000
arch_prctl(ARCH_SET_FS, 0x7f0f50231700) = 0
mprotect(0x3b2ed75000, 16384, PROT_READ) = 0
mprotect(0x3b2e61e000, 4096, PROT_READ) = 0
munmap(0x7f0f50233000, 80596)           = 0
iopl(0x3)                               = 0
dup(2)                                  = 3
fcntl(3, F_GETFL)                       = 0x8002 (flags O_RDWR|O_LARGEFILE)
brk(0)                                  = 0x601000
brk(0x622000)                           = 0x622000
fstat(3, {st_mode=S_IFCHR|0620, st_rdev=makedev(136, 0), ...}) = 0
mmap(NULL, 4096, PROT_READ|PROT_WRITE, MAP_PRIVATE|MAP_ANONYMOUS, -1,
0) = 0x7f0f50246000
lseek(3, 0, SEEK_CUR)                   = -1 ESPIPE (Illegal seek)
write(3, "something broke: Success\n", 25something broke: Success
) = 25
close(3)                                = 0
munmap(0x7f0f50246000, 4096)            = 0
exit_group(0)                           = ?

what/where does one look for this keycode
if I may say?

Justin P. Mattock
