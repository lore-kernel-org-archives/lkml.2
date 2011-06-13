Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753946Ab1FMVRP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jun 2011 17:17:15 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36102 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab1FMVRO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jun 2011 17:17:14 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=Hw7MPWsdH9HaNLmoYDfeCfeXcxWGMyfPVviosfilxYi+xjgfVEvNNLgzaGncc1p9Ec
         PLrWpcJnpN7pHZlDeiAEnRD3tHdd3NJ3wJkCcPfHVgp+t6TgzPaP5sn/AwogZ6v5xFQq
         k4Jcu6ENgh345N/zPGsfkTpT5oveYJg1MfkpY=
MIME-Version: 1.0
Date: Tue, 14 Jun 2011 06:17:13 +0900
Message-ID: <BANLkTin5M2-3puDxxo5Cxs5qHkS7vGeH8w@mail.gmail.com>
Subject: Question regarding mmap() with MAP_FIXED flag
From: Jongman Heo <jongman.heo@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear all,

Please let me ask a dumb question.

I use following mmap call, to get the same virtual address with given
physical address.
And when reading the mmap-ed memory, it seems that the virtual address
correctly points to the physical address.

  ptr = mmap((void*)0x400000, getpagesize(), PROT_READ, MAP_PRIVATE |
MAP_FIXED , mem_fd, 0x400000);

  where mem_fd is the file descriptor of /dev/mem.

And using memmap boot arguments, 4M RAM location is not used by Linux.
The area is written by bootloader. (.. memmap=exactmap memmap=64k@0
memmap=3M@1M memmap=1019M@5M)


It works, but I'm afraid that the possiblity of mmap() failure with
MAP_FIXED flag.
man page of mmap states following:

   MAP_FIXED  Do not select a different address than the one
specified.  If the memory  region  speci-
                  fied  by  start  and  len overlaps pages of any
existing mapping(s), then the overlapped
                  part of the existing mapping(s) will be discarded.
If the specified address  cannot  be
                  used, mmap() will fail.  If MAP_FIXED is specified,
start must be a multiple of the page
                  size.  Use of this option is discouraged.


Q1. What does the existing mapping mean?
Another mmap mapping by any other user space process? Or it means that
the virtual address (0x400000 in my case) is already acquired/used by
others (kernel, process, or whatever)?

Q2. When can't the specified address be used?

Q3. Is there any solution such that mmap with MAP_FIXED being not
failed but always succeed?


Thanks in advance,
Jongman Heo.
