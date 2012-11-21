Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752824Ab2KUMp6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 07:45:58 -0500
Received: from mail-vb0-f46.google.com ([209.85.212.46]:65235 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752575Ab2KUMp4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 07:45:56 -0500
MIME-Version: 1.0
In-Reply-To: <alpine.LNX.2.00.1211201947510.985@eggly.anvils>
References: <1353291284-2998-1-git-send-email-mingo@kernel.org>
	<20121119162909.GL8218@suse.de>
	<20121119191339.GA11701@gmail.com>
	<20121119211804.GM8218@suse.de>
	<20121119223604.GA13470@gmail.com>
	<50AC4912.7040503@redhat.com>
	<alpine.LNX.2.00.1211201947510.985@eggly.anvils>
Date: Wed, 21 Nov 2012 20:45:55 +0800
Message-ID: <CAJd=RBDB7dZ1ppAOnfmk_wr37=-QN5DvEe+eub7AnZXC72nWkQ@mail.gmail.com>
Subject: Re: numa/core regressions fixed - more testers wanted
From: Hillf Danton <dhillf@gmail.com>
To: Hugh Dickins <hughd@google.com>
Cc: Rik van Riel <riel@redhat.com>, habanero@linux.vnet.ibm.com,
        Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Mel Gorman <mgorman@suse.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 12:10 PM, Hugh Dickins <hughd@google.com> wrote:
> On Tue, 20 Nov 2012, Rik van Riel wrote:
>> On 11/20/2012 08:54 PM, Andrew Theurer wrote:
>>
>> > I can confirm single JVM JBB is working well for me.  I see a 30%
>> > improvement over autoNUMA.  What I can't make sense of is some perf
>> > stats (taken at 80 warehouses on 4 x WST-EX, 512GB memory):
>>
>> AutoNUMA does not have native THP migration, that may explain some
>> of the difference.

Plus, numa/core is sucking the milk of TLB-flsh-optimization from Rik.

BTW, I want to see results of numa/core without such TLB boosts.

>
> When I made some fixes to the sched/numa native THP migration,
> I did also try porting that (with Hannes's memcg fixes) to AutoNUMA.
>
Thanks a ton;)

> +
> +       new_page = alloc_pages_node(numa_node_id(),
> +           (GFP_TRANSHUGE | GFP_THISNODE) & ~__GFP_WAIT, HPAGE_PMD_ORDER);

Such a brand new page is selected to be migration target, why?

Hillf
> +       if (!new_page)
> +               goto alloc_fail;
