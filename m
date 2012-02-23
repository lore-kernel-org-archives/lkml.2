Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753980Ab2BWHpd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Feb 2012 02:45:33 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:34739 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752296Ab2BWHpb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Feb 2012 02:45:31 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bsingharora@gmail.com designates 10.229.105.88 as permitted sender) smtp.mail=bsingharora@gmail.com; dkim=pass header.i=bsingharora@gmail.com
MIME-Version: 1.0
In-Reply-To: <1326912662-18805-1-git-send-email-asharma@fb.com>
References: <1326912662-18805-1-git-send-email-asharma@fb.com>
Date: Thu, 23 Feb 2012 13:15:30 +0530
Message-ID: <CAKTCnzn-reG4bLmyWNYPELYs-9M3ZShEYeOix_OcnPow-w8PNg@mail.gmail.com>
Subject: Re: [PATCH] mm: Enable MAP_UNINITIALIZED for archs with mmu
From: Balbir Singh <bsingharora@gmail.com>
To: Arun Sharma <asharma@fb.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 19, 2012 at 12:21 AM, Arun Sharma <asharma@fb.com> wrote:
>
> This enables malloc optimizations where we might
> madvise(..,MADV_DONTNEED) a page only to fault it
> back at a different virtual address.
>
> To ensure that we don't leak sensitive data to
> unprivileged processes, we enable this optimization
> only for pages that are reused within a memory
> cgroup.
>

So the assumption is that only apps that have access to each others
VMA's will run in this cgroup?

> The idea is to make this opt-in both at the mmap()
> level and cgroup level so the default behavior is
> unchanged after the patch.
>

Sorry, I am not convinced we need to do this

1. I know that zeroing out memory is expensive, but building a
potential loop hole is not a good idea
2. How do we ensure that tasks in a cgroup should be allowed to reuse
memory uninitialized, how does the cgroup admin know what she is
getting into?

So I am going to NACK this.

Balbir
