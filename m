Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab1A1IYR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 03:24:17 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:40727 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754947Ab1A1IYQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 03:24:16 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 28 Jan 2011 17:17:44 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: balbir@linux.vnet.ibm.com
Cc: Minchan Kim <minchan.kim@gmail.com>, linux-mm@kvack.org,
        akpm@linux-foundation.org, npiggin@kernel.dk, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, kosaki.motohiro@jp.fujitsu.com,
        cl@linux.com
Subject: Re: [PATCH 3/3] Provide control over unmapped pages (v4)
Message-Id: <20110128171744.b7b37703.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <20110128081928.GC5054@balbir.in.ibm.com>
References: <20110125051003.13762.35120.stgit@localhost6.localdomain6>
	<20110125051015.13762.13429.stgit@localhost6.localdomain6>
	<AANLkTikHLw0Qg+odOB-bDtBSB-5UbTJ5ZOM-ZAdMqXgh@mail.gmail.com>
	<AANLkTi=qXsDjN5Jp4m3QMgVnckoAM7uE9_Hzn6CajP+c@mail.gmail.com>
	<AANLkTinfxXc04S9VwQcJ9thFff=cP=icroaiVLkN-GeH@mail.gmail.com>
	<20110128064851.GB5054@balbir.in.ibm.com>
	<AANLkTikw_j0JJVqEsj1xThoashiOARg+8BgcLKrvkV3U@mail.gmail.com>
	<20110128165605.3cbe5208.kamezawa.hiroyu@jp.fujitsu.com>
	<20110128081928.GC5054@balbir.in.ibm.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 28 Jan 2011 13:49:28 +0530
Balbir Singh <balbir@linux.vnet.ibm.com> wrote:

> * KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> [2011-01-28 16:56:05]:
 
> > BTW, it seems this doesn't work when some apps use huge shmem.
> > How to handle the issue ?
> >
> 
> Could you elaborate further? 
> 
==
static inline unsigned long zone_unmapped_file_pages(struct zone *zone)
{
        unsigned long file_mapped = zone_page_state(zone, NR_FILE_MAPPED);
        unsigned long file_lru = zone_page_state(zone, NR_INACTIVE_FILE) +
                zone_page_state(zone, NR_ACTIVE_FILE);

        /*
         * It's possible for there to be more file mapped pages than
         * accounted for by the pages on the file LRU lists because
         * tmpfs pages accounted for as ANON can also be FILE_MAPPED
         */
        return (file_lru > file_mapped) ? (file_lru - file_mapped) : 0;
}
==

Did you read ?

Thanks,
-Kame

