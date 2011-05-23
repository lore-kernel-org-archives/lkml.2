Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753537Ab1EWGrM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 May 2011 02:47:12 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:51085 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751925Ab1EWGrK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 May 2011 02:47:10 -0400
Date: Mon, 23 May 2011 02:45:58 -0400 (EDT)
Message-Id: <20110523.024558.1625882862305082516.davem@davemloft.net>
To: geert@linux-m68k.org
Cc: linux-kernel@vger.kernel.org, sparclinux@vger.kernel.org,
        linux-m68k@vger.kernel.org
Subject: Re: [PATCH 1/4] sparc: _sparc_find_resource() should check for
 exact matches
From: David Miller <davem@davemloft.net>
In-Reply-To: <1306006756-32009-2-git-send-email-geert@linux-m68k.org>
References: <1306006756-32009-1-git-send-email-geert@linux-m68k.org>
	<1306006756-32009-2-git-send-email-geert@linux-m68k.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Sun, 22 May 2011 23:46:02 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Geert Uytterhoeven <geert@linux-m68k.org>
Date: Sat, 21 May 2011 21:39:13 +0200

> The address that's passed to _sparc_find_resource() should always be the
> start address of a resource:
>   - iounmap() passes a page-aligned virtual address, while the original
>     address was created by adding the in-page offset to the resource's
>     start address,
>   - sbus_free_coherent() and pci32_free_coherent() should be passed an
>     address obtained from sbus_alloc_coherent() resp. pci32_alloc_coherent(),
>     which is always a resource's start address.
> 
> Hence replace the range check by a check for an exact match.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>

Acked-by: David S. Miller <davem@davemloft.net>
