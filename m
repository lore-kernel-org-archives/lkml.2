Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757406Ab0EBB5O (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 May 2010 21:57:14 -0400
Received: from nlpi129.sbcis.sbc.com ([207.115.36.143]:55070 "EHLO
	nlpi129.prodigy.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754287Ab0EBB5N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 May 2010 21:57:13 -0400
Date: Sat, 1 May 2010 20:56:18 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Mel Gorman <mel@csn.ul.ie>
cc: Andrew Morton <akpm@linux-foundation.org>, Linux-MM <linux-mm@kvack.org>,
       LKML <linux-kernel@vger.kernel.org>,
       Minchan Kim <minchan.kim@gmail.com>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Andrea Arcangeli <aarcange@redhat.com>, Rik van Riel <riel@redhat.com>
Subject: Re: [PATCH 2/2] mm,migration: Avoid race between shift_arg_pages()
 and rmap_walk() during migration by not migrating temporary stacks
In-Reply-To: <1272529930-29505-3-git-send-email-mel@csn.ul.ie>
Message-ID: <alpine.DEB.2.00.1005012055010.2663@router.home>
References: <1272529930-29505-1-git-send-email-mel@csn.ul.ie> <1272529930-29505-3-git-send-email-mel@csn.ul.ie>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Apr 2010, Mel Gorman wrote:

> There is a race between shift_arg_pages and migration that triggers this bug.
> A temporary stack is setup during exec and later moved. If migration moves
> a page in the temporary stack and the VMA is then removed before migration
> completes, the migration PTE may not be found leading to a BUG when the
> stack is faulted.

A simpler solution would be to not allow migration of the temporary stack?

