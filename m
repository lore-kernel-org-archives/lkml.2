Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755674Ab2JPERq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 00:17:46 -0400
Received: from spam1.hanyang.ac.kr ([166.104.177.29]:35077 "EHLO
	spam1.hanyang.ac.kr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754476Ab2JPERp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 00:17:45 -0400
X-Greylist: delayed 637 seconds by postgrey-1.27 at vger.kernel.org; Tue, 16 Oct 2012 00:17:44 EDT
Date: Tue, 16 Oct 2012 13:07:03 +0900 (GMT)
From: Sooman Jeong <77smart@hanyang.ac.kr>
To: linux-kernel@vger.kernel.org
Cc: 77smart@hanyang.ac.kr
Message-ID: <1350360423154.2800.144.00.1.77smart@hanyang.ac.kr>
Subject: Initial report on F2FS filesystem performance
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
X-Priority: 3
X-Mailer: Postian WebMail Ver.5.30.1406
X-IP: 166.104.177.101
X-FROM-DOMAIN: hanyang.ac.kr
X-FROM-EMAIL: 77smart@hanyang.ac.kr
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from BASE64 to 8bit by mail.home.local id q9G4Hq30029490


This is a brief summary of our initial filesystem performance study of f2fs against existing two filesystems in linux: EXT4, NILFS2, and f2fs.


* test platform
„ÄÄi) Desktop PC : Linux 3.6.1 (f2fs patched), Intel i5-2500 @3.3GHz quad-core, 8GB RAM, Transcend 16GB class 10 micro SD card
„ÄÄii) Galaxy-S3 : Linux 3.0.15 (f2fs ported), Android 4.0.4, DVFS turned off, Transcend 16GB class 10 micro SD card


* experiment 1: buffered write(sequential and random, 4KByte write)
===================================================================

F2FS surpasses other two filesystems in both random and sequential. In desktop and Galaxy S3, f2fs exhibits 2.5 and 1.6 times better performance in random write against EXT4, respectively. EXT4 is standard Android filesystem.

buffered write (1GB file)
+-------+---------------------------------+----------------------------------+
|       |           Desktop PC            |            Galaxy-S3             |
|       +-----------------+---------------+------------------+---------------+
|       |sequential (MB/s)| random (IOPS) |sequential (MB/s) | random (IOPS) |
+-------+-----------------+---------------+------------------+---------------+
| EXT4  |        7.1      |     1073      |        6.7       |     1073      |
+-------+-----------------+---------------+------------------+---------------+
| NILFS2|        6.8      |     1462      |        4.0       |     1272      |
+-------+-----------------+---------------+------------------+---------------+
| F2FS  |       10.6      |     2675      |        6.9       |     1682      |
+-------+-----------------+---------------+------------------+---------------+


* experiment 2: write + fsync(sequential and random)
====================================================

F2FS surpasses other two filesystems in both random and sequential workload. In desktop and Galaxy S3, f2fs exhibits 2 and 1.5 times better performance in write+fsync random write against EXT4, respectively.

write + fsync (100MB file)
+-------+---------------------------------+----------------------------------+
|       |           Desktop PC            |            Galaxy-S3             |
|       +-----------------+---------------+------------------+---------------+
|       |sequential (KB/s)| random (IOPS) |sequential (KB/s) | random (IOPS) |
+-------+-----------------+---------------+------------------+---------------+
| EXT4  |       511.8     |      125      |       383.4      |      119      |
+-------+-----------------+---------------+------------------+---------------+
| NILFS2|       545.2     |      112      |       356.7      |       72      |
+-------+-----------------+---------------+------------------+---------------+
| F2FS  |      1057.9     |      240      |       772.3      |      184      |
+-------+-----------------+---------------+------------------+---------------+

write() with fsync is to test the filesystem performance under Android SQLite operation.


* experiment 3: mounting time
===============================

To measure the mount time, we used two different scenarios. First, we mounted file system after formatting without rebooting system. Second, we mounted file system after rebooting in order to ensure any data cached in memory is flushed. Overall, EXT4 shows fastest mount time, and F2FS shows second best performance; however, we observed that F2FS takes longest time to mount right after formatting.

mounting time with Transcend 16GB micro-SD
+-------+-----------------------------------+-----------------------------------+
|       |           Desktop PC              |            Galaxy-S3              |
|       +-----------------+-----------------+-----------------+-----------------+
|       |1st mount after  | after rebooting |1st mount after  | after rebooting |
|       |format (msec)    | (msec)          |format (msec)    | (msec)          |
+-------+-----------------+-----------------+-----------------+-----------------+
| EXT4  |         11      |         20      |         20      |         40      |
+-------+-----------------+-----------------+-----------------+-----------------+
| NILFS2|        920      |       1013      |       1680      |       1630      |
+-------+-----------------+-----------------+-----------------+-----------------+
| F2FS  |       1486      |        161      |       2280      |       1570      |
+-------+-----------------+-----------------+-----------------+-----------------+


Sooman Jeong  ESOS Lab. Hanyang University.
<77smart@hanyang.ac.kr>ˇÙË∫{.n«+â∑üÆâ≠Ü+%äÀˇ±È›∂•äwˇ∫{.n«+â∑•ä{±˛G´ùÈˇä{ay∫ á⁄ôÎ,j≠¢f£¢∑höèÔÅÍˇëÍÁz_ËÆ(≠Èöéä›¢j"ù˙∂mßˇˇæ´˛G´ùÈˇ¢∏?ô®Ë≠⁄&£¯ß~è·∂iOïÊ¨z∑övÿ^∂mßˇˇ√ˇ∂Ïˇ¢∏?ñI•
