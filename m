Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753558Ab0DOEc4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Apr 2010 00:32:56 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:45982 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751307Ab0DOEcz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Apr 2010 00:32:55 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Subject: Re: 32GB SSD on USB1.1 P3/700 == ___HELL___ (2.6.34-rc3)
Cc: kosaki.motohiro@jp.fujitsu.com, Andreas Mohr <andi@lisas.de>,
       Jens Axboe <axboe@kernel.dk>, Minchan Kim <minchan.kim@gmail.com>,
       Linux Memory Management List <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       Rik van Riel <riel@redhat.com>
In-Reply-To: <20100415041931.GA14215@localhost>
References: <20100415122928.D168.A69D9226@jp.fujitsu.com> <20100415041931.GA14215@localhost>
Message-Id: <20100415132312.D180.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 15 Apr 2010 13:32:50 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Thu, Apr 15, 2010 at 11:31:52AM +0800, KOSAKI Motohiro wrote:
> > > > Many applications (this one and below) are stuck in
> > > > wait_on_page_writeback(). I guess this is why "heavy write to
> > > > irrelevant partition stalls the whole system".  They are stuck on page
> > > > allocation. Your 512MB system memory is a bit tight, so reclaim
> > > > pressure is a bit high, which triggers the wait-on-writeback logic.
> > > 
> > > I wonder if this hacking patch may help.
> > > 
> > > When creating 300MB dirty file with dd, it is creating continuous
> > > region of hard-to-reclaim pages in the LRU list. priority can easily
> > > go low when irrelevant applications' direct reclaim run into these
> > > regions..
> > 
> > Sorry I'm confused not. can you please tell us more detail explanation?
> > Why did lumpy reclaim cause OOM? lumpy reclaim might cause
> > direct reclaim slow down. but IIUC it's not cause OOM because OOM is
> > only occur when priority-0 reclaim failure.
> 
> No I'm not talking OOM. Nor lumpy reclaim.
> 
> I mean the direct reclaim can get stuck for long time, when we do
> wait_on_page_writeback() on lumpy_reclaim=1.
> 
> > IO get stcking also prevent priority reach to 0.
> 
> Sure. But we can wait for IO a bit later -- after scanning 1/64 LRU
> (the below patch) instead of the current 1/1024.
> 
> In Andreas' case, 512MB/1024 = 512KB, this is way too low comparing to
> the 22MB writeback pages. There can easily be a continuous range of
> 512KB dirty/writeback pages in the LRU, which will trigger the wait
> logic.

In my feeling from your explanation, we need auto adjustment mechanism
instead change default value for special machine. no?



