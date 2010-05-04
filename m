Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758918Ab0EDMtx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 May 2010 08:49:53 -0400
Received: from keetweej.vanheusden.com ([83.163.219.98]:33452 "EHLO
	keetweej.vanheusden.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752958Ab0EDMtw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 May 2010 08:49:52 -0400
Date: Tue, 4 May 2010 14:49:50 +0200
From: Folkert van Heusden <folkert@vanheusden.com>
To: linux-kernel@vger.kernel.org
Subject: [2.6.32] task hung
Message-ID: <20100504124950.GK29057@vanheusden.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Organization: www.unixexpert.nl
X-Chameleon-Return-To: folkert@vanheusden.com
X-Xfmail-Return-To: folkert@vanheusden.com
X-Phonenumber: +31-6-41278122
X-URL: http://www.vanheusden.com/
X-PGP-KeyID: 1F28D8AE
X-GPG-fingerprint: AC89 09CE 41F2 00B4 FCF2  B174 3019 0E8C 1F28 D8AE
X-Key: http://pgp.surfnet.nl:11371/pks/lookup?op=get&search=0x1F28D8AE
Read-Receipt-To: <folkert@vanheusden.com>
Reply-By: Mon May  3 22:59:23 CEST 2010
X-Message-Flag: www.unixexpert.nl
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I'm copying 6GB of data onto an NBD device using a simple tool which
differs from dd/cat in that it measures how long it takes to write each
block and does a sync after each block.
Now during that run I get:

[45480.665074] INFO: task measurecopy:13780 blocked for more than 120 seconds.
[45480.665086] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[45480.665090] measurecopy   D 0000000000000000     0 13780  30341 0x00000000
[45480.665102]  ffff8801bf06d4c0 0000000000000082 0000000000000000 ffff8801776d9d04
[45480.665116]  0000000000000001 ffff88000000f640 000000000000f8a0 ffff8801776d9fd8
[45480.665129]  00000000000155c0 00000000000155c0 ffff8801a867d4c0 ffff8801a867d7b8
[45480.665143] Call Trace:
[45480.665153]  [<ffffffff8106beb9>] ? ktime_get_ts+0x68/0xb2
[45480.665159]  [<ffffffff81098f06>] ? delayacct_end+0x74/0x7f
[45480.665168]  [<ffffffff810b3219>] ? sync_page+0x0/0x46
[45480.665175]  [<ffffffff812edf36>] ? io_schedule+0x73/0xb7
[45480.665181]  [<ffffffff810b325a>] ? sync_page+0x41/0x46
[45480.665186]  [<ffffffff812ee436>] ? __wait_on_bit+0x41/0x70
[45480.665192]  [<ffffffff810b33de>] ? wait_on_page_bit+0x6b/0x71
[45480.665199]  [<ffffffff81064a84>] ? wake_bit_function+0x0/0x23
[45480.665206]  [<ffffffff810baf36>] ? pagevec_lookup_tag+0x1a/0x21
[45480.665212]  [<ffffffff810b3bb4>] ? wait_on_page_writeback_range+0x69/0x11b
[45480.665218]  [<ffffffff810b3d26>] ? filemap_write_and_wait_range+0x43/0x52
[45480.665225]  [<ffffffff8110a176>] ? vfs_fsync_range+0x55/0x9e
[45480.665231]  [<ffffffff8110a23e>] ? do_fsync+0x28/0x39
[45480.665236]  [<ffffffff8110a25d>] ? sys_fdatasync+0xe/0x13
[45480.665243]  [<ffffffff81010b42>] ? system_call_fastpath+0x16/0x1b

command line:
./measurecopy -i /dev/VG01/LVHOME -o /dev/nbd0 -s -b 1048576

http://www.vanheusden.com/measurecopy/


Folkert van Heusden

-- 
Feeling generous? -> http://www.vanheusden.com/wishlist.php
----------------------------------------------------------------------
Phone: +31-6-41278122, PGP-key: 1F28D8AE, www.vanheusden.com
