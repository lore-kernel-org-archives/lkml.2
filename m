Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757005Ab0EYNuq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 May 2010 09:50:46 -0400
Received: from smtp.nokia.com ([192.100.122.230]:37320 "EHLO
	mgw-mx03.nokia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753903Ab0EYNuo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 May 2010 09:50:44 -0400
From: Artem Bityutskiy <dedekind1@gmail.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: LKML <linux-kernel@vger.kernel.org>, Jens Axboe <jens.axboe@oracle.com>,
       linux-fsdevel@vger.kernel.org
Subject: [PATCHv4 00/17] kill unnecessary SB sync wake-ups
Date: Tue, 25 May 2010 16:48:55 +0300
Message-Id: <1274795352-3551-1-git-send-email-dedekind1@gmail.com>
X-Mailer: git-send-email 1.6.6.1
X-OriginalArrivalTime: 25 May 2010 13:50:32.0204 (UTC) FILETIME=[3E38E4C0:01CAFC11]
X-Nokia-AV: Clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

last year I attempted to upstream these patches three times with no luck [1].
Here is the fourth attempt.

The problem: the 'sync_supers' kernel thread wakes up every 5 seconds (by
default, this is configurable via '/proc/sys/vm/dirty_writeback_centisecs')
walks all superblocks and synchronizes them. And even when there are no dirty
superblocks, the thread still keeps waking up.

This is a problem for small battery-powered embedded devices, like the Nokia
N900 phone, Android/MeeGo/etc stuff, etc. In these devices it is important
to have as few wake-ups as possible in order to make sure the CPU is sleeping
for as long time as possible, and the battery power is saved.

The following set of patches tries to address this problem by introducing
wrappers for the 's_dirt' flag manipulations, and then making the 'sync_supers'
task wake up only if there is are dirty superblocks.

I've made patches to be per-FS, and added all the FS maintainers to Cc. But if I
submit this series again, I will not Cc the FS maintainers, to lessen the mount
of spam in their mailboxes. Also, I can merge all the "do not use s_dirty flag
directly" patches, if this is preferred.

[1] the previous attempt: http://marc.info/?l=linux-kernel&m=124712270723226&w=2
