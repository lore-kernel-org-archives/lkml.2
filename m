Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab0LVNWQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Dec 2010 08:22:16 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:57555 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751863Ab0LVNWM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Dec 2010 08:22:12 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=QSHEW14mmvcwAdHjJgLTuUudxElqGv5vA4k+4/yeFSuKDIzXyLAbnfgDWPmOoLzbrP
         2iXN+BBPJGqUX2RbgETrz9aQXe6u0vOyKffBttuGUE2BHFsEXfYgBKsUBAtv/q5heAgi
         RLgeGZKCt/mCTbDi8cM4x+LpoEeFDvIfB+l54=
Date: Wed, 22 Dec 2010 14:22:08 +0100
From: Tejun Heo <tj@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Mike Travis <travis@sgi.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Len Brown <lenb@kernel.org>,
        Jack Steiner <steiner@sgi.com>, Lori Gilbertson <loriann@sgi.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] percpu: print out alloc information with KERN_DEBUG
 instead of KERN_INFO
Message-ID: <20101222132208.GB8061@htj.dyndns.org>
References: <4D06B317.2090608@sgi.com>
 <20101222130946.GC13412@elte.hu>
 <20101222131719.GA8061@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101222131719.GA8061@htj.dyndns.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now that percpu allocator is mostly stable, there is no reason to
print alloc information with KERN_INFO and clutter the boot messages.
Switch it to KERN_DEBUG.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Mike Travis <travis@sgi.com>
---
Applied to percpu#for-linus.  Will push out in several days.  Thanks.

 mm/percpu.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index efe8168..02ba912 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1268,7 +1268,7 @@ int __init pcpu_setup_first_chunk(const struct pcpu_alloc_info *ai,
 
 	/* we're done parsing the input, undefine BUG macro and dump config */
 #undef PCPU_SETUP_BUG_ON
-	pcpu_dump_alloc_info(KERN_INFO, ai);
+	pcpu_dump_alloc_info(KERN_DEBUG, ai);
 
 	pcpu_nr_groups = ai->nr_groups;
 	pcpu_group_offsets = group_offsets;
-- 
1.7.1

