Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933720Ab0J2LXF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Oct 2010 07:23:05 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38411 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932282Ab0J2LXB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Oct 2010 07:23:01 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 29 Oct 2010 20:17:26 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "containers@lists.osdl.org" <containers@lists.osdl.org>,
        Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v4 06/11] memcg: add dirty page accounting
 infrastructure
Message-Id: <20101029201726.370e462b.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101029111300.GB29774@localhost>
References: <1288336154-23256-1-git-send-email-gthelen@google.com>
	<1288336154-23256-7-git-send-email-gthelen@google.com>
	<20101029111300.GB29774@localhost>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 29 Oct 2010 19:13:00 +0800
Wu Fengguang <fengguang.wu@intel.com> wrote:

> On Fri, Oct 29, 2010 at 03:09:09PM +0800, Greg Thelen wrote:
> 
> > +
> > +	case MEMCG_NR_FILE_DIRTY:
> > +		/* Use Test{Set,Clear} to only un/charge the memcg once. */
> > +		if (val > 0) {
> > +			if (TestSetPageCgroupFileDirty(pc))
> > +				val = 0;
> > +		} else {
> > +			if (!TestClearPageCgroupFileDirty(pc))
> > +				val = 0;
> > +		}
> 
> I'm wondering why TestSet/TestClear and even the cgroup page flags for
> dirty/writeback/unstable pages are necessary at all (it helps to
> document in changelog if there are any). For example, VFS will call
> TestSetPageDirty() before calling
> mem_cgroup_inc_page_stat(MEMCG_NR_FILE_DIRTY), so there should be no
> chance of false double counting.
> 

1. flag is necessary for moving accounting information between cgroups
   when account_move() occurs.

2. TestSet... is required because there are always race with page_cgroup_lock()'s
   lock bit.

Thanks,
-Kame

