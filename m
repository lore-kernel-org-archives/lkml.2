Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757843Ab2EGVcV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 May 2012 17:32:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54014 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab2EGVcU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 May 2012 17:32:20 -0400
Date: Mon, 7 May 2012 14:32:18 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Russ Anderson <rja@sgi.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Yinghai Lu <yinghai@kernel.org>, David Miller <davem@davemloft.net>
Subject: Re: [patch] mm: nobootmem: fix sign extend problem in
 __free_pages_memory()
Message-Id: <20120507143218.e8cc5584.akpm@linux-foundation.org>
In-Reply-To: <20120507193202.GA11518@sgi.com>
References: <20120507193202.GA11518@sgi.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 7 May 2012 14:32:03 -0500
Russ Anderson <rja@sgi.com> wrote:

> Systems with 8 TBytes of memory or greater can hit a problem 
> where only the the first 8 TB of memory shows up.

erk.

>  This is
> due to "int i" being smaller than "unsigned long start_aligned",
> causing the high bits to be dropped.
> 
> The fix is to change i to unsigned long to match start_aligned
> and end_aligned.
> 
> Thanks to Jack Steiner (steiner@sgi.com) for assistance tracking
> this down.
> 

I added the Cc: <stable@vger.kernel.org> to this.  The fix is small and
safe and someone might want to run older kernels on such a machine.

