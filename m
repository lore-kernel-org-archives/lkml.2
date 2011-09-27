Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752017Ab1I0QuY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 12:50:24 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:51135 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab1I0QuX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 12:50:23 -0400
MIME-Version: 1.0
In-Reply-To: <CANN689G4Z21v6fcF1dt-10CpQp9V42_hGPcPP2d5FChfCon_9Q@mail.gmail.com>
References: <1316230753-8693-1-git-send-email-walken@google.com>
	<CAKTCnzkzdQgut96NZf3Mi2kpOWW7N3qeybets5AHy7Gp8Wj_HQ@mail.gmail.com>
	<CANN689G4Z21v6fcF1dt-10CpQp9V42_hGPcPP2d5FChfCon_9Q@mail.gmail.com>
Date: Tue, 27 Sep 2011 22:20:21 +0530
Message-ID: <CAKTCnzkmwiDcetuNY4yeOgfog39ojQBW9oZF8+THD+Uqshbdwg@mail.gmail.com>
Subject: Re: [PATCH 0/8] idle page tracking / working set estimation
From: Balbir Singh <bsingharora@gmail.com>
To: Michel Lespinasse <walken@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Michael Wolf <mjwolf@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>
>> Sorry, I have trouble parsing this sentence, could you elaborate on "when"?
>
> page_referenced() indicates if a page was accessed since the previous
> page_referenced() call.
>
> page_referenced_kstaled() indicates if a page was accessed since the
> previous page_referenced_kstaled() call.
>
> Both of the functions need to clear PTE young bits; however we don't
> want the two functions to interfere with each other. To achieve this,
> we add two page bits to indicate when a young PTE has been observed by
> one of the functions but not by the other.

OK and this gives different page aging schemes for the same page? Is
this to track state changes

PR1 sees: PTE x young as 0
PR2 sees: PTE x as 1, the rest to 0

so PR1 and PR2 will disagree? Should I be looking deeper in the
patches to understand

Balbir
