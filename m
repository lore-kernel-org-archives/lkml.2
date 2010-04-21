Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756217Ab0DUS5A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Apr 2010 14:57:00 -0400
Received: from kandzendo.ru ([195.178.208.66]:43597 "EHLO tservice.net.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756185Ab0DUS46 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Apr 2010 14:56:58 -0400
X-Greylist: delayed 1079 seconds by postgrey-1.27 at vger.kernel.org; Wed, 21 Apr 2010 14:56:58 EDT
Date: Wed, 21 Apr 2010 22:56:57 +0400
From: Evgeniy Polyakov <zbr@ioremap.net>
To: Jamie Lokier <jamie@shareable.org>
Cc: Phillip Susi <psusi@cfl.rr.com>, linux-fsdevel@vger.kernel.org,
       Linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: readahead on directories
Message-ID: <20100421185657.GA21249@ioremap.net>
References: <4BCC7C05.8000803@cfl.rr.com> <20100421004434.GA27420@shareable.org> <4BCF123C.6010400@cfl.rr.com> <20100421161211.GC27575@shareable.org> <20100421183853.GA14897@ioremap.net> <20100421185124.GM27575@shareable.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100421185124.GM27575@shareable.org>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 21, 2010 at 07:51:24PM +0100, Jamie Lokier (jamie@shareable.org) wrote:
> Fwiw, I found sorting directories by inode and reading them in that
> order help to reduce seeks, some 10 years ago.  I implemented
> something like 'find' which works like that, keeping a queue of
> directories to read and things to open/stat, ordered by inode number
> seen in d_ino before open/stat and st_ino after.  However it did not
> try to readahead the blocks inside a directory, or sort operations by
> block number.  It reduced some 'find'-like operations to about a
> quarter of the time on cold cache.  I still use that program sometimes
> before "git status" ;-)  Google "treescan" and "lokier" if you're
> interested in trying it (though I use 0.7 which isn't published).

As you might expect it is not really a directory readahead :)
Nad I'm not really sure ext234 can implement it in kernel more optimally
without breaking backward compatibility though.

> > it is not about readdir(). Plain read() is synchronous too. But
> > filesystem can respond to readahead calls and read next block to current
> > one, while it won't do this for next direntry.
> 
> I'm surprised it makes much difference, as directories are usually not
> very large anyway.

Well, having several tens of millions of files in 64k dirs takes from tens of
seconds to minutes to read just because of that.

> But if it does, go on, try FIEMAP and blockdev reading, you know you
> want to :-)

Well, it requires substantial underlying fs knowledge and is not simple
and, well, appropriate to do in some cases.

-- 
	Evgeniy Polyakov
