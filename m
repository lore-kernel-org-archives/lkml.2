Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868Ab1GUQEL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 12:04:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:14661 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751571Ab1GUQEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 12:04:10 -0400
From: David Teigland <teigland@redhat.com>
To: linux-kernel@vger.kernel.org
Subject: [PATCH 0/10] dlm patches for 3.1
Date: Thu, 21 Jul 2011 11:03:57 -0500
Message-Id: <1311264247-28129-1-git-send-email-teigland@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

These are the dlm patches for the 3.1 merge.  Three big improvements are:
replacing lock hash table with idr, improving resource hash table lookups,
and replacing the single callback thread with per-lockspace workqueues.


 fs/dlm/ast.c          |  265 ++++++++++++++++++++++---------------------------
 fs/dlm/ast.h          |   15 ++--
 fs/dlm/config.c       |   75 ++++++++++++--
 fs/dlm/config.h       |    2 +-
 fs/dlm/dlm_internal.h |   29 +++---
 fs/dlm/lock.c         |  225 ++++++++++++++++++++++-------------------
 fs/dlm/lockspace.c    |  175 ++++++++++++++++----------------
 fs/dlm/lowcomms.c     |    9 +-
 fs/dlm/memory.c       |   22 +++--
 fs/dlm/memory.h       |    2 +-
 fs/dlm/recoverd.c     |   12 +--
 fs/dlm/user.c         |   12 +-
 12 files changed, 446 insertions(+), 397 deletions(-)


Bryn M. Reeves (1):
      dlm: use vmalloc for hash tables

David Teigland (6):
      dlm: fix kmalloc args
      dlm: keep lkbs in idr
      dlm: improve rsb searches
      dlm: remove deadlock debug print
      dlm: use workqueue for callbacks
      dlm: don't limit active work items

Jesper Juhl (1):
      dlm: don't do pointless NULL check, use kzalloc and fix order of arguments

Masatake YAMATO (2):
      dlm: show addresses in configfs
      dlm: dump address of unknown node


