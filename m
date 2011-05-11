Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755881Ab1EKPv2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 11:51:28 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:42741 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755832Ab1EKPvY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 11:51:24 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=H45PJJjYxFfoOU7ZE46QpEK1QSKzvWXA95MKEX2id8BVQWhf3fxEOj6C6vDXPavVYp
         uWh7Om8kxgKBoxvR8h1aM9gFpH/y1pKRePuGJPgAO5L4CkIYI6CXcjS3YQsjlvyw5Y8O
         SkFkzu0KzaMD+s9N74etxBcWRvDvc6EQfiDWA=
MIME-Version: 1.0
In-Reply-To: <BANLkTi=JXq+V783amiJB-qLX=7PaeH-83w@mail.gmail.com>
References: <1302960373-5309-1-git-send-email-abogani@kernel.org>
	<BANLkTi=y60Jt3-OMzbxQJzGkvzCzNJfJtA@mail.gmail.com>
	<BANLkTimfFEv+vZ8dYvhG0oj2Q4g+KnG4aA@mail.gmail.com>
	<BANLkTinDiGCaKPtS+ZpKf2swJpParJ4eew@mail.gmail.com>
	<BANLkTi=JXq+V783amiJB-qLX=7PaeH-83w@mail.gmail.com>
Date: Wed, 11 May 2011 17:25:40 +0200
X-Google-Sender-Auth: vMXVu3VgxI0NV4aSWjlTdkLdrPY
Message-ID: <BANLkTi=OXuR4iJFqUEa4pA=yO0aXaqEzyA@mail.gmail.com>
Subject: Re: [PATCH 0/4] Speed up the symbols' resolution process V4
From: Alessio Igor Bogani <abogani@kernel.org>
To: Mike Frysinger <vapier.adi@gmail.com>
Cc: Rusty Russell <rusty@rustcorp.com.au>, Tim Abbott <tabbott@ksplice.com>,
        Anders Kaseorg <andersk@ksplice.com>,
        Jason Wessel <jason.wessel@windriver.com>,
        Tim Bird <tim.bird@am.sony.com>, LKML <linux-kernel@vger.kernel.org>,
        Linux Embedded <linux-embedded@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Mr. Frysinger,

2011/5/11 Mike Frysinger <vapier.adi@gmail.com>:
[...]
>> Sorry I don't think that is a good choice from a long term point of
>> view. What do you think to add MODULE_SYMBOL_PREFIX to section names
>> instead? In this way symbol and section names should always be
>> different also on symbol prefixed archs (which are blackfin and
>> h8300).
>
> that doesnt work.  it simply delays the problem to another set of
> underscores.  so with that change, local_bh_enable/_local_bh_enable
> work, but now send_remote_softirq/__send_remote_softirq fail:

In my opinion it should work. if I use SYMBOL_PREFIX + two underscore
for section name I should always obtain different names.
So if SYMBOL_PREFIX is "_" section name will be "___", if
SYMBOL_PREFIX is "__" section name will be "____" and so on.

>  CC      kernel/softirq.o
> nano /tmp/cconhYy1.s: Assembler messages:
> /tmp/cconhYy1.s:3664: Error: symbol `___ksymtab___send_remote_softirq'
> is already defined
> make[1]: *** [kernel/softirq.o] Error 1

I'm a bit confused. I can build a kernel here:
$ make ARCH=blackfin CROSS_COMPILE="bfin-uclinux-" defconfig
*** Default configuration is based on 'BF537-STAMP_defconfig'
[...]
$ make ARCH=blackfin CROSS_COMPILE="bfin-uclinux-"
  CHK     include/linux/version.h
  CHK     include/generated/utsrelease.h
  CALL    scripts/checksyscalls.sh
[...]
  OBJCOPY arch/blackfin/boot/vmlinux.bin
  GZIP    arch/blackfin/boot/vmlinux.bin.gz
  UIMAGE  arch/blackfin/boot/vmImage.gz
Image Name:   bf537-0.2-2.6.39-rc3-00004-gf26a
Created:      Wed May 11 17:06:45 2011
Image Type:   Blackfin Linux Kernel Image (gzip compressed)
Data Size:    986471 Bytes = 963.35 kB = 0.94 MB
Load Address: 00001000
Entry Point:  001a8518
  Building modules, stage 2.
  MODPOST 69 modules

Unfortunately I can't make skyeye emulator works to test the obtained
kernel image.

Ciao,
Alessio
