Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753037Ab0G2FXh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jul 2010 01:23:37 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:59752 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751287Ab0G2FXg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jul 2010 01:23:36 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: Memory corruption during hibernation since 2.6.31
Cc: kosaki.motohiro@jp.fujitsu.com, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Ondrej Zary <linux@rainbow-software.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Balbir Singh <balbir@in.ibm.com>
In-Reply-To: <20100729132325.59871484.kamezawa.hiroyu@jp.fujitsu.com>
References: <201007282334.08063.rjw@sisk.pl> <20100729132325.59871484.kamezawa.hiroyu@jp.fujitsu.com>
Message-Id: <20100729142245.4AA5.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.50.07 [ja]
Date: Thu, 29 Jul 2010 14:23:33 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Index: linux-2.6.34.org/mm/swapfile.c
> ===================================================================
> --- linux-2.6.34.org.orig/mm/swapfile.c
> +++ linux-2.6.34.org/mm/swapfile.c
> @@ -316,7 +316,9 @@ checks:
>  		scan_base = offset = si->lowest_bit;
>  
>  	/* reuse swap entry of cache-only swap if not busy. */
> -	if (vm_swap_full() && si->swap_map[offset] == SWAP_HAS_CACHE) {
> +	if (vm_swap_full()
> +		&& usage == SWAP_HAS_CACHE
> +		&& si->swap_map[offset] == SWAP_HAS_CACHE) {
>  		int swap_was_freed;
>  		spin_unlock(&swap_lock);
>  		swap_was_freed = __try_to_reclaim_swap(si, offset);

Can you please add explicit commenting in the code?



