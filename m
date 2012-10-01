Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757937Ab2JAXom (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:44:42 -0400
Received: from tetsuo.zabbo.net ([50.193.208.193]:55341 "EHLO tetsuo.zabbo.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753879Ab2JAXok (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:44:40 -0400
Date: Mon, 1 Oct 2012 16:44:39 -0700
From: Zach Brown <zab@zabbo.net>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        tytso@google.com, tj@kernel.org,
        Dave Kleikamp <dave.kleikamp@oracle.com>,
        Dmitry Monakhov <dmonakhov@openvz.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        michael.mesnier@intel.com, jeffrey.d.skirvin@intel.com,
        Martin Petersen <martin.petersen@oracle.com>
Subject: Re: [RFC, PATCH] Extensible AIO interface
Message-ID: <20121001234439.GC14533@lenny.home.zabbo.net>
References: <20121001222341.GF26488@google.com>
 <20121001231222.GB14533@lenny.home.zabbo.net>
 <20121001232235.GH26488@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121001232235.GH26488@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Not just per sector, Per hardware sector. For passing around checksums
> userspace would have to find out the hardware sector size and checksum
> type/size via a different interface, and then the attribute would
> contain a pointer to a buffer that can hold the appropriate number of
> checksums.

All problems fall to another layer of indirection? :)  But yes, that's
fair.  I was obviously just assuming that the checksums would be in the
attribute.

But now we're talking about layers of user pointers.  Would the
attribute parser need to verify/copy pointers before downstream kernel
code tries to work with it?  Would it be up to the attribute consumers
to verify the pointers that the core doesn't really touch?  Are these
second pointers native (enter compat goo) or u64s?

> I don't think there's anything fragile about the basic idea though. Or
> do you have some way of improving upon it in mind?

Nothing super great is springing to mind, no.

> The idea with the size field is that it's just sizeof(the particular
> attribute struct), so when userspace is appending attributes it just
> sets size = sizeof() and attr_list->size += attr->size.

I suppose.  But this also raises the spectre of aligning the packed
attributes to match their struct definitions.  It's the netlink(3)
macros all over again, right?  I guess unaligned accesses aren't *that*
big a deal.  But still.

And what about duplicate instances of a given attribute id?  Use the
first?  The last?  Error?  Depends on the id?

It just seems like there are a lot of corner cases that can go wrong
with an API that is so free form.  I'd like something a lot harder to
make mistakes with.

- z
(being That Guy today, apparently :/)
