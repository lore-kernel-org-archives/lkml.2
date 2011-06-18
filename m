Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756875Ab1FRAMb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jun 2011 20:12:31 -0400
Received: from oproxy6-pub.bluehost.com ([67.222.54.6]:40506 "HELO
	oproxy6-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755421Ab1FRAMa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jun 2011 20:12:30 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=xenotime.net;
	h=Received:Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:Organization:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=VzLTSd2FP0O8rxezRpM6zZhLnt+owCT4r0VaZp7nDlGWPOemj/8VpHlmyc4u8U0z7Icg6xbaW67F+eP6oUH7EpDeb9zQTX9l5weSUUg+6G+VfGPqlXjFAiqJnMs76dqZ;
Date: Fri, 17 Jun 2011 17:12:28 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
To: akpm <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/12] radix_tree: exceptional entries and indices
Message-Id: <20110617171228.4c85fd38.rdunlap@xenotime.net>
In-Reply-To: <20110617170742.282a1bd6.rdunlap@xenotime.net>
References: <alpine.LSU.2.00.1106140327550.29206@sister.anvils>
	<alpine.LSU.2.00.1106140341070.29206@sister.anvils>
	<20110617163854.49225203.akpm@linux-foundation.org>
	<20110617170742.282a1bd6.rdunlap@xenotime.net>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 17 Jun 2011 17:07:42 -0700 Randy Dunlap wrote:

> On Fri, 17 Jun 2011 16:38:54 -0700 Andrew Morton wrote:
> 
> > On Tue, 14 Jun 2011 03:42:27 -0700 (PDT)
> > Hugh Dickins <hughd@google.com> wrote:
> > 
> > > The radix_tree is used by several subsystems for different purposes.
> > > A major use is to store the struct page pointers of a file's pagecache
> > > for memory management.  But what if mm wanted to store something other
> > > than page pointers there too?
> > > 
> > > The low bit of a radix_tree entry is already used to denote an indirect
> > > pointer, for internal use, and the unlikely radix_tree_deref_retry() case.
> > > Define the next bit as denoting an exceptional entry, and supply inline
> > > functions radix_tree_exception() to return non-0 in either unlikely case,
> > > and radix_tree_exceptional_entry() to return non-0 in the second case.
> > > 
> > > If a subsystem already uses radix_tree with that bit set, no problem:
> > > it does not affect internal workings at all, but is defined for the
> > > convenience of those storing well-aligned pointers in the radix_tree.
> > > 
> > > The radix_tree_gang_lookups have an implicit assumption that the caller
> > > can deduce the offset of each entry returned e.g. by the page->index of
> > > a struct page.  But that may not be feasible for some kinds of item to
> > > be stored there.
> > > 
> > > radix_tree_gang_lookup_slot() allow for an optional indices argument,
> > > output array in which to return those offsets.  The same could be added
> > > to other radix_tree_gang_lookups, but for now keep it to the only one
> > > for which we need it.
> > 
> > Yes, the RADIX_TREE_INDIRECT_PTR hack is internal-use-only, and doesn't
> > operate on (and hence doesn't corrupt) client-provided items.
> > 
> > This patch uses bit 1 and uses it against client items, so for
> > practical purpoese it can only be used when the client is storing
> > addresses.  And it needs new APIs to access that flag.
> > 
> > All a bit ugly.  Why not just add another tag for this?  Or reuse an
> > existing tag if the current tags aren't all used for these types of
> > pages?
> 
> 
> And regardless of the patch path that is taken, update test(s) if
> applicable.  I thought that someone from Red Hat had a kernel loadable
> module for testing radix-tree -- or maybe that was for rbtree (?) --
> but I can't find that just now.

http://people.redhat.com/jmoyer/radix-tree/


> And one Andrew Morton has a userspace radix tree test harness at
> http://userweb.kernel.org/~akpm/stuff/rtth.tar.gz


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
