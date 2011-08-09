Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750838Ab1HIAMQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Aug 2011 20:12:16 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55363 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab1HIAMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Aug 2011 20:12:15 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 9 Aug 2011 09:04:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Wu Fengguang <fengguang.wu@intel.com>,
        Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 2/2] vmscan: activate executable pages after first usage
Message-Id: <20110809090455.92901845.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <CAEwNFnBojMWL1QRfn_buhwUwMOBRGSUGdWBgmzdt9vsCVmLFmQ@mail.gmail.com>
References: <20110808110658.31053.55013.stgit@localhost6>
	<20110808110659.31053.92935.stgit@localhost6>
	<CAEwNFnBojMWL1QRfn_buhwUwMOBRGSUGdWBgmzdt9vsCVmLFmQ@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 9 Aug 2011 09:02:28 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Mon, Aug 8, 2011 at 8:07 PM, Konstantin Khlebnikov
> <khlebnikov@openvz.org> wrote:
> > Logic added in commit v2.6.30-5507-g8cab475
> > (vmscan: make mapped executable pages the first class citizen)
> > was noticeably weakened in commit v2.6.33-5448-g6457474
> > (vmscan: detect mapped file pages used only once)
> >
> > Currently these pages can become "first class citizens" only after second usage.
> >
> > After this patch page_check_references() will activate they after first usage,
> > and executable code gets yet better chance to stay in memory.
> >
> > TODO:
> > run some cool tests like in v2.6.30-5507-g8cab475 =)
> >
> > Signed-off-by: Konstantin Khlebnikov <khlebnikov@openvz.org>
> > ---
> 
> It might be a very controversial topic.
> AFAIR, at least, we did when vmscan: make mapped executable pages the
> first class citizen was merged. :)
> 
> You try to change behavior.
> 
> Old : protect *working set* executable page
> New: protect executable page *unconditionally*.
> 

Hmm ? I thought 
Old: protect pages if referenced twice
New: protect executable page if referenced once.

IIUC, ANON is proteced if it's referenced once.

So, this patch changes EXECUTABLE file to the same class as ANON pages.

Anyway, I agree test/measurement is required.

Thanks,
-Kame









