Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758746Ab2HUWTO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Aug 2012 18:19:14 -0400
Received: from fieldses.org ([174.143.236.118]:44726 "EHLO fieldses.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758711Ab2HUWTL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Aug 2012 18:19:11 -0400
Date: Tue, 21 Aug 2012 18:19:08 -0400
From: "J. Bruce Fields" <bfields@fieldses.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Jim Rees <rees@umich.edu>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] strings: helper for maximum decimal encoding of an
 unsigned integer
Message-ID: <20120821221908.GD19185@fieldses.org>
References: <20120821212910.GD18637@fieldses.org>
 <20120821212227.GA14194@umich.edu>
 <20120821220613.GK23464@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120821220613.GK23464@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 21, 2012 at 11:06:13PM +0100, Al Viro wrote:
> On Tue, Aug 21, 2012 at 05:22:27PM -0400, Jim Rees wrote:
> > J. Bruce Fields wrote:
> > 
> >   From: "J. Bruce Fields" <bfields@redhat.com>
> >   
> >   I've seen a couple examples recently where we've gotten this wrong.
> >   Maybe something like this would help?  Is there some better way?
> >   
> >   (Approximation due to Jim Rees).
> > 
> > Please add Suggested-by: Jim Rees <rees@umich.edu>.  I'm thinking of
> > patenting the algorithm.
> 
> Is that a joke?  Patenting the fact that log10(256) is 2.408..., which
> is about 2.4, which is 24/10?  I really hope we are Poe'd...  BTW, NAK
> the comment - s/36/26/ in there; check it yourself -
> $ echo '2^(8*27)' | bc
> 105312291668557186697918027683670432318895095400549111254310977536
> which is 66-digit, not 65 as the estimate would be.

Erp, you're right.

Anyway, does something like base10len(type) seem reasonable?  Or define
macros that enumerate the sizes?  (ULONG_STR_MAX or something?)

--b.
