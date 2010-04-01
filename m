Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756324Ab0DABwx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 21:52:53 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:47140 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752247Ab0DABwv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 21:52:51 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 1 Apr 2010 10:48:59 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Rik van Riel <riel@redhat.com>
Cc: Larry Woodman <lwoodman@redhat.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
       "kamezawa.hiroyu@jp.fujitsu.com" <kamezawa.hiroyu@jp.fujitsu.com>,
       "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
       "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Subject: Re: RFC [Patch] Remove
 "please try 'cgroup_disable=memory' option if you don't want memory cgroups"
 printk at boot time.
Message-Id: <20100401104859.e0deeca8.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <4BB38D1A.7050204@redhat.com>
References: <1270049283.3551.281.camel@dhcp-100-19-198.bos.redhat.com>
	<1270050899.3551.283.camel@dhcp-100-19-198.bos.redhat.com>
	<4BB38D1A.7050204@redhat.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 31 Mar 2010 13:57:46 -0400
Rik van Riel <riel@redhat.com> wrote:

> On 03/31/2010 11:54 AM, Larry Woodman wrote:
> > On Wed, 2010-03-31 at 11:28 -0400, Larry Woodman wrote:
> >> We are considering removing this printk at boot time from RHEL because
> >> it will confuse customers, encourage them to change the boot parameters
> >> and generate extraneous support calls.  Its documented in
> >> Documentation/kernel-parameters.txt anyway.  Any thoughts???
> 
> Yeah, that is a strange boot message...
> 
> Acked-by: Rik van Riel <riel@redhat.com>
> 
please CC linux-mm and maintainers.

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

It have been there for a year and I think memory usage by page_cgroup
will not surprise linux kernel users, more.

Assume x86-32.

RHEL allows amount of memory up to 16G, right?

without memcg: memmap uses 32bytes * 16G/4k = 128M.
with memcg:    memmap+page_cgroup uses (32+20) bytes * 16G/4k = 208M.

I thought this may cause OOM in ZONE_NORMAL. Then, I added it when I wrote
original patch. This kind of memory eater can cause trouble when it pops
up suddenly. But I think 'one year' can be an excuse.

Thanks,
-Kame


