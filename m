Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666Ab1EMJi0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 05:38:26 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52370 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215Ab1EMJiX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 05:38:23 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 13 May 2011 18:31:34 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC][PATCH v7 03/14] memcg: add mem_cgroup_mark_inode_dirty()
Message-Id: <20110513183134.3dfae7f8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1305276473-14780-4-git-send-email-gthelen@google.com>
References: <1305276473-14780-1-git-send-email-gthelen@google.com>
	<1305276473-14780-4-git-send-email-gthelen@google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 13 May 2011 01:47:42 -0700
Greg Thelen <gthelen@google.com> wrote:

> Create the mem_cgroup_mark_inode_dirty() routine, which is called when
> an inode is marked dirty.  In kernels without memcg, this is an inline
> no-op.
> 
> Add i_memcg field to struct address_space.  When an inode is marked
> dirty with mem_cgroup_mark_inode_dirty(), the css_id of current memcg is
> recorded in i_memcg.  Per-memcg writeback (introduced in a latter
> change) uses this field to isolate inodes associated with a particular
> memcg.
> 
> The type of i_memcg is an 'unsigned short' because it stores the css_id
> of the memcg.  Using a struct mem_cgroup pointer would be larger and
> also create a reference on the memcg which would hang memcg rmdir
> deletion.  Usage of a css_id is not a reference so cgroup deletion is
> not affected.  The memcg can be deleted without cleaning up the i_memcg
> field.  When a memcg is deleted its pages are recharged to the cgroup
> parent, and the related inode(s) are marked as shared thus
> disassociating the inodes from the deleted cgroup.
> 
> A mem_cgroup_mark_inode_dirty() tracepoint is also included to allow for
> easier understanding of memcg writeback operation.
> 
> Signed-off-by: Greg Thelen <gthelen@google.com>


Seems simple and handy enough.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


