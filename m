Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756239Ab2HPKFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 06:05:49 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:50669 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752756Ab2HPKFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 06:05:47 -0400
Message-ID: <502CC477.4060005@gmail.com>
Date: Thu, 16 Aug 2012 11:59:19 +0200
From: Marco Stornelli <marco.stornelli@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:13.0) Gecko/20120601 Thunderbird/13.0
MIME-Version: 1.0
To: bharrosh@panasas.com, bhalevy@tonian.com, jack@suse.cz,
        Andrew Morton <akpm@linux-foundation.org>, adilger.kernel@dilger.ca,
        tytso@mit.edu, hirofumi@mail.parknet.co.jp,
        mikulas@artax.karlin.mff.cuni.cz, Al Viro <viro@ZenIV.linux.org.uk>,
        hch@infradead.org, dushistov@mail.ru, osd-dev@open-osd.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        linux-ext4@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>
Subject: [PATCH 0/8] remove lock and unlock super
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

I'm trying to remove the functions lock_super/unlock_super and to push 
the lock into each single fs. Currently these fs use these functions: 
ext3, ext4, fat, hpfs, exofs, sysv, ufs. At the moment I used the more 
conservative approach, I created a new mutex s_lock in the private sb 
info for each fs, so nothing change but a couple of notes:

1) exofs/hpfs: they use lock_super only in one function so the lock 
seems completely not needed and I removed it, do you see collateral effect?

2) fat/ufs: they have already got functions to lock the fs with a mutex, 
I don't know at the moment if a general review of the code can give us 
the possibility to "merge" the locks.

Bugs, comments, review are welcome especially from fs maintainers. Maybe 
this work can be a first cleaning, after that each fs can adjust its 
lock policy.

The patch is against 3.6-rc1.

Marco
