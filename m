Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752234Ab1D1APl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Apr 2011 20:15:41 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:38727 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751199Ab1D1APk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Apr 2011 20:15:40 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 28 Apr 2011 09:08:57 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Matt Fleming <matt@console-pimps.org>
Cc: Dave Hansen <dave@linux.vnet.ibm.com>, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@linux.intel.com>
Subject: Re: [PATCH] mm: Delete non-atomic mm counter implementation
Message-Id: <20110428090857.24de6532.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1303914965-868-1-git-send-email-matt@console-pimps.org>
References: <1303914965-868-1-git-send-email-matt@console-pimps.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.0 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 27 Apr 2011 15:36:05 +0100
Matt Fleming <matt@console-pimps.org> wrote:

> From: Matt Fleming <matt.fleming@linux.intel.com>
> 
> The problem with having two different types of counters is that
> developers adding new code need to keep in mind whether it's safe to
> use both the atomic and non-atomic implementations. For example, when
> adding new callers of the *_mm_counter() functions a developer needs
> to ensure that those paths are always executed with page_table_lock
> held, in case we're using the non-atomic implementation of mm
> counters.
> 
> Hugh Dickins introduced the atomic mm counters in commit f412ac08c986
> ("[PATCH] mm: fix rss and mmlist locking"). When asked why he left the
> non-atomic counters around he said,
> 
>   | The only reason was to avoid adding costly atomic operations into a
>   | configuration that had no need for them there: the page_table_lock
>   | sufficed.
>   |
>   | Certainly it would be simpler just to delete the non-atomic variant.
>   |
>   | And I think it's fair to say that any configuration on which we're
>   | measuring performance to that degree (rather than "does it boot fast?"
>   | type measurements), would already be going the split ptlocks route.
> 
> Removing the non-atomic counters eases the maintenance burden because
> developers no longer have to mindful of the two implementations when
> using *_mm_counter().
> 
> Note that all architectures provide a means of atomically updating
> atomic_long_t variables, even if they have to revert to the generic
> spinlock implementation because they don't support 64-bit atomic
> instructions (see lib/atomic64.c).
> 
> Signed-off-by: Matt Fleming <matt.fleming@linux.intel.com>

now mm_counters are update in per-thread and removing non-atomic
will not have big impact in performance, I hope. 

Acked-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>

