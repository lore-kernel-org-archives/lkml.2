Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752967Ab0HBKQN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 06:16:13 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:53260 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751172Ab0HBKQL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 06:16:11 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 2 Aug 2010 19:11:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-mm@kvack.org
Cc: "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        vgoyal@redhat.com, m-ikeda@ds.jp.nec.com, gthelen@google.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [PATCH -mm 0/5] towards I/O aware memory cgroup v3.
Message-Id: <20100802191113.05c982e4.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This is v3. removed terrble garbages from v2 and tested.(no big changes)

Now, it's merge-window and I'll have to maintain this in my box for a while.
I'll continue to update this. Maybe we can make new progress after LinuxCon.
(And I'll be busy for a while.)

This set has 2+1 purposes.
 1. re-desgin struct page_cgroup and makes room for blocckio-cgroup ID.
 2. implement quick updating method for memcg's file stat.
 3. optionally? use spin_lock instead of bit_spinlock.

Plans after this.

 1. check influence of Mel's new writeback method.
    I think we'll see OOM easier. IIUC, memory cgroup needs a thread like kswapd
    to do background writeback or low-high watermark.
    (By this, we can control priority of background writeout thread priority
     by CFS. This is very good.)

 2. implementing dirty_ratio.
    Now, Greg Thelen is working on. One of biggest problems of previous trial was
    update cost of status. I think this patch set can reduce it.

 3. record blockio cgroup's ID.
    Ikeda posted one. IIUC, it requires some consideration on (swapin)readahead
    for assigning IDs. But it seemed to be good in general.

Importance is in this order in my mind. But all aboves can be done in parallel.

Beyond that, some guys has problem with file-cache-control. If it need to use
account migration, we have to take care of races.


Thanks,
-Kame

