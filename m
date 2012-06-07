Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759472Ab2FGCI5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 22:08:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9949 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754756Ab2FGCI4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 22:08:56 -0400
Date: Wed, 6 Jun 2012 22:08:47 -0400
From: Dave Jones <davej@redhat.com>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: processes hung after sys_renameat, and 'missing' processes
Message-ID: <20120607020846.GD17566@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Al Viro <viro@ZenIV.linux.org.uk>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Miklos Szeredi <mszeredi@suse.cz>, Jan Kara <jack@suse.cz>,
	Peter Zijlstra <peterz@infradead.org>
References: <20120606230040.GA18089@redhat.com>
 <CA+55aFx_oREEd2XS_aG7PJ7dwzWjgx689V_uRPGWpVS01_++6A@mail.gmail.com>
 <20120606235403.GC30000@ZenIV.linux.org.uk>
 <20120607002914.GB22223@redhat.com>
 <CA+55aFyp2GUbc218eb5BDyAqz+cOPTJMVcb4ptk+f1_RBB+-mg@mail.gmail.com>
 <20120607011915.GA17566@redhat.com>
 <20120607012900.GE30000@ZenIV.linux.org.uk>
 <20120607013149.GF30000@ZenIV.linux.org.uk>
 <CA+55aFx3QT0AA+s=M+QyJFKqQNh0cHiunwZ=fyrc1eneJTtarQ@mail.gmail.com>
 <20120607015410.GG30000@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120607015410.GG30000@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 07, 2012 at 02:54:10AM +0100, Al Viro wrote:

 > > Do you even need the "dentry->d_parent != dentry" test? When do we
 > > even rename root dentries?
 > 
 > Root of the filesystem - never; root of disconnected subtree - sure,
 > that's how they become connected to the tree.  See d_materialize_unique(),
 > for example...
 > 
 > BTW, I really need more coffee - those checks belong in __d_move(),
 > not d_move(); aforementioned d_materialize_unique() doesn't use d_move(),
 > it calls __d_move() directly.  Sorry.

np, I'll restart the build/test.

	Dave

