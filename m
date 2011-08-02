Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755267Ab1HBUbQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 16:31:16 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:43366 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754944Ab1HBUbJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 16:31:09 -0400
MIME-Version: 1.0
In-Reply-To: <1311853470.21232.31.camel@mfleming-mobl1.ger.corp.intel.com>
References: <1311853470.21232.31.camel@mfleming-mobl1.ger.corp.intel.com>
From: Metatech <metatechbe@gmail.com>
Date: Tue, 2 Aug 2011 22:30:39 +0200
Message-ID: <CALY2Lrff5avZEi4e3uQQM_nuUAshwNKULHQuFb-tUigKcxVDxQ@mail.gmail.com>
Subject: Re: efilinux release 0.8
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matt,

I tested your program on a MacBook Pro 5,3 (x86-64 efi).

Here are the changes I did :

1. In protocol.h, comment "LocateProtocol" function

2. Add 2 symlinks in Ubuntu
mkdir /usr/lib64/gnuefi
cd /usr/lib64/gnuefi
sudo ln -s /usr/lib64/crt0-efi-x86_64.o crt0-efi-x86_64.o
sudo ln -s  /usr/lib64/elf_x86_64_efi.lds elf_x86_64_efi.lds

3. Comment the CRC check on the executable
/*if (CheckCrc(sys_table->Hdr.HeaderSize, &sys_table->Hdr) != TRUE)*/

4. The program fails in function "fs_init", with the following error
		Print(L"No devices support filesystems\n");
-> err = 14 (which means "not found").

Hope this helps,
Regards,

metatech


On 28 July 2011 13:44, Matt Fleming <matt@console-pimps.org> wrote:
> Hi,
>
> I'm pleased to announce release 0.8 of efilinux, a reference
> implementation of a minimal UEFI bootloader. This bootloader has no
> bells or whistles, it is simply a prototype with the minimum amount of
> smarts required to load a linux kernel (though loaders for other formats
> could be added).
