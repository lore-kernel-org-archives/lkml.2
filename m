Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab1KVX7F (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 18:59:05 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44161 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750888Ab1KVX7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 18:59:02 -0500
Date: Tue, 22 Nov 2011 15:59:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Wang Sheng-Hui <shhuiw@gmail.com>
Cc: yinghai@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cleanup: convert the int cnt to unsigned long in
 mm/memblock.c
Message-Id: <20111122155901.e7b23dce.akpm@linux-foundation.org>
In-Reply-To: <4EBA0D3D.1090808@gmail.com>
References: <4EB9DF0B.7050004@gmail.com>
	<4EBA0D3D.1090808@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 09 Nov 2011 13:18:53 +0800
Wang Sheng-Hui <shhuiw@gmail.com> wrote:

> @@ -111,7 +112,7 @@ static phys_addr_t __init_memblock memblock_find_region(phys_addr_t start, phys_
>  static phys_addr_t __init_memblock memblock_find_base(phys_addr_t size,
>  			phys_addr_t align, phys_addr_t start, phys_addr_t end)
>  {
> -	long i;
> +	unsigned long i;
>  
>  	BUG_ON(0 == size);

This change to memblock_find_base() can cause this loop:

	for (i = memblock.memory.cnt - 1; i >= 0; i--) {

to become infinite under some circumstances.

I stopped reading at that point.  Changes like this require much care.

