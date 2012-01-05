Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932563Ab2AEOkZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jan 2012 09:40:25 -0500
Received: from cantor2.suse.de ([195.135.220.15]:39836 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932545Ab2AEOkW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jan 2012 09:40:22 -0500
From: Jan Kara <jack@suse.cz>
To: linux-fsdevel@vger.kernel.org
Cc: linux-ext4@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Christoph Hellwig <hch@infradead.org>,
        Al Viro <viro@ZenIV.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>,
        Edward Shishkin <edward@redhat.com>
Subject: [RFC PATCH 0/3] Stop clearing uptodate flag on write IO error
Date: Thu,  5 Jan 2012 15:40:04 +0100
Message-Id: <1325774407-28531-1-git-send-email-jack@suse.cz>
X-Mailer: git-send-email 1.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  Hello,

  for mostly historical reasons we still clear buffer_uptodate flag on write
IO errors. This is not only semantically wrong (buffer still has correct data
in it) but it also triggers warnings in mark_buffer_dirty when buffer is
written again which scares lots of users (as they tend to unplug USB sticks
too early). This patch series is an attempt to start solving the problem
by allowing filesystem to tell whether it wishes buffer_uptodate flag cleared
on write IO error. Ext2 is converted to use this as an example. Eventually
when all filesystems are converted, we can remove the condition.

Do people think this is a desirable way to go?

								Honza
