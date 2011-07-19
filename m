Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752121Ab1GSWve (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 18:51:34 -0400
Received: from smtp-out.google.com ([216.239.44.51]:47795 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751139Ab1GSWvc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 18:51:32 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	message-id:user-agent:mime-version:content-type:x-system-of-record;
	b=fqBaIbcX++IhgokdhX3iwIe/koqBmSjhgsbgpzTMpj+aZdSrckZXAblaZYaQmwbDE
	KpZ6BQu96JABuuCjPwPFQ==
Date: Tue, 19 Jul 2011 15:51:12 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 0/3] mm: tmpfs radix_tree swap leftovers
Message-ID: <alpine.LSU.2.00.1107191549540.1593@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's three miscellaneous patches on top of the tmpfs radix_tree swap
work in 3.0-rc6-mm1: an overdue unrelated cleanup in radix_tree_tag_get(),
an unfortunately necessary speedup to tmpfs swapoff, and an attempt to
address your review feedback on the exceptional cases in filemap.c.

1/3 radix_tree: clean away saw_unset_tag leftovers
2/3 tmpfs radix_tree: locate_item to speed up swapoff
3/3 mm: clarify the radix_tree exceptional cases

 include/linux/radix-tree.h |    1 
 lib/radix-tree.c           |  102 ++++++++++++++++++++++++++++++++---
 mm/filemap.c               |   66 +++++++++++++++-------
 mm/mincore.c               |    1 
 mm/shmem.c                 |   50 +++--------------
 5 files changed, 149 insertions(+), 71 deletions(-)

Hugh
