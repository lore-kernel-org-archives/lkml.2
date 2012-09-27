Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754065Ab2I0OlR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 10:41:17 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:13215 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754006Ab2I0OlO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 10:41:14 -0400
From: Glauber Costa <glommer@parallels.com>
To: <linux-mm@kvack.org>
Cc: <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Pekka Enberg <penberg@kernel.org>,
        David Rientjes <rientjes@google.com>, Christoph Lameter <cl@linux.com>
Subject: [PATCH 0/4] move slabinfo processing to common code
Date: Thu, 27 Sep 2012 18:37:36 +0400
Message-Id: <1348756660-16929-1-git-send-email-glommer@parallels.com>
X-Mailer: git-send-email 1.7.11.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

This patch moves on with the slab caches commonization, by moving
the slabinfo processing to common code in slab_common.c. It only touches
slub and slab, since slob doesn't create that file, which is protected
by a Kconfig switch.

Enjoy,

Glauber Costa (4):
  move slabinfo processing to slab_common.c
  move print_slabinfo_header to slab_common.c
  slub: move slub internal functions to its header
  sl[au]b: process slabinfo_show in common code

 include/linux/slab_def.h |  10 ++++
 include/linux/slub_def.h |  25 ++++++++++
 mm/slab.c                | 116 ++++++++++-------------------------------------
 mm/slab.h                |  16 +++++++
 mm/slab_common.c         | 109 ++++++++++++++++++++++++++++++++++++++++++++
 mm/slub.c                |  89 ++++--------------------------------
 6 files changed, 193 insertions(+), 172 deletions(-)

-- 
1.7.11.4

