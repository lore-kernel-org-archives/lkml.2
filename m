Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab1FIWbW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jun 2011 18:31:22 -0400
Received: from smtp-out.google.com ([216.239.44.51]:13750 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756796Ab1FIWbU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jun 2011 18:31:20 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=date:from:x-x-sender:to:cc:subject:message-id:user-agent
         :mime-version:content-type;
        b=Xc9cq7INoxbaeGLZL14jT/Rd63Wo6IBBSOaQpHvf+JjjrHxABccSfW2aJ6Ue8Ni5wK
         aDY9eR+X9jmh1cbHaZzQ==
Date: Thu, 9 Jun 2011 15:30:53 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: [PATCH 0/7] tmpfs: simplify by splice instead of readpage
Message-ID: <alpine.LSU.2.00.1106091529060.2200@sister.anvils>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's a second patchset for mmotm, based on 30-rc2 plus the 14
in mm tmpfs and trunc changes, which were preparation for this.

Add shmem_file_splice_read(), remove shmem_readpage(), and
simplify: before advancing to the interesting radix_tree
conversion in the final patchset, to follow in a few days.

1/7 tmpfs: clone shmem_file_splice_read
2/7 tmpfs: refine shmem_file_splice_read
3/7 tmpfs: pass gfp to shmem_getpage_gfp
4/7 tmpfs: remove shmem_readpage
5/7 tmpfs: simplify prealloc_page
6/7 tmpfs: simplify filepage/swappage
7/7 tmpfs: simplify unuse and writepage

 fs/splice.c            |    4 
 include/linux/splice.h |    2 
 mm/shmem.c             |  549 ++++++++++++++++++++-------------------
 3 files changed, 299 insertions(+), 256 deletions(-)

Hugh
