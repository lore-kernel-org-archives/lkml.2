Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754794Ab1C1WCA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 18:02:00 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:58003 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753026Ab1C1WB7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 18:01:59 -0400
Date: Mon, 28 Mar 2011 15:01:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mundt <lethal@linux-sh.org>, David Howells <dhowells@redhat.com>,
        Greg Ungerer <gerg@snapgear.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC/RFT 0/6] nommu: improve the vma list handling
Message-Id: <20110328150102.11bcfca8.akpm@linux-foundation.org>
In-Reply-To: <1301320607-7259-1-git-send-email-namhyung@gmail.com>
References: <1301320607-7259-1-git-send-email-namhyung@gmail.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 28 Mar 2011 22:56:41 +0900
Namhyung Kim <namhyung@gmail.com> wrote:

> When I was reading nommu code, I found that it handles the vma list/tree in
> an unusual way. IIUC, because there can be more than one identical/overrapped
> vmas in the list/tree, it sorts the tree more strictly and does a linear
> search on the tree. But it doesn't applied to the list (i.e. the list could
> be constructed in a different order than the tree so that we can't use the
> list when finding the first vma in that order).
> 
> Since inserting/sorting a vma in the tree and link is done at the same time,
> we can easily construct both of them in the same order. And linear searching
> on the tree could be more costly than doing it on the list, it can be
> converted to use the list.
> 
> Also, after the commit 297c5eee3724 ("mm: make the vma list be doubly linked")
> made the list be doubly linked, there were a couple of code need to be fixed
> to construct the list properly.
> 
> Patch 1/6 is a preparation. It maintains the list sorted same as the tree and
> construct doubly-linked list properly. Patch 2/6 is a simple optimization for
> the vma deletion. Patch 3/6 and 4/6 convert tree traversal to list traversal
> and the rest are simple fixes and cleanups.
> 
> Note that I don't have a system to test on, so these are *totally untested*
> patches. There could be some basic errors in the code. In that case, please
> kindly let me know. :)
> 
> Anyway, I just compiled them on my x86_64 desktop using this command:
> 
>   make mm/nommu.o
> 
> (Of course this required few of dirty-fixes to proceed)
> 
> Also note that these are on top of v2.6.38.
> 
> Any comments are welcome.

That seems like a nice set of changes.  There isn't much I can do with
them at this tims - hopefully some of the nommu people will be able to
find time to review and test the patches.  

(Is there a way in which one can run a nommu kernel on a regular PC?  Under
an emulator?)

