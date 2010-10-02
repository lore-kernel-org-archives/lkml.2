Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750972Ab0JBRUT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Oct 2010 13:20:19 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:36865 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750803Ab0JBRUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Oct 2010 13:20:17 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=alCd47J0/svJyZcDQi75aXaOxkscyY2qkhAhB2AG/p/7ejUF5JRDspy/2ByRPco9ZS
         4wTmvwB6Mh3OgIB/YLIu0Wh0rKICFBiInugrd3hSSabx9VAjVT8e9duwOWwDK8jDjNZl
         pd1Ked4sbhQCEyOL2jMjlwkaZjd/1ww5mdkXI=
MIME-Version: 1.0
Date: Sat, 2 Oct 2010 21:20:16 +0400
Message-ID: <AANLkTikKjP-VLkygYbyg8THiCuM=vBfGaqq49+cuBj6u@mail.gmail.com>
Subject: Makefile for kernel modules
From: Dragoslav Zaric <zaricdragoslav@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

I have a question about kernel modules compilation. I understand the
way how make/Makefile works,
for example if I have two source files, hexdump3.asm and textlib.asm,
my Makefile will look like this:
---------------------------------------------------------------------------
hexdump3: hexdump3.o
	ld -o hexdump3 hexdump3.o textlib.o
hexdump3.o: hexdump3.asm
	nasm -f elf -g -F stabs hexdump3.asm
textlib.o: textlib.asm
	nasm -f elf -g -F stabs textlib.asm
---------------------------------------------------------------------------
and I understand how this works, it goes bottom up, building dependencies first.

But if I have two kernel modules source files, for example, start.c
and stop.c, my Makefile will look like this:
---------------------------------------------------------------------------
obj-m += startstop.o
startstop-objs := start.o stop.o

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) modules
clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(PWD) clean
---------------------------------------------------------------------------
But this does not work on my machine, it runs without errors but does
not produce startstop.ko file.
Also, when I run make on my machine, first line that appears is:
---------------------------------------------------------------------------
make -C /lib/modules/2.6.33.7-rt29/build
M=/home/maiev/work/modules/parts modules
---------------------------------------------------------------------------

So, does anybody know what are lines for manual kernel module
compilation using probably gcc,
without 'obj-m +=' or at least how Makefile should look for multiple
kernel module source files ???

Kind regards

--
Dragoslav Zaric

Professional Programmer
MSc Astrophysics
