Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245Ab2DCQLH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 12:11:07 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:18321 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754641Ab2DCQLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 12:11:05 -0400
Message-ID: <4F7B2114.4000806@tilera.com>
Date: Tue, 3 Apr 2012 12:11:00 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:11.0) Gecko/20120327 Thunderbird/11.0.1
MIME-Version: 1.0
To: Kautuk Consul <consul.kautuk@gmail.com>
CC: <paul.mckenney@linaro.org>,
        Lucas De Marchi <lucas.demarchi@profusion.mobi>,
        Josh Triplett <josh@joshtriplett.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 15/19 v2] tile/mm/fault.c: Port OOM changes to handle_page_fault
References: <1333195539-5421-1-git-send-email-consul.kautuk@gmail.com>
In-Reply-To: <1333195539-5421-1-git-send-email-consul.kautuk@gmail.com>
X-Enigmail-Version: 1.4
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/31/2012 8:05 AM, Kautuk Consul wrote:
> Commit d065bd810b6deb67d4897a14bfe21f8eb526ba99
> (mm: retry page fault when blocking on disk transfer) and
> commit 37b23e0525d393d48a7d59f870b3bc061a30ccdb
> (x86,mm: make pagefault killable)
>
> The above commits introduced changes into the x86 pagefault handler
> for making the page fault handler retryable as well as killable.
>
> These changes reduce the mmap_sem hold time, which is crucial
> during OOM killer invocation.
>
> Port these changes to tile.
>
> Signed-off-by: Kautuk Consul <consul.kautuk@gmail.com>
> [...]
> +			 /* No need to up_read(&mm->mmap_sem) as we would
> +			 * have already released it in __lock_page_or_retry
> +			 * in mm/filemap.c.
> +			 */
>

Taken into the tile tree.  I adjusted the block comment whitespacing to
normal Linux standard.  Thanks!

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

