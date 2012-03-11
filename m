Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754223Ab2CKWtp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Mar 2012 18:49:45 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:63990 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753711Ab2CKWtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Mar 2012 18:49:41 -0400
MIME-Version: 1.0
Date: Sun, 11 Mar 2012 17:49:40 -0500
Message-ID: <CAPGNrUWYc6xzaqPnLmD12Vaz3mr9hEA6k4OP70FCjhBYM7mVhA@mail.gmail.com>
Subject: bug in the way Linux loads elf files...
From: Mark Manning <mark4th@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It seems that the linux kernel does not exactly conform to the TIS elf
standard.  as follows...


I have a small asm source file that a assemble with nasm

  [section text]
  global _start

_start:
  mov eax, 1
  int 0x80

after linking i end up with a elf executable which does nothing
execept terminate which of course works perfectly fine.

If however i modify the .text sections program header to make the
memory size larger than the file size the process is killed before it
is even run.  I have not tracked down where this happens.

  Type            Offset       VirtAddr         PhysAddr     FileSiz
MemSiz  Flg Align
  LOAD           0x000000 0x08048000 0x08048000 0x0007b 0x01000 R   0x1000

i patched MemSiz to be larger than FileSiz which should work but does not.
