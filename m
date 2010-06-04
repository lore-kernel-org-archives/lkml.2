Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757052Ab0FDB1G (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jun 2010 21:27:06 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:46697 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756779Ab0FDB1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jun 2010 21:27:04 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 4 Jun 2010 10:22:46 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>
Subject: Re: [BUGFIX][PATCH] memcg fix wake up in oom wait queue
Message-Id: <20100604102246.c37858fb.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100604100811.31c45828.nishimura@mxp.nes.nec.co.jp>
References: <20100603172353.b5375879.kamezawa.hiroyu@jp.fujitsu.com>
	<20100604100811.31c45828.nishimura@mxp.nes.nec.co.jp>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 4 Jun 2010 10:08:11 +0900
Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp> wrote:

> On Thu, 3 Jun 2010 17:23:53 +0900, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:
> > Very sorry that my test wasn't enough and delayed.
> > 
> > ==
> > From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
> > 
> > OOM-waitqueue should be waken up when oom_disable is canceled.
> > This is a fix for
> >  memcg-oom-kill-disable-and-oom-status.patch
> > 
> > How to test:
> >  Create a cgroup A...
> >  1. set memory.limit and memory.memsw.limit to be small value
> >  2. echo 1 > /cgroup/A/memory.oom_control, this disables oom-kill.
> >  3. run a program which must cause OOM.
> > 
> > A program executed in 3 will sleep by oom_waiqueue in memcg.
> > Then, how to wake it up is problem.
> > 
> >  1. echo 0 > /cgroup/A/memory.oom_control (enable OOM-killer)
> >  2. echo big mem > /cgroup/A/memory.memsw.limit_in_bytes(allow more swap)
> > etc..
> > 
> > Without the patch, a task in slept can not be waken up.
> > 
> 
> Acked-by: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>
> 
Thanks. I'll try to rebase this onto the latest mmotm.

-Kame

