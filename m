Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754918Ab0LPBAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Dec 2010 20:00:20 -0500
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:55734 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753533Ab0LPBAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Dec 2010 20:00:18 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 16 Dec 2010 09:54:08 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andrea Arcangeli <aarcange@redhat.com>
Cc: linux-mm@kvack.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
        Adam Litke <agl@us.ibm.com>, Avi Kivity <avi@redhat.com>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Rik van Riel <riel@redhat.com>, Mel Gorman <mel@csn.ul.ie>,
        Dave Hansen <dave@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Ingo Molnar <mingo@elte.hu>, Mike Travis <travis@sgi.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Chris Wright <chrisw@sous-sol.org>, bpicco@redhat.com,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Chris Mason <chris.mason@oracle.com>, Borislav Petkov <bp@alien8.de>,
        Miklos Szeredi <miklos@szeredi.hu>
Subject: Re: Transparent Hugepage Support #33
Message-Id: <20101216095408.3a60cbad.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20101215051540.GP5638@random.random>
References: <20101215051540.GP5638@random.random>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Dec 2010 06:15:40 +0100
Andrea Arcangeli <aarcange@redhat.com> wrote:

> Some of some relevant user of the project:
> 
> KVM Virtualization
> GCC (kernel build included, requires a few liner patch to enable)
> JVM
> VMware Workstation
> HPC
> 
> It would be great if it could go in -mm.

Things should be done in memory cgroup is
 
 - make accounting correct (RSS count will be broken)
 - make move_charge() to work
   (at rmdir(), this is now broken. It seems move-charge-at-task-move to work)

Do you have known other viewpoints ? I'll look into when -mm is shipped.


Thanks,
-Kame

