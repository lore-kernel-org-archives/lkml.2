Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754592Ab0KESIC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Nov 2010 14:08:02 -0400
Received: from wine.ocn.ne.jp ([122.1.235.145]:64110 "EHLO smtp.wine.ocn.ne.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752646Ab0KESIA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Nov 2010 14:08:00 -0400
To: cbouatmailru@gmail.com, gregkh@suse.de, kay.sievers@vrfy.org,
        ak@linux.intel.com
Cc: axboe@kernel.dk, shemminger@vyatta.com, ebiederm@xmission.com,
        stern@rowland.harvard.edu, James.Bottomley@suse.de,
        akpm@linux-foundation.org, kuznet@ms2.inr.ac.ru,
        randy.dunlap@oracle.com, tj@kernel.org, davem@davemloft.net,
        perex@perex.cz, tiwai@suse.de, mingo@elte.hu, a.p.zijlstra@chello.nl,
        dhowells@redhat.com, linux-kernel@vger.kernel.org
Subject: [2.6.37-rc1] wait_for_sysfs prints errors.
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Message-Id: <201011060307.GIG13040.OFFJOVHMSFLOtQ@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Sat, 6 Nov 2010 03:07:55 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

I noticed that udevd-event started to print error messages.

  Starting udev: udevd-event[1682]: wait_for_sysfs: waiting for '/sys/devices/pci0000:00/0000:00:10.0/host0/ioerr_cnt' failed
  udevd-event[2103]: wait_for_sysfs: waiting for '/sys/devices/pci0000:00/0000:00:10.0/host0/target0:0:1/ioerr_cnt' failed
  udevd-event[2102]: wait_for_sysfs: waiting for '/sys/devices/pci0000:00/0000:00:10.0/host0/target0:0:0/ioerr_cnt' failed

These error messages are caused by one or more of below commits.
(Sorry, I can't find exact one because I can't boot as of below commits.)

5cfc64ce "base/platform: Safe handling for NULL platform data and resources"
807508c8 "base/platform: Simplifications for NULL platform data/resources handling"
39aba963 "driver core: remove CONFIG_SYSFS_DEPRECATED_V2 but keep it for block devices"

Is this a regression? (Is this an intended change?)

2.6.36 was OK and below is tail of bisection log.

# good: [da0d7f982d538f4a5bcdddb84df4a484a3b1770b] pch_phub: fix build warnings
git bisect good da0d7f982d538f4a5bcdddb84df4a484a3b1770b
# bad: [39aba963d937edb20db7d9d93e6dda5d2adfdcdd] driver core: remove CONFIG_SYSFS_DEPRECATED_V2 but keep it for block devices
git bisect bad 39aba963d937edb20db7d9d93e6dda5d2adfdcdd
# skip: [5cfc64ceb6222aabec640ba76e89529a8fc2c1f0] base/platform: Safe handling for NULL platform data and resources
git bisect skip 5cfc64ceb6222aabec640ba76e89529a8fc2c1f0
# skip: [807508c8ff9af6ce8f25c5ca5f3eb06a8e7d3286] base/platform: Simplifications for NULL platform data/resources handling
git bisect skip 807508c8ff9af6ce8f25c5ca5f3eb06a8e7d3286
# skip: [87544653abe4a03324bc85dae32d5bdaabcfccef] debugfs: mark me as the maintainer
git bisect skip 87544653abe4a03324bc85dae32d5bdaabcfccef

My environment is CentOS 5.5(GCC 4.1.2) i686 with 512MB RAM.

Regards.
