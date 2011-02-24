Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755077Ab1BXATS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 19:19:18 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58384 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751186Ab1BXATR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 19:19:17 -0500
Date: Wed, 23 Feb 2011 16:18:18 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mel Gorman <mel@csn.ul.ie>
Cc: Petr Holasek <pholasek@redhat.com>, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Wu Fengguang <fengguang.wu@intel.com>, linux-mm@kvack.org
Subject: Re: [PATCH] hugetlbfs: correct handling of negative input to
 /proc/sys/vm/nr_hugepages
Message-Id: <20110223161818.9876cc10.akpm@linux-foundation.org>
In-Reply-To: <20110222100235.GA15652@csn.ul.ie>
References: <1298303270-3184-1-git-send-email-pholasek@redhat.com>
	<20110222100235.GA15652@csn.ul.ie>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 22 Feb 2011 10:02:36 +0000
Mel Gorman <mel@csn.ul.ie> wrote:

> On Mon, Feb 21, 2011 at 04:47:49PM +0100, Petr Holasek wrote:
> > When user insert negative value into /proc/sys/vm/nr_hugepages it will result
> > in the setting a random number of HugePages in system (can be easily showed
> > at /proc/meminfo output).
> 
> I bet you a shiny penny that the value of HugePages becomes the maximum
> number that could be allocated by the system at the time rather than a
> random value.

That seems to be the case from my reading.  In which case the patch
removes probably-undocumented and possibly-useful existing behavior.

