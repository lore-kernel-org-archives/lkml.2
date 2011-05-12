Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756928Ab1ELCCp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 22:02:45 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:65499 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751701Ab1ELCCo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 22:02:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=QzPL6ANS+E1itmT5uCMotn2ewM0ePdvPyTgNrUnRexMoxNLwblODP63hcNswAKhI2v
         5bslrLvw8AuBQGB2qfVNnn9dmOacvXpjFkxk9BP+eHVstWF3tobfOHyZZktBWCS8q4R8
         diW6yyu2ryS2ZKPO8J+VYtkXRbp+DazrhT/xo=
MIME-Version: 1.0
Date: Thu, 12 May 2011 10:02:43 +0800
Message-ID: <BANLkTim0zQA-2ZyYkOq7GoZpZB3T9bWruw@mail.gmail.com>
Subject: 
From: ttlxzz ccc <boyzccc@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, all:



I just want to use kmemleak, so I make the CONFIG_DEBUG_KMEMLEAK and
CONFIG_DEBUG_FS on, mount the debugfs.

But when I insmod mm/kmemleak-test.ko, echo scan >
/sys/kernel/debug/kmemleak and cat /sys/kernel/debug/kmemleak. I just
see this:

unreferenced object 0xffffc90012d21000 (size 64):

  comm "insmod", pid 13092, jiffies 4298369684

  hex dump (first 32 bytes):

    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

  backtrace:

    [<ffffffffffffffff>] 0xffffffffffffffff

unreferenced object 0xffffc90012d24000 (size 64):

  comm "insmod", pid 13092, jiffies 4298369684

  hex dump (first 32 bytes):

    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

  backtrace:

    [<ffffffffffffffff>] 0xffffffffffffffff

unreferenced object 0xffffc90012d27000 (size 64):

  comm "insmod", pid 13092, jiffies 4298369684

  hex dump (first 32 bytes):

    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

  backtrace:

    [<ffffffffffffffff>] 0xffffffffffffffff

There is no other backtrace except [<ffffffffffffffff>]
0xffffffffffffffff. Then I read the mm/kmemleak.c. In
kmemleak_seq_show(), I find that the object->trace_len is 1.



How can I get the full backtrace?
