Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754725Ab2K3ASZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 19:18:25 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:40422 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752859Ab2K3ASX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 19:18:23 -0500
Date: Thu, 29 Nov 2012 16:18:21 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Zheng Liu <wenqing.lz@taobao.com>,
        Jeff liu <jeff.liu@oracle.com>, Jim Meyering <jim@meyering.net>,
        Paul Eggert <eggert@cs.ucla.edu>,
        Christoph Hellwig <hch@infradead.org>, Josef Bacik <josef@redhat.com>,
        Andi Kleen <andi@firstfloor.org>, Andreas Dilger <adilger@dilger.ca>,
        Dave Chinner <david@fromorbit.com>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        Chris Mason <chris.mason@fusionio.com>,
        Sunil Mushran <sunil.mushran@oracle.com>, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] tmpfs: support SEEK_DATA and SEEK_HOLE (reprise)
Message-Id: <20121129161821.8103962c.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.1211291522550.3226@eggly.anvils>
References: <alpine.LNX.2.00.1211281706390.1516@eggly.anvils>
	<20121129145924.9fb05982.akpm@linux-foundation.org>
	<alpine.LNX.2.00.1211291522550.3226@eggly.anvils>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 29 Nov 2012 15:29:15 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> On Thu, 29 Nov 2012, Andrew Morton wrote:
> > On Wed, 28 Nov 2012 17:22:03 -0800 (PST)
> > Hugh Dickins <hughd@google.com> wrote:
> > 
> > > +/*
> > > + * llseek SEEK_DATA or SEEK_HOLE through the radix_tree.
> > > + */
> > > +static pgoff_t shmem_seek_hole_data(struct address_space *mapping,
> > > +				    pgoff_t index, pgoff_t end, int origin)
> > 
> > So I was starting at this wondering what on earth "origin" is and why
> > it has the fishy-in-this-context type "int".
> > 
> > There is a pretty well established convention that the lseek seek mode
> > is called "whence".
> > 
> > The below gets most of it.  Too anal?
> 
> No, not too anal: I'm all in favour of "whence", which is indeed
> the name of that lseek argument - since mediaeval times I believe.

Alas, the rest of us don't have personal memories from those days.

> It's good to have words like that in the kernel source: while you're
> in the mood, please see if you can find good homes for "whither" and
> "thrice" and "widdershins".

We use "thrice" quite a lot.  And "whither" once coz alfa peeps cnat spel. 
No widdershins yet.

