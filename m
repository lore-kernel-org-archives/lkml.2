Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932242Ab2ITSze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:55:34 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6439 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932166Ab2ITSza (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:55:30 -0400
Message-ID: <505B669A.1000306@redhat.com>
Date: Thu, 20 Sep 2012 14:55:22 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Richard Davies <richard@arachsys.com>, Shaohua Li <shli@kernel.org>,
        Avi Kivity <avi@redhat.com>, QEMU-devel <qemu-devel@nongnu.org>,
        KVM <kvm@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/6] mm: compaction: Cache if a pageblock was scanned
 and no pages were isolated
References: <1348149875-29678-1-git-send-email-mgorman@suse.de> <1348149875-29678-6-git-send-email-mgorman@suse.de>
In-Reply-To: <1348149875-29678-6-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 10:04 AM, Mel Gorman wrote:
> When compaction was implemented it was known that scanning could potentially
> be excessive. The ideal was that a counter be maintained for each pageblock
> but maintaining this information would incur a severe penalty due to a
> shared writable cache line. It has reached the point where the scanning
> costs are an serious problem, particularly on long-lived systems where a
> large process starts and allocates a large number of THPs at the same time.
>
> Instead of using a shared counter, this patch adds another bit to the
> pageblock flags called PG_migrate_skip. If a pageblock is scanned by
> either migrate or free scanner and 0 pages were isolated, the pageblock
> is marked to be skipped in the future. When scanning, this bit is checked
> before any scanning takes place and the block skipped if set.
>
> The main difficulty with a patch like this is "when to ignore the cached
> information?" If it's ignored too often, the scanning rates will still
> be excessive. If the information is too stale then allocations will fail
> that might have otherwise succeeded. In this patch

Big hammer, but I guess it is effective...

Acked-by: Rik van Riel <riel@redhat.com>

