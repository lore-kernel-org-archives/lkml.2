Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab1AZXbW (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 18:31:22 -0500
Received: from smtp-out.google.com ([74.125.121.67]:4768 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754397Ab1AZXbV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 18:31:21 -0500
From: Mandeep Singh Baines <msb@chromium.org>
To: gregkh@suse.de, rjw@sisk.pl, mingo@redhat.com, akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH v1 0/6] Set printk priority level
Date: Wed, 26 Jan 2011 15:29:24 -0800
Message-Id: <1296084570-31453-1-git-send-email-msb@chromium.org>
X-Mailer: git-send-email 1.7.3.1
In-Reply-To: <20110125235700.GR8008@google.com>
References: <20110125235700.GR8008@google.com>
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We've been burned by regressions/bugs which we later realized could
have been triaged quicker if only we'd paid closer attention to
dmesg.

This patch series fixes printk()s which appear in the logs of the
device I'm currently working on. I'd love to fix all such printks
but there are hundreds of files and thousands of LOC affected:

$ find . -name \*.c | xargs fgrep -c "printk(\"" | wc -l
16237
$ find . -name \*.c | xargs fgrep "printk(\"" | wc -l
20745

[PATCH 1/6] mm/page_alloc: use appropriate printk priority level
[PATCH 2/6] arch/x86: use appropriate printk priority level
[PATCH 3/6] PM: use appropriate printk priority level
[PATCH 4/6] TTY: use appropriate printk priority level
[PATCH 5/6] fs: use appropriate printk priority level
[PATCH 6/6] taskstats: use appropriate printk priority level
