Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752989Ab2HDMIa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 08:08:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40886 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752623Ab2HDMII (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 08:08:08 -0400
From: Namjae Jeon <linkinjeon@gmail.com>
To: axboe@kernel.dk, tj@kernel.org, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, Namjae Jeon <linkinjeon@gmail.com>
Subject: [PATCH 3/3] Documentation: update sysfs files in block/queue-sysfs.txt
Date: Sat,  4 Aug 2012 08:07:59 -0400
Message-Id: <1344082079-2655-1-git-send-email-linkinjeon@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Update sysfs files in block/queue-sysfs.txt

Signed-off-by: Namjae Jeon <linkinjeon@gmail.com>
---
 Documentation/block/queue-sysfs.txt |   64 +++++++++++++++++++++++++++++++++++
 1 file changed, 64 insertions(+)

diff --git a/Documentation/block/queue-sysfs.txt b/Documentation/block/queue-sysfs.txt
index d8147b3..122a0da 100644
--- a/Documentation/block/queue-sysfs.txt
+++ b/Documentation/block/queue-sysfs.txt
@@ -9,20 +9,71 @@ These files are the ones found in the /sys/block/xxx/queue/ directory.
 Files denoted with a RO postfix are readonly and the RW postfix means
 read-write.
 
+add_random (RW)
+----------------
+This file allows to trun off the disk entropy contribution. Default
+value of this file is '1'(on).
+
+discard_granularity (RO)
+-----------------------
+This shows the size of internal allocation of the device in bytes, if
+reported by the device. A value of '0' means device does not support
+the discard functionality.
+
+discard_max_bytes (RO)
+----------------------
+Devices that support discard functionality may have internal limits on
+the number of bytes that can be trimmed or unmapped in a single operation.
+The discard_max_bytes parameter is set by the device driver to the maximum
+number of bytes that can be discarded in a single operation. Discard
+requests issued to the device must not exceed this limit. A discard_max_bytes
+value of 0 means that the device does not support discard functionality.
+
+discard_zeroes_data (RO)
+------------------------
+When read, this file will show if the discarded block are zeroed by the
+device or not. If its value is '1' the blocks are zeroed otherwise not.
+
 hw_sector_size (RO)
 -------------------
 This is the hardware sector size of the device, in bytes.
 
+iostats (RW)
+-------------
+This file is used to control (on/off) the iostats accounting of the
+disk.
+
+logical_block_size (RO)
+-----------------------
+This is the logcal block size of the device, in bytes.
+
 max_hw_sectors_kb (RO)
 ----------------------
 This is the maximum number of kilobytes supported in a single data transfer.
 
+max_integrity_segments (RO)
+---------------------------
+When read, this file shows the max limit of integrity segments as
+set by block layer which a hardware controller can handle.
+
 max_sectors_kb (RW)
 -------------------
 This is the maximum number of kilobytes that the block layer will allow
 for a filesystem request. Must be smaller than or equal to the maximum
 size allowed by the hardware.
 
+max_segments (RO)
+-----------------
+Maximum number of segments of the device.
+
+max_segment_size (RO)
+---------------------
+Maximum segment size of the device.
+
+minimum_io_size (RO)
+--------------------
+This is the smallest preferred io size reported by the device.
+
 nomerges (RW)
 -------------
 This enables the user to disable the lookup logic involved with IO
@@ -38,11 +89,24 @@ read or write requests. Note that the total allocated number may be twice
 this amount, since it applies only to reads or writes (not the accumulated
 sum).
 
+optimal_io_size (RO)
+--------------------
+This is the optimal io size reported by the device.
+
+physical_block_size (RO)
+------------------------
+This is the physical block size of device, in bytes.
+
 read_ahead_kb (RW)
 ------------------
 Maximum number of kilobytes to read-ahead for filesystems on this block
 device.
 
+rotational (RW)
+---------------
+This file is used to stat if the device is of rotational type or
+non-rotational type.
+
 rq_affinity (RW)
 ----------------
 If this option is '1', the block layer will migrate request completions to the
-- 
1.7.9.5

