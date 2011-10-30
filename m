Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933186Ab1J3ALS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 20:11:18 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:45167 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932547Ab1J3ALR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 20:11:17 -0400
Message-ID: <4EAC94E1.9030603@gmail.com>
Date: Sun, 30 Oct 2011 02:05:53 +0200
From: Etienne DADA <dadabox@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20111004 Icedove/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: scsi/sr - Impossible to write CDs/DVDs simultaneously (since BKL
 removal ?)
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When burning multiple CDs/DVDs in parallel with multiple SATA drives, 
you can notice that :
- the process is abnormaly slow using cdrskin or wodim (top shows lots 
of I/O wait),
- the discs are burnt one after each other using cdrecord.

A simpler way to touch the problem is running :
$ eject /dev/sr0 & eject /dev/sr1
drives ejects sequentialy, rather than simultaneously as we were used to.


I think this problem arose after the Big Kernel Lock removal.
As far as I can understand the new "sr_mutex" private mutex in 
drivers/scsi/sr.c generates a per-driver locking, where a per-device 
locking would have been far better. I also think other drivers like sg 
are impacted by the same problem.

I am absolutely unable to arrange this, and would be pleased if someone 
competent could work on this.


Please CC me when answering as I'm not subscribing to the list.

Yours,
Étienne DADA
