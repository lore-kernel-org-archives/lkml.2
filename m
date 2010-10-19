Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933572Ab0JSA5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 20:57:31 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48721 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755726Ab0JSA5a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 20:57:30 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Deadlock possibly caused by too_many_isolated.
Cc: kosaki.motohiro@jp.fujitsu.com, Neil Brown <neilb@suse.de>,
        Wu Fengguang <fengguang.wu@intel.com>, Rik van Riel <riel@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "Li, Shaohua" <shaohua.li@intel.com>
In-Reply-To: <20101018154137.90f5325f.akpm@linux-foundation.org>
References: <20101019093142.509d6947@notabene> <20101018154137.90f5325f.akpm@linux-foundation.org>
Message-Id: <20101019095144.A1B0.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue, 19 Oct 2010 09:57:27 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > I think there are two bugs here.
> > The raid1 bug that Torsten mentions is certainly real (and has been around
> > for an embarrassingly long time).
> > The bug that I identified in too_many_isolated is also a real bug and can be
> > triggered without md/raid1 in the mix.
> > So this is not a 'full fix' for every bug in the kernel :-), but it could
> > well be a full fix for this particular bug.
> > 
> 
> Can we just delete the too_many_isolated() logic?  (Crappy comment
> describes what the code does but not why it does it).

if my remember is correct, we got bug report that LTP may makes misterious
OOM killer invocation about 1-2 years ago. because, if too many parocess are in
reclaim path, all of reclaimable pages can be isolated and last reclaimer found
the system don't have any reclaimable pages and lead to invoke OOM killer.
We have strong motivation to avoid false positive oom. then, some discusstion
made this patch.

if my remember is incorrect, I hope Wu or Rik fix me.



