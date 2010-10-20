Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751159Ab0JTEMZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 00:12:25 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57511 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864Ab0JTEMY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 00:12:24 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 20 Oct 2010 13:06:54 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Greg Thelen <gthelen@google.com>
Cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v3 02/11] memcg: document cgroup dirty memory interfaces
Message-Id: <20101020130654.bf861eda.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <xr93r5fl1poc.fsf@ninji.mtv.corp.google.com>
References: <1287448784-25684-1-git-send-email-gthelen@google.com>
	<1287448784-25684-3-git-send-email-gthelen@google.com>
	<20101019172744.45e0a8dc.nishimura@mxp.nes.nec.co.jp>
	<xr93lj5t5245.fsf@ninji.mtv.corp.google.com>
	<20101020091109.ccd7b39a.kamezawa.hiroyu@jp.fujitsu.com>
	<xr93r5fl1poc.fsf@ninji.mtv.corp.google.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 19 Oct 2010 17:45:08 -0700
Greg Thelen <gthelen@google.com> wrote:

> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
> > BTW, how about supporing dirty_limit_in_bytes when use_hierarchy=0 or
> > leave it as broken when use_hierarchy=1 ?  It seems we can only
> > support dirty_ratio when hierarchy is used.
> 
> I am not sure what you mean here.

When using dirty_ratio, we can check the value of dirty_ratio at setting it
and make guarantee that any children's dirty_ratio cannot exceeds it parent's.

If we guarantee that, we can keep dirty_ratio even under hierarchy.

When it comes to dirty_limit_in_bytes, we never able to do such kind of
controls. So, it will be broken and will do different behavior than
dirty_ratio.

So, not supporing dirty_bytes when use_hierarchy==1 for now sounds reasonable to me.

Thanks,
-Kame





