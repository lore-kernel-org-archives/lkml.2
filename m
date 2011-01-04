Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170Ab1ADIeg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jan 2011 03:34:36 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:54048 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751206Ab1ADIef (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jan 2011 03:34:35 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 4 Jan 2011 17:28:33 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Figo.zhang" <zhangtianfei@leadcoretech.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Andrew Morton <akpm@osdl.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Figo.zhang" <figo1802@gmail.com>,
        "rientjes@google.com" <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: [PATCH v3]mm/oom-kill: direct hardware access processes should
 get bonus
Message-Id: <20110104172833.1ff20b41.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4D22D190.1080706@leadcoretech.com>
References: <1288662213.10103.2.camel@localhost.localdomain>
	<1289305468.10699.2.camel@localhost.localdomain>
	<1289402093.10699.25.camel@localhost.localdomain>
	<1289402666.10699.28.camel@localhost.localdomain>
	<4D22D190.1080706@leadcoretech.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Jan 2011 15:51:44 +0800
"Figo.zhang" <zhangtianfei@leadcoretech.com> wrote:

> 
> i had send the patch to protect the hardware access processes for 
> oom-killer before, but rientjes have not agree with me.
> 
> but today i catch log from my desktop. oom-killer have kill my "minicom" 
> and "Xorg". so i think it should add protection about it.
> 

Off topic.

In this log, I found

> > Jan  4 15:22:55 figo-desktop kernel: Free swap  = -1636kB
> > Jan  4 15:22:55 figo-desktop kernel: Total swap = 0kB
> > Jan  4 15:22:55 figo-desktop kernel: 515070 pages RAM

... This means total_swap_pages = 0 while pages are read-in at swapoff.

Let's see 'points' for oom 
==
points = (get_mm_rss(p->mm) + get_mm_counter(p->mm, MM_SWAPENTS)) * 1000 /
                        totalpages;
==

Here, totalpages = total_ram + total_swap but totalswap is 0 here.

So, points can be > 1000, easily.
(This seems not to be related to the Xorg's death itself)



Thanks,
-Kame

