Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755070Ab2H0X5G (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Aug 2012 19:57:06 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:55600 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754638Ab2H0X5D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Aug 2012 19:57:03 -0400
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <axboe@kernel.dk>,
        Tejun Heo <tj@kernel.org>, Ben Hutchings <ben@decadent.org.uk>,
        Vivek Goyal <vgoyal@redhat.com>, linux-kernel@vger.kernel.org
Subject: Bug fixes/cleanups for floppy driver (v4)
Date: Mon, 27 Aug 2012 20:56:50 -0300
Message-Id: <1346111816-16700-1-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following this are fixes for bugs noticed on floppy driver, and some
extra cleanups. Version history below:

v2: separate fixes, and incorporate suggestions by Vivek Goyal.
    also I splitted the cleanups from fixes.
v3: remove dr, also this possibly makes error handling more readable
    (suggested by by Vivek Goyal), incorporate acks.
v4: re-shuffle series with patch from Ben Hutchings handling the queue
    reference in a better way inside genhd

Patches 1-2 and 4 are general bug fixes for problems noted in the floppy
driver initialization and its error handling. They are the minimal fix
required, so it's suitable and easy to pick for stable releases (so
are Cc'd to stable), and thus not contain cleanups or re-factoring.

Patch 3 is a patch from Ben Hutchings fixing in a better way the extra
queue reference issue that was introduced in commit 523e1d3 ('block:
make gendisk hold a reference to its queue'). Instead of making the
drivers worry about the extra reference, fix it and handle that in a
better way inside genhd. I'm not sure if this should go with the floppy
changes or picked up separate for the block tree. In any case, patch 6
will only apply after it is applied. His patch was proposed with the
previous series I submitted and handles the problem better so I took the
liberty to include now, I just fixed the changelog as was noticed that
time to reference the right commit, and included my ack.

Patch 5 and 6 implements earlier suggested cleanups and enhancements.

-- 
[]'s
Herton
