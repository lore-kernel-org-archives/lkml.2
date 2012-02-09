Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757340Ab2BICVM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Feb 2012 21:21:12 -0500
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59211 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751706Ab2BICVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Feb 2012 21:21:11 -0500
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Thu, 9 Feb 2012 11:19:50 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>, Andi Kleen <andi@firstfloor.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] thp: optimize away unnecessary page table locking
Message-Id: <20120209111950.b3e626d1.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1328716302-16871-3-git-send-email-n-horiguchi@ah.jp.nec.com>
References: <1328716302-16871-1-git-send-email-n-horiguchi@ah.jp.nec.com>
	<1328716302-16871-3-git-send-email-n-horiguchi@ah.jp.nec.com>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.1.1 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed,  8 Feb 2012 10:51:38 -0500
Naoya Horiguchi <n-horiguchi@ah.jp.nec.com> wrote:

> Currently when we check if we can handle thp as it is or we need to
> split it into regular sized pages, we hold page table lock prior to
> check whether a given pmd is mapping thp or not. Because of this,
> when it's not "huge pmd" we suffer from unnecessary lock/unlock overhead.
> To remove it, this patch introduces a optimized check function and
> replace several similar logics with it.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> Cc: David Rientjes <rientjes@google.com>
> 

I prefer 'bool' for return type..but seems much better.

Thank you. I think this clean up is very good.

Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>


