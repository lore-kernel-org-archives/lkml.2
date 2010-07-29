Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab0G2Ebz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 00:31:55 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57480 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750979Ab0G2Ebw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 00:31:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 29 Jul 2010 13:27:03 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [RFC][PATCH 1/7][memcg] virtually indexed array library.
Message-Id: <20100729132703.2d53e8a4.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20100729093226.7b899930.kamezawa.hiroyu@jp.fujitsu.com>
References: <20100727165155.8b458b7f.kamezawa.hiroyu@jp.fujitsu.com>
	<20100727165303.7d7d18e9.kamezawa.hiroyu@jp.fujitsu.com>
	<20100728124513.85bfa047.akpm@linux-foundation.org>
	<20100729093226.7b899930.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Jul 2010 09:32:26 +0900
KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> wrote:

> On Wed, 28 Jul 2010 12:45:13 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
 
> > My gut reaction to this sort of thing is "run away in terror".  It
> > encourages kernel developers to operate like lackadaisical userspace
> > developers and to assume that underlying code can perform heroic and
> > immortal feats.  But it can't.  This is the kernel and the kernel is a
> > tough and hostile place and callers should be careful and defensive and
> > take great efforts to minimise the strain they put upon other systems.
> > 
> > IOW, can we avoid doing this?
> > 
> 

I'll use pre-allocated pointer array in the next version. It's simple even
if a bit slow.

==
struct mem_cgroup *mem_cgroups[CONFIG_MAX_MEM_CGROUPS] __read_mostly;
#define id_to_memcg(id)		mem_cgroups[id];
==
But this can use hugepage-mapping-for-kernel...so, can be quick.

Thanks,
-Kame



