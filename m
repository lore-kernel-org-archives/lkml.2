Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755390Ab1H2XHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Aug 2011 19:07:06 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:36952 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754103Ab1H2XHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Aug 2011 19:07:03 -0400
Date: Mon, 29 Aug 2011 16:06:37 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Konstantin Khlebnikov <khlebnikov@openvz.org>
Cc: Hugh Dickins <hughd@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH] mm: fix page-faults detection in swap-token logic
Message-Id: <20110829160637.bfc86e63.akpm@linux-foundation.org>
In-Reply-To: <20110827083201.21854.56111.stgit@zurg>
References: <20110827083201.21854.56111.stgit@zurg>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 27 Aug 2011 12:32:01 +0300
Konstantin Khlebnikov <khlebnikov@openvz.org> wrote:

> After commit v2.6.36-5896-gd065bd8 "mm: retry page fault when blocking on disk transfer"
> we usually wait in page-faults without mmap_sem held, so all swap-token logic was broken,
> because it based on using rwsem_is_locked(&mm->mmap_sem) as sign of in progress page-faults.

If I'm interpreting this correctly, the thrash-handling logic has been
effectively disabled for a year and nobody noticed.

> This patch adds to mm_struct atomic counter of in progress page-faults for mm with swap-token.

We desperately need to delete some code from mm/.  This seems like a
great candidate.  Someone prove me wrong?
