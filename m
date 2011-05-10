Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251Ab1EJW5h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 18:57:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:44195 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753149Ab1EJW5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 18:57:36 -0400
Date: Tue, 10 May 2011 23:57:00 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Matthew Wilcox <matthew@wil.cx>, Zdenek Kabelac <zkabelac@redhat.com>,
        Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
        linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
        Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>,
        agk@redhat.com
Subject: Re: [PATCH] Don't mlock guardpage if the stack is growing up
Message-ID: <20110510225659.GE9253@agk-dp.fab.redhat.com>
Mail-Followup-To: Alasdair G Kergon <agk@redhat.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Matthew Wilcox <matthew@wil.cx>,
	Zdenek Kabelac <zkabelac@redhat.com>,
	Mikulas Patocka <mikulas@artax.karlin.mff.cuni.cz>,
	linux-kernel@vger.kernel.org, linux-parisc@vger.kernel.org,
	Hugh Dickins <hughd@google.com>, Oleg Nesterov <oleg@redhat.com>
References: <alpine.DEB.2.00.1105082045250.15552@artax.karlin.mff.cuni.cz> <BANLkTikEpaRZK3X4YReeQAwgcv3HAGUwSw@mail.gmail.com> <alpine.DEB.2.00.1105091246550.32299@artax.karlin.mff.cuni.cz> <4DC7D37F.9040308@redhat.com> <20110509224511.GC15227@parisc-linux.org> <BANLkTikz-sGiy2NdzQMPzCWF64cVF-DZ7w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BANLkTikz-sGiy2NdzQMPzCWF64cVF-DZ7w@mail.gmail.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: Amberley Place, 107-111 Peascod
	Street, Windsor, Berkshire, SL4 1TE.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 09, 2011 at 03:56:11PM -0700, Linus Torvalds wrote:
> So there are sane semantics for the concept, and it would be easy to
> do in the kernel. Whether it's worth doing, I dunno.
 
At this point we have a workaround that seems to work for us.  I find it
ugly and it has needed some tweaking already but we can cope.

If others find similar problems to ours and start replicating the logic
we're using, then that would be the time to give serious thought to a
clean 'sparse' extension.  (Maybe marking individual mappings as MAP_SPARSE
and adding a MCL_NO_SPARSE option to ignore them sounds most promising to me.)

(What other software packages make use of mlockall() and under what
circumstances?)

Alasdair

