Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753081Ab2BQPPT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 10:15:19 -0500
Received: from merlin.infradead.org ([205.233.59.134]:51998 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751760Ab2BQPPS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 10:15:18 -0500
Message-ID: <1329491708.2293.277.camel@twins>
Subject: Re: [PATCH 1/2] rmap: Staticize page_referenced_file and
 page_referenced_anon
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Kautuk Consul <consul.kautuk@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Mel Gorman <mgorman@suse.de>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Date: Fri, 17 Feb 2012 16:15:08 +0100
In-Reply-To: <1329488869-7270-1-git-send-email-consul.kautuk@gmail.com>
References: <1329488869-7270-1-git-send-email-consul.kautuk@gmail.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-02-17 at 09:27 -0500, Kautuk Consul wrote:
> Staticize the page_referenced_anon and page_referenced_file
> functions.
> These functions are called only from page_referenced.

Subject and changelog say: staticize, which I read to mean: make static.
Yet what the patch does is make them inline ?!?

Also, if they're static and there's only a single callsite, gcc will
already inline them, does this patch really make a difference?

> -static int page_referenced_anon(struct page *page,
> +static inline int page_referenced_anon(struct page *page,


