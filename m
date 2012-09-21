Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932352Ab2IUVbZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Sep 2012 17:31:25 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42803 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755128Ab2IUVbY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Sep 2012 17:31:24 -0400
Date: Fri, 21 Sep 2012 14:31:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Richard Davies <richard@arachsys.com>, Shaohua Li <shli@kernel.org>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        QEMU-devel <qemu-devel@nongnu.org>, KVM <kvm@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/9] mm: compaction: Abort compaction loop if lock is
 contended or run too long
Message-Id: <20120921143122.5be94b28.akpm@linux-foundation.org>
In-Reply-To: <1348224383-1499-5-git-send-email-mgorman@suse.de>
References: <1348224383-1499-1-git-send-email-mgorman@suse.de>
	<1348224383-1499-5-git-send-email-mgorman@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 21 Sep 2012 11:46:18 +0100
Mel Gorman <mgorman@suse.de> wrote:

> Changelog since V2
> o Fix BUG_ON triggered due to pages left on cc.migratepages
> o Make compact_zone_order() require non-NULL arg `contended'
> 
> Changelog since V1
> o only abort the compaction if lock is contended or run too long
> o Rearranged the code by Andrea Arcangeli.
> 
> isolate_migratepages_range() might isolate no pages if for example when
> zone->lru_lock is contended and running asynchronous compaction. In this
> case, we should abort compaction, otherwise, compact_zone will run a
> useless loop and make zone->lru_lock is even contended.

hm, this appears to be identical to

mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix.patch
mm-compaction-abort-compaction-loop-if-lock-is-contended-or-run-too-long-fix-2.patch

so I simply omitted patches 2, 3 and 4.
