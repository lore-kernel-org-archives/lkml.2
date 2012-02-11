Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711Ab2BKTpE (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Feb 2012 14:45:04 -0500
Received: from kamaji.grokhost.net ([87.117.218.43]:52789 "EHLO
	kamaji.grokhost.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab2BKToY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Feb 2012 14:44:24 -0500
From: Chris Boot <bootc@bootc.net>
To: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        nab@linux-iscsi.org, stefanr@s5r6.in-berlin.de
Subject: [RFC][PATCH 00/13] firewire-sbp-target: FireWire SBP-2 SCSI target
Date: Sat, 11 Feb 2012 19:43:59 +0000
Message-Id: <1328989452-20921-1-git-send-email-bootc@bootc.net>
X-Mailer: git-send-email 1.7.9
In-Reply-To: <4E4BD560.4010806@bootc.net>
References: <4E4BD560.4010806@bootc.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi folks,

Well after lots of work I have a working and generally (at least I think)
sensible starting point for the FireWire target. It appears to work fine in all
the configurations I've tested it against, including Linux and Mac OS X
initiators.

This is not production ready code, and not ready for merging IMO. I know my
locking (or more the lack of it) leaves something to be desired, and I know my
use of atomics and memory barriers is wrong too. Performance is also a bit
meagre and I'm sure it can be improved substantially - I already have some
ideas for things that can be improved.

For testing, I use:

GUID=5254000b8f01e6f6
DIR_ID=abcdef

modprobe firewire-sbp-target
mkdir /sys/kernel/config/target/sbp
mkdir /sys/kernel/config/target/sbp/$GUID
mkdir /sys/kernel/config/target/sbp/$GUID/tpgt_1
mkdir /sys/kernel/config/target/sbp/$GUID/tpgt_1/lun/lun_0
ln -s /sys/kernel/config/target/core/iblock_0/sbptest /sys/kernel/config/target/sbp/$GUID/tpgt_1/lun/lun_0/sbptest
echo $DIR_ID > /sys/kernel/config/target/sbp/$GUID/tpgt_1/directory_id
echo 1 > /sys/kernel/config/target/sbp/$GUID/tpgt_1/enable

Setting the directory_id is optional and something I have only just added, but
it appears to work as planned.

Any and all comments much appreciated.

Thanks,
Chris

-- 
Chris Boot
bootc@bootc.net

