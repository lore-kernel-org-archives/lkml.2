Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751923Ab0EJOuS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 10:50:18 -0400
Received: from dion.org.ua ([193.104.35.153]:46539 "EHLO dion.org.ua"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751657Ab0EJOuQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 10:50:16 -0400
X-Greylist: delayed 2478 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 May 2010 10:50:15 EDT
Date: Mon, 10 May 2010 17:08:49 +0300
From: Dmitry Nezhevenko <dion@inhex.net>
To: linux-kernel@vger.kernel.org
Subject: Resierfs random corruptions (probably related to cryptsetup or LVM)
Message-ID: <20100510140849.GA30627@laptop.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm experiencing some strange messages in kernel log:

[79096.365936] REISERFS warning: reiserfs-5090 is_tree_node: node level
32768 does not match to the expected one 1
[79096.365946] REISERFS error (device dm-3): vs-5150 search_by_key:
invalid format found in block 885035. Fsck?
[79096.365952] REISERFS (device dm-3): Remounting filesystem read-only
[79096.365961] REISERFS error (device dm-3): vs-13070
reiserfs_read_locked_inode: i/o failure occurred trying to find stat data
of [6413 109227 0x0 SD]

Hardware is an ASUS F6A laptop with one ST9250320AS HDD. It's configured
cryptsetup device with LUKS key and LVM on top of it. According to SMART
everything is okay with HDD, Reallocated_Sector_Ct is zero.

This happens very rarely (once per month)  so I don't know a way to reproduce 
it. Just reboot with fsck fixes it for a while. Also it looks that exact
volume is not important. This it happens with /usr but iirc same was with
/home (same LVM volume group).

I've googled and found some related threads here but related to ~2.6.19 kernel.
But currently I'm using debian's 2.6.32. 

Any ideas? 

-- 
WBR, Dmitry
