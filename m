Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab1IEAHA (ORCPT <rfc822;w@1wt.eu>);
	Sun, 4 Sep 2011 20:07:00 -0400
Received: from fgwmail6.fujitsu.co.jp ([192.51.44.36]:52363 "EHLO
	fgwmail6.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752829Ab1IEAGw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 4 Sep 2011 20:06:52 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 5 Sep 2011 08:59:13 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: "Kirill A. Shutemov" <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <bsingharora@gmail.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: drain all stocks for the cgroup before read
 usage
Message-Id: <20110905085913.8f84278e.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1315098933-29464-1-git-send-email-kirill@shutemov.name>
References: <1315098933-29464-1-git-send-email-kirill@shutemov.name>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun,  4 Sep 2011 04:15:33 +0300
"Kirill A. Shutemov" <kirill@shutemov.name> wrote:

> From: "Kirill A. Shutemov" <kirill@shutemov.name>
> 
> Currently, mem_cgroup_usage() for non-root cgroup returns usage
> including stocks.
> 
> Let's drain all socks before read resource counter value. It makes
> memory{,.memcg}.usage_in_bytes and memory.stat consistent.
> 
> Signed-off-by: Kirill A. Shutemov <kirill@shutemov.name>

Hmm. This seems costly to me. 

If a user chesk usage_in_bytes in a memcg once per 1sec, 
the kernel will call schedule_work on cpus once per 1sec.
So, IMHO, I don't like this.

But if some other guys want this, I'll ack.

BTW, how this affects memory.stat ?

Thanks,
-Kame

