Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756828Ab2DFAgP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Apr 2012 20:36:15 -0400
Received: from forward18.mail.yandex.net ([95.108.253.143]:54381 "EHLO
	forward18.mail.yandex.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756469Ab2DFAgK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Apr 2012 20:36:10 -0400
X-Greylist: delayed 407 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Apr 2012 20:36:10 EDT
From: Alexey Ivanov <rbtz@yandex-team.ru>
To: linux-kernel@vger.kernel.org
Subject: mapped pagecache pages vs unmapped pages
MIME-Version: 1.0
Message-Id: <37371333672160@webcorp7.yandex-team.ru>
Date: Fri, 06 Apr 2012 04:29:20 +0400
X-Mailer: Yamail [ http://yandex.ru ] 5.0
Content-Transfer-Encoding: 7bit
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In progress of migration from FreeBSD to Linux and we found some strange behavior: periodically running tasks (like rsync/p2p deployment) evict mapped pages from memory.

>From my little research I've found following lkml thread:
https://lkml.org/lkml/2008/6/11/278
And more precisely this commit: https://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commit;h=4f98a2fee8acdb4ac84545df98cccecfd130f8db
which along with splitting LRU into "anon" and "file" removed support of reclaim_mapped.

Is there a knob to prioritize mapped memory over unmapped (without modifying all apps to use O_DIRECT/fadvise/madvise or mlocking our data in memory) or at least some way to change proportion of Active(file)/Inactive(file)?

-- 
Sincerely,
Alexey Ivanov
