Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab1GSWql (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jul 2011 18:46:41 -0400
Received: from smtp-out.google.com ([216.239.44.51]:46146 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545Ab1GSWqk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jul 2011 18:46:40 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:date:from:x-x-sender:to:cc:subject:
	in-reply-to:message-id:references:user-agent:mime-version:content-type:x-system-of-record;
	b=hb4OeJstWVmBRlP6vn8Ipaica+B1wGR/8GxwrdOQUDi6p3DepjyDm8rHQtK+AW7D3
	cQkp7HGKtMJN4rN1hhgHQ==
Date: Tue, 19 Jul 2011 15:46:14 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@sister.anvils
To: Andrew Morton <akpm@linux-foundation.org>
cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/12] mm: let swap use exceptional entries
In-Reply-To: <20110713161121.17fd98a4.akpm@linux-foundation.org>
Message-ID: <alpine.LSU.2.00.1107191538460.1565@sister.anvils>
References: <alpine.LSU.2.00.1106140327550.29206@sister.anvils> <alpine.LSU.2.00.1106140342330.29206@sister.anvils> <20110618145254.1b333344.akpm@linux-foundation.org> <alpine.LSU.2.00.1107121501100.2112@sister.anvils>
 <20110713161121.17fd98a4.akpm@linux-foundation.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Jul 2011, Andrew Morton wrote:
> On Tue, 12 Jul 2011 15:08:58 -0700 (PDT)
> Hugh Dickins <hughd@google.com> wrote:
> > 
> > I'll keep the bland naming, if that's okay, but send a patch adding
> > a line of comment in such places.  Mentioning shmem, tmpfs, swap.
> 
> A better fix would be to create a nicely-documented filemap-specific
> function with a non-bland name which simply wraps
> radix_tree_exception().

I did yesterday try out page_tree_entry_is_not_a_page() to wrap
radix_tree_exceptional_entry(); but (a) I'm wary of negative names,
(b) it was hard to explain why radix_tree_deref_retry() is not a
part of that case, and (c) does a further wrapper help or obscure?

I've skirted the issue in the patch 3/3 I'm about to send you,
maybe you'll think it an improvement, maybe not: I'm neutral.

Hugh
