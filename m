Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760951Ab1LPW4G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Dec 2011 17:56:06 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58877 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752634Ab1LPW4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Dec 2011 17:56:01 -0500
Date: Fri, 16 Dec 2011 14:56:00 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mgorman@suse.de>
Cc: Andrea Arcangeli <aarcange@redhat.com>,
        Minchan Kim <minchan.kim@gmail.com>, Dave Jones <davej@redhat.com>,
        Jan Kara <jack@suse.cz>, Andy Isaacson <adi@hexapodia.org>,
        Johannes Weiner <jweiner@redhat.com>, Rik van Riel <riel@redhat.com>,
        Nai Xia <nai.xia@gmail.com>, Linux-MM <linux-mm@kvack.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/11] Reduce compaction-related stalls and improve
 asynchronous migration of dirty pages v6
Message-Id: <20111216145600.908fc77e.akpm@linux-foundation.org>
In-Reply-To: <1323877293-15401-1-git-send-email-mgorman@suse.de>
References: <1323877293-15401-1-git-send-email-mgorman@suse.de>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 14 Dec 2011 15:41:22 +0000
Mel Gorman <mgorman@suse.de> wrote:

> Short summary: There are severe stalls when a USB stick using VFAT
> is used with THP enabled that are reduced by this series. If you are
> experiencing this problem, please test and report back and considering
> I have seen complaints from openSUSE and Fedora users on this as well
> as a few private mails, I'm guessing it's a widespread issue. This
> is a new type of USB-related stall because it is due to synchronous
> compaction writing where as in the past the big problem was dirty
> pages reaching the end of the LRU and being written by reclaim.
> 
> Am cc'ing Andrew this time and this series would replace
> mm-do-not-stall-in-synchronous-compaction-for-thp-allocations.patch.
> I'm also cc'ing Dave Jones as he might have merged that patch to Fedora
> for wider testing and ideally it would be reverted and replaced by
> this series.

So it appears that the problem is painful for distros and users and
that we won't have this fixed until 3.2 at best, and that fix will be a
difficult backport for distributors of earlier kernels.

To serve those people better, I'm wondering if we should merge
mm-do-not-stall-in-synchronous-compaction-for-thp-allocations now, make
it available for -stable backport and then revert it as part of this
series?   ie: give people a stopgap while we fix it properly?

