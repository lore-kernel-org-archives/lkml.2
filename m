Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753007Ab1LSU1c (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Dec 2011 15:27:32 -0500
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:44533 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751610Ab1LSU1a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Dec 2011 15:27:30 -0500
Message-ID: <4EEF9E04.1040007@ah.jp.nec.com>
Date: Mon, 19 Dec 2011 15:26:44 -0500
From: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Organization: NEC Corporation
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; ja; rv:1.9.2.24) Gecko/20111103 Thunderbird/3.1.16
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Dec 19, 2011 at 02:24:53PM -0500, KOSAKI Motohiro wrote:
> (12/19/11 1:38 PM), Naoya Horiguchi wrote:
> > This flag shows that a given pages is a subpage of transparent hugepage.
> > It does not care about whether it is a head page or a tail page, because
> > it's clear from pfn of the target page which you should know when you read
> > /proc/kpageflags.
> > 
> > Signed-off-by: Naoya Horiguchi<n-horiguchi@ah.jp.nec.com>
> 
> NAK.
> 
> The detail of transparent hugepage are hidden by design. We hope it
> keep 'transparent'.
> Until any explain why we should expose KPF_THP, we don't agree it.

The reason why I want to know physical address of thp is testing.
I'm working on memory error recovery and writing test code to confirm
that memory recovery really works when an error occurs on thps.
There I need to locate thps on the physical memory.

IMO, transparency in thp means that we need no manual setup to use
it (as a contrast with hugetlbfs,) so it seems to me that exporting
pageflag of thp does not break the design of thp.

Anyway, I should have written the purpose in the patch description.
Thanks for the comment.

Naoya
