Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757526Ab0ITXRj (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Sep 2010 19:17:39 -0400
Received: from dion.org.ua ([193.104.35.153]:45229 "EHLO dion.org.ua"
	rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org with ESMTP
	id S1754271Ab0ITXRj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Sep 2010 19:17:39 -0400
X-Greylist: delayed 2424 seconds by postgrey-1.27 at vger.kernel.org; Mon, 20 Sep 2010 19:17:38 EDT
Date: Tue, 21 Sep 2010 01:37:00 +0300
From: Dmitry Nezhevenko <dion@inhex.net>
To: linux-kernel@vger.kernel.org
Subject: dm-crypt and huge performance penalty
Message-ID: <20100920223700.GA20507@laptop.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

I've just purchased three HDD drives and tried to setup mdadm RAID5 +
dm-crypt.

What I've found is that dm-crypt reduces storage I/O performance very much
while CPU is not bottleneck.

Firstly I've tried to setup raid5 and then dm-crypt on top of it. After
discovering issue I've tried just raid5 and confirmed that mdadm itself
works as expected. 

And the last idea is to setup three dm-crypt partitions and then raid5 on
top of independently encrypted drives.

So here are my results:

           |  mdadm   | mdadm+dm-crypt | 3 x dm-crypt + mdadm |
Seq. read  | 168 Mb/s | 57 Mb/s        | 119 Mb/s             |
Seq. write | 80 Mb/s  | 36 Mb/s        | 64.4 Mb/s            |


Also here are some results using both dd and bonnie as benchmark:
http://pastebin.com/hwwkRRTd

I'm using 3 x WD1002FAEX-00Z3A0 HDD. SATA controller is just embedded to
m/b:

00:1f.2 IDE interface: Intel Corporation 5 Series/3400 Series Chipset 4
port SATA IDE Controller (rev 06)
00:1f.5 IDE interface: Intel Corporation 5 Series/3400 Series Chipset 2
port SATA IDE Controller (rev 06)
 
dd tests were done using simple dd:
if=/dev/resulting-device of=/dev/zero bs=1m count=512

For Bonnie I've used 50GB reiserfs3 partition on top of resulting device.

Are these numbers expected? They looks really strange for me.

-- 
WBR, Dmitry
