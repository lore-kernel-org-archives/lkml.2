Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934285Ab2GLV1w (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 17:27:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44567 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934268Ab2GLV1t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 17:27:49 -0400
Message-ID: <4FFF40D8.10000@redhat.com>
Date: Thu, 12 Jul 2012 17:25:44 -0400
From: Rik van Riel <riel@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Andrea Arcangeli <aarcange@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Hillf Danton <dhillf@gmail.com>, Dan Smith <danms@us.ibm.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Paul Turner <pjt@google.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        Mike Galbraith <efault@gmx.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Bharata B Rao <bharata.rao@gmail.com>,
        Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Christoph Lameter <cl@linux.com>, Alex Shi <alex.shi@intel.com>,
        Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Don Morris <don.morris@hp.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [PATCH 28/40] autonuma: make khugepaged pte_numa aware
References: <1340888180-15355-1-git-send-email-aarcange@redhat.com> <1340888180-15355-29-git-send-email-aarcange@redhat.com> <4FF12284.4040109@redhat.com> <20120712185031.GN20382@redhat.com>
In-Reply-To: <20120712185031.GN20382@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/12/2012 02:50 PM, Andrea Arcangeli wrote:
> On Mon, Jul 02, 2012 at 12:24:36AM -0400, Rik van Riel wrote:
>> On 06/28/2012 08:56 AM, Andrea Arcangeli wrote:
>>> If any of the ptes that khugepaged is collapsing was a pte_numa, the
>>> resulting trans huge pmd will be a pmd_numa too.
>>
>> Why?
>>
>> If some of the ptes already got faulted in and made really
>> resident again, why do you want to incur a new NUMA fault
>> on the newly collapsed hugepage?
>
> If we don't set pmd_numa on the collapsed hugepage, the result is that
> we'll understimate the thread NUMA affinity to the node where the
> hugepage is located (mm affinity is recorded independently by the NUMA
> hinting page faults).
>
> If it's better or worse I guess depends on luck, we just lose
> information.

Fair enough.




