Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753382Ab1FSKOr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Jun 2011 06:14:47 -0400
Received: from ext190.halfdog.net ([88.116.147.190]:34298 "EHLO
	mail.halfdog.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753246Ab1FSKOp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Jun 2011 06:14:45 -0400
Message-ID: <4DFDCBE0.5020806@halfdog.net>
Date: Sun, 19 Jun 2011 10:13:52 +0000
From: halfdog <me@halfdog.net>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:2.0pre) Gecko/20110408 Firefox/4.0pre SeaMonkey/2.1b3
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Can someone confirm ext4 BUG_ON on latest kernel build?
X-Enigmail-Version: 1.2a1pre
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Sorry, I do not have latest kernel. Can someone confirm this on latest?
At least bugtracker does not know about it, and to my understanding of
source, should be still here.


dd if=/dev/zero bs=1M count=64 of=test
mkfs.ext4 -F test
echo -n " " | dd of=test bs=1 count=1 seek=297195 conv=notrunc
mount -o loop test /mnt/test
dmesg -c

On ubuntu natty with latest kernel, it seems, that
fs/ext4/super.c:__save_error_info calls mod_timer before timer->function
is set at end of fs/ext4/super.c:ext4_fill_super via
  sbi->s_err_report.function = print_daily_error_info;

This causes BUG_ON(!timer->function) in kernel/timer.c:__mod_timer
Device is stuck, not usable any more.

Thanks

- -- 
http://www.halfdog.net/
PGP: 156A AE98 B91F 0114 FE88  2BD8 C459 9386 feed a bee
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.6 (GNU/Linux)

iD8DBQFN/cvFxFmThv7tq+4RAgfvAJ97N9bnKq4kN99XneTMyJZ5Hha9MQCfcguN
L4trkTeOsIqDWF8m6VUqcgc=
=zvYY
-----END PGP SIGNATURE-----
