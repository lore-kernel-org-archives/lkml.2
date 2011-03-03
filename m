Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756520Ab1CCBPy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 20:15:54 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:4423 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753927Ab1CCBPx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 20:15:53 -0500
X-Server-Uuid: B55A25B1-5D7D-41F8-BC53-C57E7AD3C201
From: "Jian Peng" <jipeng@broadcom.com>
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
cc: "Jian Peng" <jipeng@broadcom.com>
Date: Wed, 2 Mar 2011 17:15:42 -0800
Subject: 2.6.37 kernel compilation warning with gcc-4.5.2
Thread-Topic: 2.6.37 kernel compilation warning with gcc-4.5.2
Thread-Index: AcvZQIKrPIkYtNyRSkqCLlP8hQ8ZuA==
Message-ID: <E18F441196CA634DB8E1F1C56A50A8743241DEA69E@IRVEXCHCCR01.corp.ad.broadcom.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
MIME-Version: 1.0
X-WSS-ID: 617033C826W6530729-01-01
Content-Type: text/plain;
 charset=us-ascii
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

While compiling 2.6.37 kernel with gcc-4.5.2 based toolchain for MIPS, there are a few warnings

  CC      kernel/async.o
kernel/async.c: In function 'async_synchronize_cookie_domain':
kernel/async.c:270:10: warning: 'starttime.tv64' may be used uninitialized in this function
kernel/async.c: In function 'async_run_entry_fn':
kernel/async.c:122:10: warning: 'calltime.tv64' may be used uninitialized in this function
...
  CC      fs/ubifs/super.o
fs/ubifs/super.c: In function 'ubifs_umount':
fs/ubifs/super.c:1491:2: warning: statement with no effect
  CC      fs/ubifs/sb.o
  CC      fs/ubifs/io.o
  CC      fs/ubifs/tnc.o
  CC      fs/ubifs/master.o
  CC      fs/ubifs/scan.o
  CC      fs/ubifs/replay.o
  CC      fs/ubifs/log.o
  CC      fs/ubifs/commit.o
  CC      fs/ubifs/gc.o
  CC      fs/ubifs/orphan.o
  CC      fs/ubifs/budget.o
  CC      fs/ubifs/find.o
  CC      fs/ubifs/tnc_commit.o
  CC      fs/ubifs/compress.o
  CC      fs/ubifs/lpt.o
  CC      fs/ubifs/lprops.o
  CC      fs/ubifs/recovery.o
  CC      fs/ubifs/ioctl.o
  CC      fs/ubifs/lpt_commit.o
c/lpt_commit.c: In function 'layout_cnodes':
fs/ubifs/lpt_commit.c:211:3: warning: statement with no effect
fs/ubifs/lpt_commit.c:219:3: warning: statement with no effect
fs/ubifs/lpt_commit.c:233:4: warning: statement with no effect
fs/ubifs/lpt_commit.c:246:5: warning: statement with no effect
fs/ubifs/lpt_commit.c:254:5: warning: statement with no effect
fs/ubifs/lpt_commit.c:267:3: warning: statement with no effect
fs/ubifs/lpt_commit.c:276:4: warning: statement with no effect
fs/ubifs/lpt_commit.c:288:3: warning: statement with no effect
fs/ubifs/lpt_commit.c:296:4: warning: statement with no effect
fs/ubifs/lpt_commit.c:308:3: warning: statement with no effect
fs/ubifs/lpt_commit.c:313:2: warning: statement with no effect
fs/ubifs/lpt_commit.c: In function 'write_cnodes':
fs/ubifs/lpt_commit.c:395:3: warning: statement with no effect
fs/ubifs/lpt_commit.c:402:3: warning: statement with no effect
fs/ubifs/lpt_commit.c:421:4: warning: statement with no effect
fs/ubifs/lpt_commit.c:436:5: warning: statement with no effect
fs/ubifs/lpt_commit.c:443:5: warning: statement with no effect
fs/ubifs/lpt_commit.c:465:3: warning: statement with no effect
fs/ubifs/lpt_commit.c:479:4: warning: statement with no effect
fs/ubifs/lpt_commit.c:493:3: warning: statement with no effect
fs/ubifs/lpt_commit.c:506:4: warning: statement with no effect
fs/ubifs/lpt_commit.c:520:3: warning: statement with no effect
fs/ubifs/lpt_commit.c:531:2: warning: statement with no effect
...
  CC      drivers/base/power/sysfs.o
  CC      drivers/base/power/main.o
drivers/base/power/main.c: In function 'pm_noirq_op.clone.17':
drivers/base/power/main.c:306:10: warning: 'calltime.tv64' may be used uninitialized in this function
...

Those in fs/ubifs really bothers me since all of them are for debugging and gcc dislike them.

Did anyone fix it in either changing Makefile or C codes? If not, I will post my patch to get rid of them.

Thanks,
Jian

