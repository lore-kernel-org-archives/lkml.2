Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752973Ab0DZJsP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 05:48:15 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:39587 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752838Ab0DZJsN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 05:48:13 -0400
Date: Mon, 26 Apr 2010 11:48:11 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: =?iso-8859-1?Q?J=F6rn?= Engel <joern@logfs.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       David Woodhouse <dwmw2@infradead.org>, linux-mtd@lists.infradead.org,
       linux-kernel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
Subject: Re: [Patch] Catch filesystems lacking s_bdi
Message-ID: <20100426094810.GE27497@kernel.dk>
References: <20100419101559.GA4145@logfs.org> <20100419102056.GS27497@kernel.dk> <20100422055448.GA27309@logfs.org> <20100422062631.GC27309@logfs.org> <alpine.LFD.2.00.1004220724170.9086@i5.linux-foundation.org> <alpine.LFD.2.00.1004220730280.9086@i5.linux-foundation.org> <20100422162709.GJ27497@kernel.dk> <20100422203358.GB30749@logfs.org> <20100423100532.GN27497@kernel.dk> <20100423205518.GB7008@logfs.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20100423205518.GB7008@logfs.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 23 2010, Jörn Engel wrote:
> On Fri, 23 April 2010 12:05:32 +0200, Jens Axboe wrote:
> > 
> > So it's probably safe and good enough as-is, I'll add it. Thanks!
> 
> I cannot see this patch in your tree yet.  Could be the weekend or a
> deliberate decision not to send this for 2.6.34-rc anymore.

It's there, I put it in yesterday. It's definitely 2.6.34-rc material, I
hope to submit it tonight.

> In case it was a deliberate decision, can we please make it explicit?  I
> don't like the idea of adding a BUG_ON() that potentially triggers for
> thousands of people this late in the stabilization process - but it is
> better than having people lose data.  Even if we already ran two stable
> kernels that way.
> 
> Damned if you do, damned if you don't. :(

Yeah, it's a bad situation to be in. I changed that BUG_ON() to a
WARN_ON(). I'm not too worried about that part, I'm more worried about
the file system changed. OTOH, they do lack proper flushing now, so it's
likely not a huge risk from that perspective.

-- 
Jens Axboe

