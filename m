Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758940Ab1BPLoQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 06:44:16 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:45794 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755241Ab1BPLoO convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 06:44:14 -0500
Subject: Re: [PATCH] sched: Wholesale removal of sd_idle logic
From: Peter Zijlstra <peterz@infradead.org>
To: Venkatesh Pallipadi <venki@google.com>
Cc: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Paul Turner <pjt@google.com>,
        Mike Galbraith <efault@gmx.de>, Nick Piggin <npiggin@gmail.com>,
        Tim Chen <tim.c.chen@intel.com>, Alex Shi <alex.shi@intel.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>
In-Reply-To: <1297723130-693-1-git-send-email-venki@google.com>
References: <1297473616.2806.16.camel@sbsiddha-MOBL3.sc.intel.com>
	 <1297723130-693-1-git-send-email-venki@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Wed, 16 Feb 2011 12:43:55 +0100
Message-ID: <1297856635.2413.130.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-02-14 at 14:38 -0800, Venkatesh Pallipadi wrote:
> 
> The initial patch here - https://patchwork.kernel.org/patch/532501/
> applies cleanly over the below change and provides a micro-optimization
> for a specific case, where an idle core can pull tasks instead of a
> core with one thread being idle and other thread being busy.
> It will be good to get some data on whether this micro-optimization
> matters or not. 

I would much rather see a solution that solves that problem for the more
generic situation where we lower capacity to 1.

The whole double-balance thing is fairly inherent in the whole design,
and making an exception for just one special case doesn't look right.
