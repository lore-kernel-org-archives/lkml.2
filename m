Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757994Ab0JTDuT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 23:50:19 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:42554 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757361Ab0JTDuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 23:50:16 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 20 Oct 2010 12:44:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 09/11] memcg: add cgroupfs interface to memcg dirty
 limits
Message-Id: <20101020124445.5a3f9e37.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101020123110.fd269ab4.nishimura@mxp.nes.nec.co.jp>
References: <1287448784-25684-1-git-send-email-gthelen@google.com>
	<1287448784-25684-10-git-send-email-gthelen@google.com>
	<20101020123110.fd269ab4.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Oct 2010 12:31:10 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Mon, 18 Oct 2010 17:39:42 -0700
> Greg Thelen <gthelen@google.com> wrote:
> 
> > Add cgroupfs interface to memcg dirty page limits:
> >   Direct write-out is controlled with:
> >   - memory.dirty_ratio
> >   - memory.dirty_limit_in_bytes
> > 
> >   Background write-out is controlled with:
> >   - memory.dirty_background_ratio
> >   - memory.dirty_background_limit_bytes
> > 
> > Other memcg cgroupfs files support 'M', 'm', 'k', 'K', 'g'
> > and 'G' suffixes for byte counts.  This patch provides the
> > same functionality for memory.dirty_limit_in_bytes and
> > memory.dirty_background_limit_bytes.
> > 
> > Signed-off-by: Andrea Righi <arighi@develer.com>
> > Signed-off-by: Balbir Singh <balbir@linux.vnet.ibm.com>
> > Signed-off-by: Greg Thelen <gthelen@google.com>
> 
> Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
> One question: shouldn't we return -EINVAL when writing to dirty(_background)_limit_bytes
> a bigger value than that of global one(if any) 

This should be checked. I'm now writing one add-on.

> ? Or do you intentionally
> set the input value without comparing it with the global value ?

please see my patch sent(memcg+dirtylimit] Fix  overwriting global vm dirty limit setting by memcg)

IMHO, check at setting value is not helpful because global value can be changed
after we set this. My patch checks it at calculating dirtyable bytes.


> But, hmm..., IMHO we should check it in __mem_cgroup_dirty_param() or something
> not to allow dirty pages more than global limit.
> 
yes.

Thanks,
-Kame

