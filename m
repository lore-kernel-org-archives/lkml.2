Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752380Ab0JRAI3 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Oct 2010 20:08:29 -0400
Received: from bld-mail16.adl2.internode.on.net ([150.101.137.101]:58070 "EHLO
	mail.internode.on.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751896Ab0JRAI2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Oct 2010 20:08:28 -0400
Date: Mon, 18 Oct 2010 11:07:47 +1100
From: Dave Chinner <david@fromorbit.com>
To: Eric Paris <eparis@parisplace.org>
Cc: Peter Zijlstra <peterz@infradead.org>, eparis@redhat.com,
        Mimi Zohar <zohar@linux.vnet.ibm.com>,
        Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        Mimi Zohar <zohar@us.ibm.com>, warthog9@kernel.org, hpa@zytor.com,
        devel@lists.fedoraprojet.org
Subject: Re: ima: use of radix tree cache indexing == massive waste of
 memory?
Message-ID: <20101018000747.GH29677@dastard>
References: <20101016065206.GO4681@dastard>
 <20101016192027.GA6883@infradead.org>
 <1287295077.3020.83.camel@localhost.localdomain>
 <1287313332.1998.172.camel@laptop>
 <AANLkTinNbF9=5Ojn8kKEvSkGbpqQw+DGKyRWhAD1AYZK@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinNbF9=5Ojn8kKEvSkGbpqQw+DGKyRWhAD1AYZK@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 17, 2010 at 09:12:47AM -0400, Eric Paris wrote:
> We could split this into 2 structures, thus greatly shrinking the size
> of the structure needed for the default/disabled case, but it doesn't

I don't think the 128 byte structure is a big problem. If this is
too much overhead, then add a boot parameter to enable storage of
IMA information that defaults to disabled. That way it can be
compiled in with no runtime overhead at all and only those that want
to use can turn it on.

> help the fact that the suggested structure for storage (the radix
> tree) is apparently quite inefficient.  I'd love to hear other
> suggestions for a better structure....

You've just answered the question I asked in my bug posting.  Use an
rbtree or btree instead if you want to use the address of the struct
inode as the lookup key.  If you want to use a denser key such as
inode->i_ino, you're going to need to handle duplicates which means
you still can't use a radix tree.

Hence I think a btree or rbtree is your simplest solution as there
are library functions for implementing them.

Cheers,

Dave.
-- 
Dave Chinner
david@fromorbit.com
