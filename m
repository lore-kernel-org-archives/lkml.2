Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755986Ab1KHW5J (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Nov 2011 17:57:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:46768 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753353Ab1KHW5I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Nov 2011 17:57:08 -0500
Date: Tue, 8 Nov 2011 14:57:06 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Jacobo Giralt <jacobo.giralt@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, mgorman@suse.de,
        minchan.kim@gmail.com, hughd@google.com, hannes@cmpxchg.org,
        Nick Piggin <npiggin@kernel.dk>
Subject: Re: [PATCH] mm: migrate: One less atomic operation
Message-Id: <20111108145706.11da104e.akpm@linux-foundation.org>
In-Reply-To: <1320503897.2428.8.camel@discretia>
References: <1320503897.2428.8.camel@discretia>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 05 Nov 2011 15:38:17 +0100
Jacobo Giralt <jacobo.giralt@gmail.com> wrote:

> >From 3754c8617ef4377ce2ca2e3b28bdc28f8de1aa0d Mon Sep 17 00:00:00 2001
> From: Jacobo Giralt <jacobo.giralt@gmail.com>
> Date: Sat, 5 Nov 2011 13:12:50 +0100
> Subject: [PATCH] mm: migrate: One less atomic operation
> 
> migrate_page_move_mapping drops a reference from the
> old page after unfreezing its counter. Both operations
> can be merged into a single atomic operation by
> directly unfreezing to one less reference.
> 
> The same applies to migrate_huge_page_move_mapping.
> 

Fair enough.

urgh, you made me look at stuff :(

page_unfreeze_refs() and set_page_refcounted() are fishily similar.

page_unfreeze_refs() should use set_page_count().

set_page_count() is defined in the wrong file.

set_page_refcounted() should use page_count().

iow, a bit of a mess.
