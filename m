Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932286Ab2ITS5y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 14:57:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:22172 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755357Ab2ITSyl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 14:54:41 -0400
Message-ID: <505B6669.2040104@redhat.com>
Date: Thu, 20 Sep 2012 14:54:33 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Mel Gorman <mgorman@suse.de>
CC: Richard Davies <richard@arachsys.com>, Shaohua Li <shli@kernel.org>,
        Avi Kivity <avi@redhat.com>, QEMU-devel <qemu-devel@nongnu.org>,
        KVM <kvm@vger.kernel.org>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/6] mm: compaction: Acquire the zone->lock as late as
 possible
References: <1348149875-29678-1-git-send-email-mgorman@suse.de> <1348149875-29678-4-git-send-email-mgorman@suse.de>
In-Reply-To: <1348149875-29678-4-git-send-email-mgorman@suse.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/20/2012 10:04 AM, Mel Gorman wrote:
> Compactions free scanner acquires the zone->lock when checking for PageBuddy
> pages and isolating them. It does this even if there are no PageBuddy pages
> in the range.
>
> This patch defers acquiring the zone lock for as long as possible. In the
> event there are no free pages in the pageblock then the lock will not be
> acquired at all which reduces contention on zone->lock.
>
> Signed-off-by: Mel Gorman <mgorman@suse.de>

Acked-by: Rik van Riel <riel@redhat.com>

