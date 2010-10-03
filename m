Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab0JCLbE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Oct 2010 07:31:04 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:64243 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753075Ab0JCLbC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Oct 2010 07:31:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=Dvp8jA1It1JFvKq49ecXv7bCb4bTcBOuKpn/+rnkN3Cc0oCOlglTUPs9U0nZpKPCfg
         PbAtedGcIVQJ0oVyEZfQ78SyVzJLjI00UfWXcx6d3yCn43pm0veXCZwoh1wei+Dg/DNL
         HiTcQebogbTikE9quf3sg9/TWCCP8KF4XrLTY=
MIME-Version: 1.0
Date: Sun, 3 Oct 2010 15:31:01 +0400
Message-ID: <AANLkTi=fH924fybfmSpxyOu5Vm8Ny9cSyMGWcQN3dvvD@mail.gmail.com>
Subject: gcc compile kernel 2.6 module
From: Frank Coldwell <junkdnaseq@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

Does anybody know how should look gcc compilation line
to compile kernel module for kernel 2.6

In 2.4 it looks like this:
----------------------------------------------------
TARGET := hello-1
WARN := -W -Wall -Wstrict-prototypes -Wmissing-prototypes
INCLUDE := -isystem /lib/modules/`uname -r`/build/include
CFLAGS := -O2 -DMODULE -D__KERNEL__ ${WARN} ${INCLUDE}
CC := gcc-3.0

${TARGET}.o: ${TARGET}.c

.PHONY: clean

clean:
rm -rf ${TARGET}.o
----------------------------------------------------

and for multiple source files, like this:
----------------------------------------------------
CC=gcc
MODCFLAGS := -O -Wall -DMODULE -D__KERNEL__

hello.o: hello2_start.o hello2_stop.o
ld -m elf_i386 -r -o hello2.o hello2_start.o hello2_stop.o

start.o: hello2_start.c
${CC} ${MODCFLAGS} -c hello2_start.c

stop.o: hello2_stop.c
${CC} ${MODCFLAGS} -c hello2_stop.c
----------------------------------------------------

Kind regards,

Dragoslav Zaric
MSc Astrophysics
Professional programmer
