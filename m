Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab1FRSMg (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 14:12:36 -0400
Received: from one.firstfloor.org ([213.235.205.2]:54845 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752072Ab1FRSMd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 14:12:33 -0400
Date: Sat, 18 Jun 2011 20:12:32 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Vasileios Karakasis <bkk@cslab.ece.ntua.gr>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-numa@vger.kernel.org
Subject: Re: [BUG] Invalid return address of mmap() followed by mbind() in multithreaded context
Message-ID: <20110618181232.GI16236@one.firstfloor.org>
References: <4DFB710D.7000902@cslab.ece.ntua.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DFB710D.7000902@cslab.ece.ntua.gr>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>     for (i = 0; i < NR_ITER; i++) {
>         addr = mmap(0, PAGE_SIZE, PROT_READ | PROT_WRITE,
>                     MAP_ANONYMOUS | MAP_PRIVATE, 0, 0);
>         if (addr == (void *) -1) {
>             assert(0 && "mmap failed");
>         }
>         *addr = 0;
> 
>         err = mbind(addr, PAGE_SIZE, MPOL_BIND, &node, sizeof(node), 0);

mbind() can be only done before the first touch. you're not actually testing 
numa policy.

-andi
