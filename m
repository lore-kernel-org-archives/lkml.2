Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031664Ab2CGAaS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 19:30:18 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:42613 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1031547Ab2CGAaQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 19:30:16 -0500
Message-ID: <4F56AC21.1050000@gmail.com>
Date: Tue, 06 Mar 2012 19:30:25 -0500
From: KOSAKI Motohiro <kosaki.motohiro@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Mikulas Patocka <mpatocka@redhat.com>
CC: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Shaohua Li <shaohua.li@intel.com>, Michal Hocko <mhocko@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, kosaki.motohiro@gmail.com
Subject: Re: [PATCH] fix bug introduced in "mm: simplify find_vma_prev()"
References: <Pine.LNX.4.64.1203041946430.3487@file.rdu.redhat.com>
In-Reply-To: <Pine.LNX.4.64.1203041946430.3487@file.rdu.redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(3/4/12 7:52 PM), Mikulas Patocka wrote:
> Hi
>
> This patch fixes a bug introduced in "mm: simplify find_vma_prev()". You
> can apply this, or alternatively revert the original patch.
>
> Mikulas
>
> ---
>
> mm: fix find_vma_prev
>
> The commit mm: simplify find_vma_prev()
> [6bd4837de96e7d9f9bf33e59117c24fc230862ac] broke memory management on PA-RISC.
>
> After application of the patch, programs that allocate big arrays on the stack
> crash with segfault, for example, this will crash if compiled without
> optimization:
> int main()
> {
> 	char array[200000];
> 	array[199999] = 0;
> 	return 0;
> }
>
> The reason is that PA-RISC has up-growing stack and the stack is usually the
> last memory area. In the above example, a page fault happens above the stack.
>
> Previously, if we passed too high address to find_vma_prev, it returned NULL
> and stored the last VMA in *pprev. After "simplify find_vma_prev" change, it
> stores NULL in *pprev. Consequently, the stack area is not found and it is
> not expanded, as it used to be before the change.
>
> This patch restores the old behavior and makes it return the last VMA in *pprev
> if the requested address is higher than address of any other VMA.
>
> Signed-off-by: Mikulas Patocka<mpatocka@redhat.com>

Acked-by: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>


I prefer to remove find_vma_prev() eventually. but this is good short term solution.
