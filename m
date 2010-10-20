Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758014Ab0JTDtE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 23:49:04 -0400
Received: from TYO201.gate.nec.co.jp ([202.32.8.193]:58251 "EHLO
	tyo201.gate.nec.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757948Ab0JTDtB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 23:49:01 -0400
Date: Wed, 20 Oct 2010 12:46:59 +0900
From: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Subject: Re: [PATCH v3 09/11] memcg: add cgroupfs interface to memcg dirty
 limits
Message-Id: <20101020124659.526ce56c.nishimura@mxp.nes.nec.co.jp>
In-Reply-To: <20101020123110.fd269ab4.nishimura@mxp.nes.nec.co.jp>
References: <1287448784-25684-1-git-send-email-gthelen@google.com>
	<1287448784-25684-10-git-send-email-gthelen@google.com>
	<20101020123110.fd269ab4.nishimura@mxp.nes.nec.co.jp>
Organization: NEC Soft, Ltd.
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
> a bigger value than that of global one(if any) ? Or do you intentionally
> set the input value without comparing it with the global value ?
> But, hmm..., IMHO we should check it in __mem_cgroup_dirty_param() or something
> not to allow dirty pages more than global limit.
> 
Oh, Kamazawa-san has just send a fix for this problem :)
Please ignore this comment.

Thanks,
Daisuke Nishimura.
