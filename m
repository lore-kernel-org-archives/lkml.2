Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753257Ab1LSU6o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 15:58:44 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:41814 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752988Ab1LSU6m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 15:58:42 -0500
Message-ID: <4EEFA51D.2050707@linux.vnet.ibm.com>
Date: Mon, 19 Dec 2011 12:57:01 -0800
From: Dave Hansen <dave@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.23) Gecko/20110922 Lightning/1.0b2 Thunderbird/3.1.15
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
CC: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>, linux-mm@kvack.org,
        Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH 2/3] pagemap: export KPF_THP
References: <1324319919-31720-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1324319919-31720-3-git-send-email-n-horiguchi@ah.jp.nec.com> <4EEF8F85.9010408@gmail.com> <4EEF9F3E.9000107@linux.vnet.ibm.com> <4EEFA278.7010200@gmail.com>
In-Reply-To: <4EEFA278.7010200@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
x-cbid: 11121920-2398-0000-0000-000002D96B65
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 12:45 PM, KOSAKI Motohiro wrote:
> (12/19/11 3:31 PM), Dave Hansen wrote:
>> Let's say you profiled a application and the data shows you're missing
>> the TLB a bunch, but you're also using THP.  This might give you a shot
>> at figuring out which parts of your application are *TRULY* THP-backed
>> instead of just the areas you *think* are backed.
>>
>> I'm not sure there's another way to figure it out at the moment.
> 
> A snapshot status of THP doesn't help your purpose. I think you need
> perf or similar profiling subsystem enhancement.
>
> Because of, if you've seen KPF_THP at once, It has no guarantee to keep
> hugepages until applications run. Opposite, If you only need rough
> statistics, the best way is to add some new stat to
> /sys/kernel/mm/transparent_hugepage.

But, every single one of the pagemap flags is really just a snapshot
KPF_DIRTY, KPF_LOCKED, etc...  The entire interface is inherently a racy
snapshot, and there's not a whole lot you can do about it.
sys_mincore() has the exact same issues.  But, that does not make them
useless, nor mean they shouldn't be in the kernel.

A tracepoint or something similar to watch for THP promotions or
demotions would be a great addition to this interface.  That way, you at
least have a concept if the data you got has become stale.

