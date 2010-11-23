Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751403Ab0KWGCt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Nov 2010 01:02:49 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58789 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751057Ab0KWGCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Nov 2010 01:02:48 -0500
Date: Mon, 22 Nov 2010 21:57:46 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michel Lespinasse <walken@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Nick Piggin <npiggin@kernel.dk>, Rik van Riel <riel@redhat.com>
Subject: Re: [RFC] mlock: release mmap_sem every 256 faulted pages
Message-Id: <20101122215746.e847742d.akpm@linux-foundation.org>
In-Reply-To: <20101123050052.GA24039@google.com>
References: <20101123050052.GA24039@google.com>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Nov 2010 21:00:52 -0800 Michel Lespinasse <walken@google.com> wrote:

> Hi,
> 
> I'd like to sollicit comments on this proposal:
> 
> Currently mlock() holds mmap_sem in exclusive mode while the pages get
> faulted in. In the case of a large mlock, this can potentially take a
> very long time.

A more compelling description of why this problem needs addressing
would help things along.

> +		/*
> +		 * Limit batch size to 256 pages in order to reduce
> +		 * mmap_sem hold time.
> +		 */
> +		nfault = nstart + 256 * PAGE_SIZE;

It would be nicer if there was an rwsem API to ask if anyone is
currently blocked in down_read() or down_write().  That wouldn't be too
hard to do.  It wouldn't detect people polling down_read_trylock() or
down_write_trylock() though.
