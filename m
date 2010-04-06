Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753002Ab0DFKJS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 06:09:18 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:50880 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752480Ab0DFKJN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 06:09:13 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: Ugly rmap NULL ptr deref oopsie on hibernate (was Linux 2.6.34-rc3)
Cc: kosaki.motohiro@jp.fujitsu.com,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Borislav Petkov <bp@alien8.de>, Rik van Riel <riel@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Lee Schermerhorn <Lee.Schermerhorn@hp.com>,
       Minchan Kim <minchan.kim@gmail.com>, Nick Piggin <npiggin@suse.de>,
       Andrea Arcangeli <aarcange@redhat.com>,
       Hugh Dickins <hugh.dickins@tiscali.co.uk>
In-Reply-To: <20100406173754.7E5A.A69D9226@jp.fujitsu.com>
References: <alpine.LFD.2.00.1004021059010.3634@i5.linux-foundation.org> <20100406173754.7E5A.A69D9226@jp.fujitsu.com>
Message-Id: <20100406190036.7E66.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Tue,  6 Apr 2010 19:09:08 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> (b) is also impossible. SLAB_DESTROY_BY_RCU delay the page for anon_vma 
> freeing until next rcu period. It mean rcu_read_lock()+page_mapped() 
> can see kfree()ed page. but it is safe. noone corrupt it.

by the way: I haven't understand why rik's per process anon_vma concept
works correctly with ksm. ksm increase anon_vma->ksm_refcount. but it seems
not guranteed vma->anon_vma and page->anon_vma are the same.

but I guess bug reporter doesn't use ksm, it's minor feature.



