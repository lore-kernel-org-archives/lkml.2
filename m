Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756400Ab1CXJ3O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Mar 2011 05:29:14 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:34386 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755994Ab1CXJ3M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Mar 2011 05:29:12 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 24 Mar 2011 18:22:40 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "linux-mm@kvack.org" <linux-mm@kvack.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "rientjes@google.com" <rientjes@google.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: [PATCH 0/4] forkbomb killer
Message-Id: <20110324182240.5fe56de2.kamezawa.hiroyu@jp.fujitsu.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Cleaned up and fixed unclear logics. and removed RFC.
Maybe this version is easy to be read.


When we see forkbomb, it tends can be a fatal one.

 When A user makes a forkbomb (and sometimes reaches ulimit....
   In this case, 
   - If the system is not in OOM, the admin may be able to kill all threads by
     hand..but forkbomb may be faster than pkill() by admin.
   - If the system is in OOM, the admin needs to reboot system.
     OOM killer is slow than forkbomb.

So, I think forkbomb killer is appreciated. It's better than reboot.

At implementing forkbomb killer, one of difficult case is like this

# forkbomb(){ forkbomb|forkbomb & } ; forkbomb

With this, parent tasks will exit() before the system goes under OOM.
So, it's difficult to know the whole image of forkbomb.

This patch introduce a subsystem to track mm's history and records it
even after the task exit. (It will be flushed periodically.)

I tested with several forkbomb cases and this patch seems work fine.

Maybe some more 'heuristics' can be added....but I think this simple
one works enough. Any comments are welcome.
Thanks,
-Kame


