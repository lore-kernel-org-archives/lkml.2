Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752917Ab1I1Gxz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 02:53:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40311 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751112Ab1I1Gxy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 02:53:54 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 28 Sep 2011 15:53:02 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Michel Lespinasse <walken@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dave Hansen <dave@linux.vnet.ibm.com>, Rik van Riel <riel@redhat.com>,
        Balbir Singh <bsingharora@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <jweiner@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Hugh Dickins <hughd@google.com>, Michael Wolf <mjwolf@us.ibm.com>
Subject: Re: [PATCH 2/9] kstaled: documentation and config option.
Message-Id: <20110928155302.ca394980.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1317170947-17074-3-git-send-email-walken@google.com>
References: <1317170947-17074-1-git-send-email-walken@google.com>
	<1317170947-17074-3-git-send-email-walken@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Sep 2011 17:49:00 -0700
Michel Lespinasse <walken@google.com> wrote:

> Extend memory cgroup documentation do describe the optional idle page
> tracking features, and add the corresponding configuration option.
> 
> 
> Signed-off-by: Michel Lespinasse <walken@google.com>

> +* idle_2_clean, idle_2_dirty_file, idle_2_dirty_swap: same definitions as
> +  above, but for pages that have been untouched for at least two scan cycles.
> +* these fields repeat up to idle_240_clean, idle_240_dirty_file and
> +  idle_240_dirty_swap, allowing one to observe idle pages over a variety
> +  of idle interval lengths. Note that the accounting is cumulative:
> +  pages counted as idle for a given interval length are also counted
> +  as idle for smaller interval lengths.

I'm sorry if you've answered already.

Why 240 ? and above means we have idle_xxx_clean/dirty/ xxx is 'seq 2 240' ?
Isn't it messy ? Anyway, idle_1_clean etc should be provided.

Hmm, I don't like the idea very much...

IIUC, there is no kernel interface which shows histgram rather than load_avg[].
Is there any other interface and what histgram is provided ?
And why histgram by kernel is required ? 

BTW, can't this information be exported by /proc/<pid>/smaps or somewhere ?
I guess per-proc will be wanted finally. 


Hm, do you use params other than idle_clean for your scheduling ?

Thanks,
-Kame

