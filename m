Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755906Ab0JUAQB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 20:16:01 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:52795 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751090Ab0JUAQA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 20:16:00 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 21 Oct 2010 09:10:29 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Minchan Kim <minchan.kim@gmail.com>
Cc: Greg Thelen <gthelen@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        containers@lists.osdl.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>
Subject: Re: [PATCH v2][memcg+dirtylimit] Fix  overwriting global vm dirty
 limit setting by memcg (Re: [PATCH v3 00/11] memcg: per cgroup dirty page
 accounting
Message-Id: <20101021091029.48082934.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101020143515.GB5243@barrios-desktop>
References: <1287448784-25684-1-git-send-email-gthelen@google.com>
	<20101020122144.47f2b60b.kamezawa.hiroyu@jp.fujitsu.com>
	<20101020140255.5b8afb63.kamezawa.hiroyu@jp.fujitsu.com>
	<20101020143515.GB5243@barrios-desktop>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 20 Oct 2010 23:35:15 +0900
Minchan Kim <minchan.kim@gmail.com> wrote:

> On Wed, Oct 20, 2010 at 02:02:55PM +0900, KAMEZAWA Hiroyuki wrote:
> > Fixed one here.
> > ==
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > Now, at calculating dirty limit, vm_dirty_param() is called.
> > This function returns dirty-limit related parameters considering
> > memory cgroup settings.
> > 
> > Now, assume that vm_dirty_bytes=100M (global dirty limit) and
> > memory cgroup has 1G of pages and 40 dirty_ratio, dirtyable memory is
> > 500MB.
> > 
> > In this case, global_dirty_limits will consider dirty_limt as
> > 500 *0.4 = 200MB. This is bad...memory cgroup is not back door.
> > 
> > This patch limits the return value of vm_dirty_param() considring
> > global settings.
> > 
> > Changelog:
> >  - fixed an argument "mem" int to u64
> >  - fixed to use global available memory to cap memcg's value.
> > 
> > Signed-off-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> Reviewed-by: Minchan Kim <minchan.kim@gmail.com>
> 
> It should have written this on Documentation.
> "memcg dirty limit can't exceed global dirty limit"
> 
Sure. Anyway we need review & rewrite Documenation after dirty limit
merged. (I think Greg will do much.)

Thanks,
-Kame

