Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753577Ab2I0Ppd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 11:45:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45924 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751601Ab2I0Ppc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 11:45:32 -0400
Message-ID: <5064748A.4020509@redhat.com>
Date: Thu, 27 Sep 2012 11:45:14 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Petr Holasek <pholasek@redhat.com>
CC: Hugh Dickins <hughd@google.com>, Andrea Arcangeli <aarcange@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>,
        Izik Eidus <izik.eidus@ravellosystems.com>,
        David Rientjes <rientjes@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Anton Arapov <anton@redhat.com>
Subject: Re: [PATCH v4] KSM: numa awareness sysfs knob
References: <1348448166-1995-1-git-send-email-pholasek@redhat.com>
In-Reply-To: <1348448166-1995-1-git-send-email-pholasek@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2012 08:56 PM, Petr Holasek wrote:
> Introduces new sysfs boolean knob /sys/kernel/mm/ksm/merge_across_nodes
> which control merging pages across different numa nodes.
> When it is set to zero only pages from the same node are merged,
> otherwise pages from all nodes can be merged together (default behavior).
>
> Typical use-case could be a lot of KVM guests on NUMA machine
> and cpus from more distant nodes would have significant increase
> of access latency to the merged ksm page. Sysfs knob was choosen
> for higher variability when some users still prefers higher amount
> of saved physical memory regardless of access latency.
>
> Every numa node has its own stable & unstable trees because of faster
> searching and inserting. Changing of merge_nodes value is possible only
> when there are not any ksm shared pages in system.
>
> I've tested this patch on numa machines with 2, 4 and 8 nodes and
> measured speed of memory access inside of KVM guests with memory pinned
> to one of nodes with this benchmark:

Acked-by: Rik van Riel <riel@redhat.com>

