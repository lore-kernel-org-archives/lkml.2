Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab1ELCGX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 May 2011 22:06:23 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:62063 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750937Ab1ELCGW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 May 2011 22:06:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type
         :content-transfer-encoding;
        b=dXAxJlNvjzy714LnWkfJ58fcjJ1P245YfczLjvZO0+ypj6uAzyWPhFg81c8JBEdMkb
         EeQ+lXe2NoYShs8wy/5OZYH5NMSSla/cKIl3QMBPwR0taCU1P0813G1pMUh7sW3Uo7Rj
         IYaAs9Q23DNTDj9ddp0Vdy2VT8C5DziBxdDMc=
MIME-Version: 1.0
Date: Thu, 12 May 2011 10:06:21 +0800
Message-ID: <BANLkTikefReiFUggT8iPv0mOmY=+OOOS-A@mail.gmail.com>
Subject: problem with kmemleak
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

   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

 backtrace:

   [<ffffffffffffffff>] 0xffffffffffffffff

unreferenced object 0xffffc90012d24000 (size 64):

 comm "insmod", pid 13092, jiffies 4298369684

 hex dump (first 32 bytes):

   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

 backtrace:

   [<ffffffffffffffff>] 0xffffffffffffffff

unreferenced object 0xffffc90012d27000 (size 64):

 comm "insmod", pid 13092, jiffies 4298369684

 hex dump (first 32 bytes):

   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................

 backtrace:

   [<ffffffffffffffff>] 0xffffffffffffffff

There is no other backtrace except [<ffffffffffffffff>]
0xffffffffffffffff. Then I read the mm/kmemleak.c. In
kmemleak_seq_show(), I find that the object->trace_len is 1.



How can I get the full backtrace?
