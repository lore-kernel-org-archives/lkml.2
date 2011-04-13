Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933128Ab1DMQSb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Apr 2011 12:18:31 -0400
Received: from cantor.suse.de ([195.135.220.2]:38416 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932940Ab1DMQSZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Apr 2011 12:18:25 -0400
Date: Wed, 13 Apr 2011 09:17:16 -0700
From: Greg KH <gregkh@suse.de>
To: Patrick McHardy <kaber@trash.net>
Cc: linux-kernel@vger.kernel.org, stable@kernel.org, stable-review@kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, David Sterba <dsterba@suse.cz>
Subject: Re: [49/74] netfilter: h323: bug in parsing of ASN1 SEQOF field
Message-ID: <20110413161716.GA20829@suse.de>
References: <20110413155148.210947709@clark.kroah.org>
 <4DA5C95B.6000706@trash.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA5C95B.6000706@trash.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 13, 2011 at 06:03:39PM +0200, Patrick McHardy wrote:
> Am 13.04.2011 17:51, schrieb Greg KH:
> > 2.6.32-longterm review patch.  If anyone has any objections, please let us know.
> > 
> > ------------------
> > 
> > From: David Sterba <dsterba@suse.cz>
> > 
> > commit b4232a22776aa5d063f890d21ca69870dbbe431b upstream.
> > 
> > Static analyzer of clang found a dead store which appears to be a bug in
> > reading count of items in SEQOF field, only the lower byte of word is
> > stored. This may lead to corrupted read and communication shutdown.
> > 
> > The bug has been in the module since it's first inclusion into linux
> > kernel.
> > 
> > [Patrick: the bug is real, but without practical consequence since the
> >  largest amount of sequence-of members we parse is 30.]
> 
> As mentioned in the changelog, I don't think this patch is of any
> relevance for -stable since its a purely theoretical problem.

Ok, thanks, now removed from the queue.

greg k-h
