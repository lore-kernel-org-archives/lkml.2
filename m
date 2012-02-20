Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753600Ab2BTMUa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Feb 2012 07:20:30 -0500
Received: from mx1.redhat.com ([209.132.183.28]:58872 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750784Ab2BTMU2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Feb 2012 07:20:28 -0500
Date: Mon, 20 Feb 2012 13:20:22 +0100
From: Karel Zak <kzak@redhat.com>
To: Neil Brown <neilb@suse.de>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
Subject: MD and rotational attribute
Message-ID: <20120220122022.GA7466@x2.net.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2011-07-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Neil,

I guess that something is wrong with MD. If you create a RAID on ssd
(or scsi_debug in my example) than MD device is reported as rotational.
Simple example:

 modprobe scsi_debug dev_size_mb=500
 fdisk /dev/sdb
 ...
 mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sdb{1,2}

 # cat /sys/block/sdb/queue/rotational
 0
 # cat /sys/block/md0/queue/rotational
 1

It seems like a bug.

    Karel

-- 
 Karel Zak  <kzak@redhat.com>
 http://karelzak.blogspot.com
