Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753329Ab0FZKNm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jun 2010 06:13:42 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41408 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752206Ab0FZKNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jun 2010 06:13:41 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Nick Piggin <npiggin@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       Al Viro <viro@ZenIV.linux.org.uk>, Ulrich Drepper <drepper@redhat.com>,
       Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [rfc] new stat*fs-like syscall?
References: <20100624131455.GA10441@laptop>
Date: Sat, 26 Jun 2010 12:13:39 +0200
In-Reply-To: <20100624131455.GA10441@laptop> (Nick Piggin's message of "Thu,
	24 Jun 2010 23:14:55 +1000")
Message-ID: <87tyoqcd9o.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nick Piggin <npiggin@suse.de> writes:

> Other than types, other differences are:
> - statvfs(2) has is f_frsize, which seems fairly useless.
> - statvfs(2) has f_favail.
> - statfs(2) f_bsize is optimal transfer block, statvfs(2) f_bsize is fs
>   block size. The latter could be useful for disk space algorithms.
>   Both can be ill defned.
> - statvfs(2) lacks f_type.
>
> Is there anything more we should add here? Samba wants a capabilities
> field, with things like sparse files, quotas, compression, encryption,
> case preserving/sensitive.

I wonder if it would make sense to export the time stamp granuality
of the time stamps? We already have this information internally,
and it might allow user land to optimize its stat frequency or comparison.

Some file systems also have quotas with "project ids". Maybe add that 
too?

I think NTFS et.al. also have some more time stamps, but not sure
there's enough space for that.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
