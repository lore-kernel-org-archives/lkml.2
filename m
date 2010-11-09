Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754580Ab0KIANl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Nov 2010 19:13:41 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:61759 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753014Ab0KIANk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Nov 2010 19:13:40 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=vy77Z6R8Hje+udQRkY3FtkPd4P2aiEoFwn5bFA4XKY+q3HTOE71d/LSoANsBx4GqUy
         RCl+AfBqlW0wUrlIo+pfZ84Fi8wyI3jblLd2zDoHmr4YJrauJVqm+azzpGxoBojkL7j1
         4smBBEExJG2Kz5QlVyRBj5ZEbFYC/tvLCCgr0=
MIME-Version: 1.0
Date: Tue, 9 Nov 2010 11:13:38 +1100
Message-ID: <AANLkTikCnK7YN9F3JOv0rVZt65iQ=v=YJ_ONOuwj_=9D@mail.gmail.com>
Subject: 2.6.37-rc1 kmemleak warnings when saving a file over cifs.
From: Andrew Hendry <andrew.hendry@gmail.com>
To: linux-kernel <linux-kernel@vger.kernel.org>, linux-cifs@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Have just noticed these in the past few days, now running 2.6.37-rc1+
Seems to be 1 logged per file save when using a text file with gedit over cifs.

unreferenced object 0xffff88022ee08b40 (size 32):
  comm "gedit", pid 2524, jiffies 4300160388 (age 2633.655s)
  hex dump (first 32 bytes):
    5c 2e 67 6f 75 74 70 75 74 73 74 72 65 61 6d 2d  \.goutputstream-
    35 42 41 53 4c 56 00 de 09 00 00 00 2c 26 78 ee  5BASLV......,&x.
  backtrace:
    [<ffffffff81504a4d>] kmemleak_alloc+0x2d/0x60
    [<ffffffff81136e13>] __kmalloc+0xe3/0x1d0
    [<ffffffffa0313db0>] build_path_from_dentry+0xf0/0x230 [cifs]
    [<ffffffffa031ae1e>] cifs_setattr+0x9e/0x770 [cifs]
    [<ffffffff8115fe90>] notify_change+0x170/0x2e0
    [<ffffffff81145ceb>] sys_fchmod+0x10b/0x140
    [<ffffffff8100c172>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff

unreferenced object 0xffff88022b469ca0 (size 32):
  comm "gedit", pid 2543, jiffies 4300529624 (age 2264.419s)
  hex dump (first 32 bytes):
    5c 2e 67 6f 75 74 70 75 74 73 74 72 65 61 6d 2d  \.goutputstream-
    30 38 53 59 4c 56 00 de 01 00 00 00 00 00 00 00  08SYLV..........
  backtrace:
    [<ffffffff81504a4d>] kmemleak_alloc+0x2d/0x60
    [<ffffffff81136e13>] __kmalloc+0xe3/0x1d0
    [<ffffffffa0313db0>] build_path_from_dentry+0xf0/0x230 [cifs]
    [<ffffffffa031ae1e>] cifs_setattr+0x9e/0x770 [cifs]
    [<ffffffff8115fe90>] notify_change+0x170/0x2e0
    [<ffffffff811457cf>] chown_common+0x9f/0xc0
    [<ffffffff8114588e>] sys_fchown+0x9e/0xc0
    [<ffffffff8100c172>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff

unreferenced object 0xffff88022b5f8d20 (size 32):
  comm "gedit", pid 1885, jiffies 4294979706 (age 1221.634s)
  hex dump (first 32 bytes):
    5c 2e 67 6f 75 74 70 75 74 73 74 72 65 61 6d 2d  \.goutputstream-
    34 38 38 59 4c 56 00 de 02 00 00 00 00 00 00 00  488YLV..........
  backtrace:
    [<ffffffff81505bad>] kmemleak_alloc+0x2d/0x60
    [<ffffffff81136e23>] __kmalloc+0xe3/0x1d0
    [<ffffffffa0329b90>] build_path_from_dentry+0xf0/0x230 [cifs]
    [<ffffffffa0330abe>] cifs_setattr+0x9e/0x770 [cifs]
    [<ffffffff8115fea0>] notify_change+0x170/0x2e0
    [<ffffffff81145cfb>] sys_fchmod+0x10b/0x140
    [<ffffffff8100c172>] system_call_fastpath+0x16/0x1b
    [<ffffffffffffffff>] 0xffffffffffffffff
