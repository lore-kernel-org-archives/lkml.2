Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364Ab0JBRxf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 13:53:35 -0400
Received: from caiajhbdcaib.dreamhost.com ([208.97.132.81]:48051 "EHLO
	homiemail-a3.g.dreamhost.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750857Ab0JBRxe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 13:53:34 -0400
Subject: Re: Makefile for kernel modules
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Dragoslav Zaric <zaricdragoslav@gmail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <AANLkTikKjP-VLkygYbyg8THiCuM=vBfGaqq49+cuBj6u@mail.gmail.com>
References: <AANLkTikKjP-VLkygYbyg8THiCuM=vBfGaqq49+cuBj6u@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Sat, 02 Oct 2010 13:53:31 -0400
Message-ID: <1286042011.2036.1.camel@cowboy>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2010-10-02 at 21:20 +0400, Dragoslav Zaric wrote:
> Dear all,
> 
> I have a question about kernel modules compilation. I understand the
> way how make/Makefile works,
> for example if I have two source files, hexdump3.asm and textlib.asm,
> my Makefile will look like this:
> ---------------------------------------------------------------------------
> hexdump3: hexdump3.o
> 	ld -o hexdump3 hexdump3.o textlib.o
> hexdump3.o: hexdump3.asm
> 	nasm -f elf -g -F stabs hexdump3.asm
> textlib.o: textlib.asm
> 	nasm -f elf -g -F stabs textlib.asm
> ---------------------------------------------------------------------------
> and I understand how this works, it goes bottom up, building dependencies first.
> 
> But if I have two kernel modules source files, for example, start.c
> and stop.c, my Makefile will look like this:
> ---------------------------------------------------------------------------
> obj-m += startstop.o
> startstop-objs := start.o stop.o
> 
> all:
> 	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
> clean:
> 	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
> ---------------------------------------------------------------------------
> But this does not work on my machine, it runs without errors but does
> not produce startstop.ko file.
> Also, when I run make on my machine, first line that appears is:
> ---------------------------------------------------------------------------
> make -C /lib/modules/2.6.33.7-rt29/build
> M=/home/maiev/work/modules/parts modules
> ---------------------------------------------------------------------------
> 
> So, does anybody know what are lines for manual kernel module
> compilation using probably gcc,
> without 'obj-m +=' or at least how Makefile should look for multiple
> kernel module source files ???

This is covered, among many other resources, in LDD3, chapter 2:
http://lwn.net/images/pdf/LDD3/ch02.pdf

For these kind of questions you might want to email the kernelnewbies
ML, instead of LKML, which is basically for the development of the
kernel.

- Davidlohr


