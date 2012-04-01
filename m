Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab2DACHl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Mar 2012 22:07:41 -0400
Received: from caibbdcaaaaf.dreamhost.com ([208.113.200.5]:39520 "EHLO
	homiemail-a52.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753984Ab2DACHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Mar 2012 22:07:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws; d=shealevy.com; h=message-id:date
	:from:mime-version:to:cc:subject:references:in-reply-to
	:content-type:content-transfer-encoding; q=dns; s=shealevy.com;
	 b=ITGGR7uj16h4IWmBILHpvohBSGsiTUJDCoTQ9B/TCxIOtcESEKMJ/COVqS++G
	wWjpjmOsD8cH0Td8hi1o4fD3W+7JG84cqf+CNgjDH5/lQUcZ3uwDsOtagG1nbVJC
	IPOra3fDe9fkXT0cuo8Yh5c7FCNSMD+I1PcLtKauNVdibk=
Message-ID: <4F77B867.602@shealevy.com>
Date: Sat, 31 Mar 2012 22:07:35 -0400
From: Shea Levy <shea@shealevy.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120321 Thunderbird/11.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.4-rc1
References: <CA+55aFy4aFGRLUrF+rYN3dskTepBtC+=x3B3bc_rzf1OaN_5pw@mail.gmail.com> <4F77B3FA.1040001@shealevy.com>
In-Reply-To: <4F77B3FA.1040001@shealevy.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2012 09:48 PM, Shea Levy wrote:
> Hello,
>
> On 03/31/2012 07:58 PM, Linus Torvalds wrote:
>> Ok, it's been two weeks, and the merge window is over. Linux 3.4-rc1
>> has been pushed out to the git servers, and the tar-ball and patches
>> are going out as I type this (probably done by the time I'm done).
>>
>
> Building this fails with:
>
> Kernel: arch/x86/boot/bzImage is ready  (#1)
> ERROR: "snd_tea575x_init" [drivers/media/radio/radio-maxiradio.ko] 
> undefined!
> ERROR: "snd_tea575x_exit" [drivers/media/radio/radio-maxiradio.ko] 
> undefined!
> WARNING: modpost: Found 6 section mismatch(es).
> To see full details build your kernel with:
> 'make CONFIG_DEBUG_SECTION_MISMATCH=y'
> make[1]: *** [__modpost] Error 1
> make: *** [modules] Error 2
>
> .config follows, I'll build with CONFIG_DEBUG_SECTION_MISMATCH and 
> report back.
>

Warnings I get:

WARNING: drivers/usb/host/xhci-hcd.o(.init.text+0x3b): Section mismatch 
in reference from the function init_module() to the function 
.exit.text:xhci_unregister_pci()
The function __init init_module() references
a function __exit xhci_unregister_pci().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __exit annotation of
xhci_unregister_pci() so it may be used outside an exit section.

WARNING: drivers/usb/gadget/g_audio.o(.init.text+0x612): Section 
mismatch in reference from the function afunc_bind() to the function 
.devexit.text:snd_uac2_remove()
The function __init afunc_bind() references
a function __devexit snd_uac2_remove().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __devexit annotation of
snd_uac2_remove() so it may be used outside an exit section.

WARNING: drivers/staging/comedi/drivers/s626.o(.text+0x255a): Section 
mismatch in reference from the function s626_attach() to the variable 
.devinit.rodata:s626_pci_table
The function s626_attach() references
the variable __devinitconst s626_pci_table.
This is often because s626_attach lacks a __devinitconst
annotation or the annotation of s626_pci_table is wrong.

WARNING: drivers/staging/comedi/drivers/s626.o(.text+0x2560): Section 
mismatch in reference from the function s626_attach() to the variable 
.devinit.rodata:s626_pci_table
The function s626_attach() references
the variable __devinitconst s626_pci_table.
This is often because s626_attach lacks a __devinitconst
annotation or the annotation of s626_pci_table is wrong.

WARNING: drivers/staging/comedi/drivers/s626.o(.text+0x2566): Section 
mismatch i
n reference from the function s626_attach() to the variable 
.devinit.rodata:s626_pci_table
The function s626_attach() references
the variable __devinitconst s626_pci_table.
This is often because s626_attach lacks a __devinitconst
annotation or the annotation of s626_pci_table is wrong.

WARNING: drivers/staging/comedi/drivers/s626.o(.text+0x256c): Section 
mismatch in reference from the function s626_attach() to the variable 
.devinit.rodata:s626_pci_table
The function s626_attach() references
the variable __devinitconst s626_pci_table.
This is often because s626_attach lacks a __devinitconst
annotation or the annotation of s626_pci_table is wrong.

WARNING: drivers/usb/gadget/g_audio.o(.init.text+0x612): Section 
mismatch in reference from the function afunc_bind() to the function 
.devexit.text:snd_uac2_remove()
The function __init afunc_bind() references
a function __devexit snd_uac2_remove().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __devexit annotation of
snd_uac2_remove() so it may be used outside an exit section.

WARNING: drivers/usb/host/xhci-hcd.o(.init.text+0x3b): Section mismatch 
in reference from the function init_module() to the function 
.exit.text:xhci_unregister_pci()
The function __init init_module() references
a function __exit xhci_unregister_pci().
This is often seen when error handling in the init function
uses functionality in the exit path.
The fix is often to remove the __exit annotation of
xhci_unregister_pci() so it may be used outside an exit section.
