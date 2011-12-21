Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549Ab1LUU2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Dec 2011 15:28:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59861 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751118Ab1LUU2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Dec 2011 15:28:45 -0500
Date: Wed, 21 Dec 2011 12:28:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        jfs-discussion@lists.sourceforge.net,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, davem@davemloft.net,
        Al Viro <viro@zeniv.linux.org.uk>, linux-mm@kvack.org
Subject: Re: [PATCH v2] vfs: __read_cache_page should use gfp argument
 rather than GFP_KERNEL
Message-Id: <20111221122843.18f673c7.akpm@linux-foundation.org>
In-Reply-To: <4EF211EC.7090002@oracle.com>
References: <201112210054.46995.rjw@sisk.pl>
	<CA+55aFzee7ORKzjZ-_PrVy796k2ASyTe_Odz=ji7f1VzToOkKw@mail.gmail.com>
	<4EF15F42.4070104@oracle.com>
	<CA+55aFx=B9adsTR=-uYpmfJnQgdGN+1aL0KUabH5bSY6YcwO7Q@mail.gmail.com>
	<alpine.LSU.2.00.1112202213310.3987@eggly.anvils>
	<4EF211EC.7090002@oracle.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Dec 2011 11:05:48 -0600
Dave Kleikamp <dave.kleikamp@oracle.com> wrote:

> [ updated to remove now-obsolete comment in read_cache_page_gfp()]
> 
> lockdep reports a deadlock in jfs because a special inode's rw semaphore
> is taken recursively. The mapping's gfp mask is GFP_NOFS, but is not used
> when __read_cache_page() calls add_to_page_cache_lru().

Well hang on, it's not just a lockdep splat.  The kernel actually will
deadlock if we reenter JFS via this GFP_KERNEL allocation attempt, yes?

Was that GFP_NOFS allocation recently added to JFS?  If not then we
should backport this deadlock fix into -stable, no?


