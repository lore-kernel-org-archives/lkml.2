Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab0G0H4p (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 03:56:45 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:35305 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752477Ab0G0H4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 03:56:44 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Tue, 27 Jul 2010 16:51:55 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: [RFC][PATCH 0/7][memcg] towards I/O aware memory cgroup
Message-Id: <20100727165155.8b458b7f.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


>From a view of patch management, this set is a mixture of a few features for
memcg, and I should divide them to some groups. But, at first, I'd like to
show the total view. This set is consists from 5 sets. Main purpose is
create a room in page_cgroup for I/O tracking and add light-weight access method
for file-cache related accounting. 

1.   An virtual-indexed array.
2,3. Use virtual-indexed array for id-to-memory_cgroup detection.
4.   modify page_cgroup to use ID instead of pointer, this gives us enough
     spaces for further memory tracking.
5,6   Use light-weight locking mechanism for file related accounting.
7.   use spin_lock instead of bit_spinlock.


As a function,  patch 5,6 can be an independent patch and I'll accept
reordering series of patch if someone requests.
But we'll need all, I think.
(irq_save for patch 7 will be required later.)

Any comments are welcome.

Thanks,
-Kame 

