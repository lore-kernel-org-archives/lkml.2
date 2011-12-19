Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753220Ab1LSUcl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 15:32:41 -0500
Received: from e9.ny.us.ibm.com ([32.97.182.139]:34373 "EHLO e9.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752959Ab1LSUcj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 15:32:39 -0500
Message-ID: <4EEF9F3E.9000107@linux.vnet.ibm.com>
Date: Mon, 19 Dec 2011 12:31:58 -0800
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
References: <1324319919-31720-1-git-send-email-n-horiguchi@ah.jp.nec.com> <1324319919-31720-3-git-send-email-n-horiguchi@ah.jp.nec.com> <4EEF8F85.9010408@gmail.com>
In-Reply-To: <4EEF8F85.9010408@gmail.com>
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
x-cbid: 11121920-7182-0000-0000-0000006BD6A8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/19/2011 11:24 AM, KOSAKI Motohiro wrote:
> (12/19/11 1:38 PM), Naoya Horiguchi wrote:
>> This flag shows that a given pages is a subpage of transparent hugepage.
>> It does not care about whether it is a head page or a tail page, because
>> it's clear from pfn of the target page which you should know when you read
>> /proc/kpageflags.
>>
>> Signed-off-by: Naoya Horiguchi<n-horiguchi@ah.jp.nec.com>
> 
> NAK.
> 
> The detail of transparent hugepage are hidden by design. We hope it
> keep 'transparent'.
> Until any explain why we should expose KPF_THP, we don't agree it.

Transparent shouldn't mean "undebuggable", though. :)

Let's say you profiled a application and the data shows you're missing
the TLB a bunch, but you're also using THP.  This might give you a shot
at figuring out which parts of your application are *TRULY* THP-backed
instead of just the areas you *think* are backed.

I'm not sure there's another way to figure it out at the moment.

