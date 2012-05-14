Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932647Ab2ENWe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 May 2012 18:34:59 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:54597 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932312Ab2ENWe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 May 2012 18:34:57 -0400
Subject: Re: [PATCH v2] mm: Fix slab->page _count corruption.
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Pravin B Shelar <pshelar@nicira.com>
Cc: cl@linux.com, penberg@kernel.org, mpm@selenic.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, jesse@nicira.com,
        abhide@nicira.com
In-Reply-To: <1337034597-1826-1-git-send-email-pshelar@nicira.com>
References: <1337034597-1826-1-git-send-email-pshelar@nicira.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 15 May 2012 00:34:52 +0200
Message-ID: <1337034892.8512.652.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-05-14 at 15:29 -0700, Pravin B Shelar wrote:
> On arches that do not support this_cpu_cmpxchg_double slab_lock is used
> to do atomic cmpxchg() on double word which contains page->_count.
> page count can be changed from get_page() or put_page() without taking
> slab_lock. That corrupts page counter.
> 
> Following patch fixes it by moving page->_count out of cmpxchg_double
> data. So that slub does no change it while updating slub meta-data in
> struct page.

I say again : Page is owned by slub, so get_page() or put_page() is not
allowed ?

How is put_page() going to work with order-1 or order-2 allocations ?

Me very confused by these Nicira patches.


