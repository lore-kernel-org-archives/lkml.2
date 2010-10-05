Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755965Ab0JERec (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 13:34:32 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37666 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752932Ab0JEReb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 13:34:31 -0400
MIME-Version: 1.0
In-Reply-To: <1286265215-9025-3-git-send-email-walken@google.com>
References: <1286265215-9025-1-git-send-email-walken@google.com> <1286265215-9025-3-git-send-email-walken@google.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 5 Oct 2010 10:33:37 -0700
Message-ID: <AANLkTimyZc1ggSgvBS_=t3e1yr7EFBMK-uHvFcuVB8jC@mail.gmail.com>
Subject: Re: [PATCH 2/3] Retry page fault when blocking on disk transfer.
To: Michel Lespinasse <walken@google.com>
Cc: linux-mm@kvack.org, Ying Han <yinghan@google.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Rik van Riel <riel@redhat.com>, Nick Piggin <npiggin@kernel.dk>,
        Peter Zijlstra <peterz@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 5, 2010 at 12:53 AM, Michel Lespinasse <walken@google.com> wrote:
>
> This change reduces mmap_sem hold times that are caused by waiting for
> disk transfers when accessing file mapped VMAs.

Ok, this series looks much better. The new mm/filemap.c diff looks
much better with the lock_page_or_retry() helper function, and on the
whole I think I can Ack this (although obviously not actually apply it
- but please do get it into linux-next).

The do_page_fault() part of the patch still looks ugly, but I don't
see any obvious way to improve on it.

                        Linus
