Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751423Ab0HTKBC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 06:01:02 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:41135 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab0HTKBA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 06:01:00 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 20 Aug 2010 18:55:52 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: linux-mm@kvack.org
Cc: "nishimura@mxp.nes.nec.co.jp" <nishimura@mxp.nes.nec.co.jp>,
        "balbir@linux.vnet.ibm.com" <balbir@linux.vnet.ibm.com>,
        gthelen@google.com, m-ikeda@ds.jp.nec.com,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        kamezawa.hiroyuki@gmail.com
Subject: [PATCH] memcg: towards I/O aware memcg v5
Message-Id: <20100820185552.426ff12e.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is v5.

Sorry for delaying...but I had time for resetting myself and..several
changes are added. I think this version is simpler than v4.

Major changes from v4 is 
 a) added kernel/cgroup.c hooks again. (for b)
 b) make RCU aware. previous version seems dangerous in an extreme case.

Then, codes are updated. Most of changes are related to RCU.

Patch brief view:
 1. add hooks to kernel/cgroup.c for ID management.
 2. use ID-array in memcg.
 3. record ID to page_cgroup rather than pointer.
 4. make update_file_mapped to be RCU aware routine instead of spinlock.
 5. make update_file_mapped as general-purpose function.


Thanks,
-Kame

