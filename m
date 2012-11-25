Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751150Ab2KYGOO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 Nov 2012 01:14:14 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:45033 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750829Ab2KYGON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 Nov 2012 01:14:13 -0500
MIME-Version: 1.0
In-Reply-To: <20121124130419.GA8218@suse.de>
References: <CAJd=RBCzydfXGBPLdkyvKaGZPK9H-pKa1-vk38dnZpeiZM8n3w@mail.gmail.com>
	<20121124130419.GA8218@suse.de>
Date: Sun, 25 Nov 2012 14:14:12 +0800
Message-ID: <CAJd=RBDm8K3UTzY+RHSLnGz+ckx0eEeK4C_NYAiXoiku_PHwog@mail.gmail.com>
Subject: Re: [PATCH 1/3] balancenuma: add stats for huge pmd numa faults
From: Hillf Danton <dhillf@gmail.com>
To: Mel Gorman <mgorman@suse.de>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/24/12, Mel Gorman <mgorman@suse.de> wrote:
> On Sat, Nov 24, 2012 at 12:17:03PM +0800, Hillf Danton wrote:
>> A thp contributes 512 times more than a regular page to numa fault stats,
>> so deserves its own vm event counter. THP migration is also accounted.
>>
>
> I agree and mentioned it needed fixing. I did not create a new counter
> but I properly account for PGMIGRATE_SUCCESS and PGMIGRATE_FAIL now. I
> did not create a new NUMA_PAGE_MIGRATE counter because I didn't feel it
> was necessary. Instead I just do this
>
>         count_vm_events(PGMIGRATE_SUCCESS, HPAGE_PMD_NR);
>
It could be read as: 512 pages are successfully migrated(though at the
cost of actually one page).

>         count_vm_numa_events(NUMA_PAGE_MIGRATE, HPAGE_PMD_NR);
>
ditto, 512 pages go through migration(though actually only one page
takes the hard journey).

That said, in short, the new counters are different and clearer.

Hillf
