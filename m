Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751439Ab0JTET5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 00:19:57 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:43680 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750902Ab0JTET5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 00:19:57 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 20 Oct 2010 13:14:27 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH][memcg+dirtylimit] Fix  overwriting global vm dirty
 limit setting by memcg (Re: [PATCH v3 00/11] memcg: per cgroup dirty page
 accounting
Message-Id: <20101020131427.a4998c33.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101020122144.47f2b60b.kamezawa.hiroyu@jp.fujitsu.com>
References: <1287448784-25684-1-git-send-email-gthelen@google.com>
	<20101020122144.47f2b60b.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Oct 2010 12:21:44 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> 
> One bug fix here.
> ==
> From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> 
> Now, at calculating dirty limit, vm_dirty_param() is called.
> This function returns dirty-limit related parameters considering
> memory cgroup settings.
> 
> Now, assume that vm_dirty_bytes=100M (global dirty limit) and
> memory cgroup has 1G of pages and 40 dirty_ratio, dirtyable memory is
> 500MB.
> 
> In this case, global_dirty_limits will consider dirty_limt as
> 500 *0.4 = 200MB. This is bad...memory cgroup is not back door.
> 
> This patch limits the return value of vm_dirty_param() considring
> global settings.
> 
> 

Sorry, this one is buggy. I'll post a new one later.

Thanks,
-Kame

