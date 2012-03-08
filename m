Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751968Ab2CHFcZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Mar 2012 00:32:25 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47731 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751532Ab2CHFcW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Mar 2012 00:32:22 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 8 Mar 2012 14:30:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Johannes Weiner <jweiner@redhat.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/7 v2] mm: rework __isolate_lru_page() file/anon filter
Message-Id: <20120308143034.f3521b1e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <alpine.LSU.2.00.1203061904570.18675@eggly.anvils>
References: <20120229091547.29236.28230.stgit@zurg>
	<20120303091327.17599.80336.stgit@zurg>
	<alpine.LSU.2.00.1203061904570.18675@eggly.anvils>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2012 19:22:21 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> On Sat, 3 Mar 2012, Konstantin Khlebnikov wrote:
> 
> > This patch adds file/anon filter bits into isolate_mode_t,
> > this allows to simplify checks in __isolate_lru_page().
> > 
> > v2:
> > * use switch () instead of if ()
> > * fixed lumpy-reclaim isolation mode
> > 
> > Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> 
> I'm sorry to be messing you around on this one, Konstantin, but...
> 
> (a) if you do go with the switch statements,
> in kernel we align the "case"s underneath the "switch"
> 
> but
> 
> (b) I seem to be at odds with Kamezawa-san, I much preferred your
> original, which did in 2 lines what the switches do in 10 lines.
> And I'd say there's more opportunity for error in 10 lines than 2.
> 
> What does the compiler say (4.5.1 here, OPTIMIZE_FOR_SIZE off)?
>    text	   data	    bss	    dec	    hex	filename
>   17723	    113	     17	  17853	   45bd	vmscan.o.0
>   17671	    113	     17	  17801	   4589	vmscan.o.1
>   17803	    113	     17	  17933	   460d	vmscan.o.2
> 
> That suggests that your v2 is the worst and your v1 the best.
> Kame, can I persuade you to let the compiler decide on this?
> 

Hmm. How about Costa' proposal ? as

int tmp_var = PageActive(page) ? ISOLATE_ACTIVE : ISOLATE_INACTIVE
if (!(mode & tmp_var))
    ret;

Thanks,
-Kame


