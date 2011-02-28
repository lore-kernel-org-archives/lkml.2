Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab1B1Cqr (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 21:46:47 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:47281 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752117Ab1B1Cqq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 21:46:46 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 28 Feb 2011 11:40:18 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Chad Talbott <ctalbott@google.com>,
        Justin TerAvest <teravest@google.com>, Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v5 6/9] memcg: add kernel calls for memcg dirty page
 stats
Message-Id: <20110228114018.390ce291.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110227170143.GE3226@barrios-desktop>
References: <1298669760-26344-1-git-send-email-gthelen@google.com>
	<1298669760-26344-7-git-send-email-gthelen@google.com>
	<20110227170143.GE3226@barrios-desktop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Feb 2011 02:01:43 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Fri, Feb 25, 2011 at 01:35:57PM -0800, Greg Thelen wrote:
 		spin_unlock_irqrestore(&mapping->tree_lock, flags);
> >  	} else {
> > @@ -1365,6 +1368,7 @@ int test_set_page_writeback(struct page *page)
> >  						PAGECACHE_TAG_WRITEBACK);
> >  			if (bdi_cap_account_writeback(bdi))
> >  				__inc_bdi_stat(bdi, BDI_WRITEBACK);
> > +			mem_cgroup_inc_page_stat(page, MEMCG_NR_FILE_WRITEBACK);
> 
> Question:
> Why should we care of BDI_CAP_NO_WRITEBACK?
> 
Hmm, should we do ..
==
        if (!ret) {
                account_page_writeback(page);
+		mem_cgroup_inc_page_stat(page, MEMCG_NR_FILE_WRITEBACL);
	}
==

Thanks,
-Kame

