Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754425Ab1FTNVN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 09:21:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47964 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753909Ab1FTNVL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 09:21:11 -0400
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <21839.1308574037@redhat.com>
References: <21839.1308574037@redhat.com> <20110619235147.GQ11521@ZenIV.linux.org.uk>
Cc: dhowells@redhat.com, Al Viro <viro@ZenIV.linux.org.uk>,
        linux-arch@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [RFC] get_write_access()/deny_write_access() without inode->i_lock
Date: Mon, 20 Jun 2011 14:20:34 +0100
Message-ID: <22606.1308576034@redhat.com>
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

David Howells <dhowells@redhat.com> wrote:

> > +	for (v = atomic_read(&inode->i_writecount); v >= 0; v = v1) {
> > +		v1 = atomic_cmpxchg(&inode->i_writecount, v, v + 1);
> > +		if (likely(v1 == v))
> > +			return 0;
> > +	}
> 
> You don't need to reissue the atomic_read().  atomic_cmpxchg() returns the
> current value of the memory location.  Just set v to v1 before going round the
> loop again.

Ah...  Never mind - you did that anyway.

David
