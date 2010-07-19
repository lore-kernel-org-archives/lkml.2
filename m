Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760749Ab0GSRGw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Jul 2010 13:06:52 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:62817 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760719Ab0GSRGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Jul 2010 13:06:44 -0400
From: Eric B Munson <emunson@mgebm.net>
To: akpm@linux-foundation.org
Cc: mingo@redhat.com, hugh.dickins@tiscali.co.uk, riel@redhat.com,
        peterz@infradead.org, anton@samba.org, hch@infradead.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Eric B Munson <emunson@mgebm.net>
Subject: [PATCH 0/2 V2] Add trace points to [m|mun|mre]map and brk
Date: Mon, 19 Jul 2010 18:06:32 +0100
Message-Id: <cover.1279558781.git.emunson@mgebm.net>
X-Mailer: git-send-email 1.7.0.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch set is a resubmit of several patches I sent out earlier that adds
trace points to the mmap family.  These events report addresses and sizes when
each function returns success.  They will be used by a userspace tool that will model memory usage.

Changes from V1:
- Group mmap, munmap, and brk into first patch (all in mmap.c) and mremap into
  second (in mremap.c)
- Use DEFINE_EVENT_CLASS and DEFINE_EVENT for mmap and brk events

Eric B Munson (2):
  Add trace points to mmap, munmap, and brk
  Add mremap trace point

 include/trace/events/mm.h |   97 +++++++++++++++++++++++++++++++++++++++++++++
 mm/mmap.c                 |   15 ++++++-
 mm/mremap.c               |    4 ++
 3 files changed, 115 insertions(+), 1 deletions(-)
 create mode 100644 include/trace/events/mm.h

