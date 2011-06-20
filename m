Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754634Ab1FTNSY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 09:18:24 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41776 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754215Ab1FTNSU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 09:18:20 -0400
Date: Mon, 20 Jun 2011 14:18:18 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: David Howells <dhowells@redhat.com>
Cc: linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] get_write_access()/deny_write_access() without
 inode->i_lock
Message-ID: <20110620131818.GR11521@ZenIV.linux.org.uk>
References: <20110619235147.GQ11521@ZenIV.linux.org.uk>
 <21839.1308574037@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <21839.1308574037@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 20, 2011 at 01:47:17PM +0100, David Howells wrote:
> Al Viro <viro@ZenIV.linux.org.uk> wrote:
> 
> > +	for (v = atomic_read(&inode->i_writecount); v >= 0; v = v1) {
> > +		v1 = atomic_cmpxchg(&inode->i_writecount, v, v + 1);
> > +		if (likely(v1 == v))
> > +			return 0;
> > +	}
> 
> You don't need to reissue the atomic_read().  atomic_cmpxchg() returns the
> current value of the memory location.  Just set v to v1 before going round the
> loop again.

That's precisely what that loop is doing...
