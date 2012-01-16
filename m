Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752858Ab2APA3b (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jan 2012 19:29:31 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:60176 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751859Ab2APA32 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jan 2012 19:29:28 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Mon, 16 Jan 2012 09:27:45 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Hillf Danton <dhillf@gmail.com>
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: vmscan: handle isolated pages with lru lock
 released
Message-Id: <20120116092745.7721ff31.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <CAJd=RBAH4+nFQ35JcHju6eSPfDcQpbkJjMX6GBaZFECVaL2swA@mail.gmail.com>
References: <CAJd=RBANeF+TTTtn=F_Yx3N5KkVb5vFPY6FNYEjVntB1pPSLBA@mail.gmail.com>
	<CAJd=RBAH4+nFQ35JcHju6eSPfDcQpbkJjMX6GBaZFECVaL2swA@mail.gmail.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 14 Jan 2012 20:05:11 +0800
Hillf Danton <dhillf@gmail.com> wrote:

> On Fri, Jan 13, 2012 at 11:00 PM, Hillf Danton <dhillf@gmail.com> wrote:

> ===cut here===
> From: Hillf Danton <dhillf@gmail.com>
> Subject: [PATCH] mm: vmscan: handle isolated pages with lru lock released
> 
> When shrinking inactive lru list, isolated pages are queued on locally private
> list, so the lock-hold time could be reduced if pages are counted without lock
> protection. To achive that, firstly updating reclaim stat is delayed until the
> putback stage, which is pointed out by Hugh, after reacquiring the lru lock.
> 
> Secondly operations related to vm and zone stats, are now proteced with
> preemption disabled as they are per-cpu operation.
> 
> Thanks for comments and ideas received.
> 
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

Nice.
Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

