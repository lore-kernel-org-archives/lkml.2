Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758043Ab0JWVku (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Oct 2010 17:40:50 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:41306 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab0JWVks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Oct 2010 17:40:48 -0400
Date: Sat, 23 Oct 2010 22:40:46 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Christoph Hellwig <hch@infradead.org>
Cc: Dave Chinner <david@fromorbit.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/21] fs: Protect inode->i_state with the inode->i_lock
Message-ID: <20101023214046.GS19804@ZenIV.linux.org.uk>
References: <1287622186-1935-1-git-send-email-david@fromorbit.com>
 <1287622186-1935-17-git-send-email-david@fromorbit.com>
 <20101022015622.GE19804@ZenIV.linux.org.uk>
 <20101022031431.GK12506@dastard>
 <20101022103705.GK19804@ZenIV.linux.org.uk>
 <20101022114033.GA8859@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101022114033.GA8859@infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 22, 2010 at 07:40:33AM -0400, Christoph Hellwig wrote:
> On Fri, Oct 22, 2010 at 11:37:05AM +0100, Al Viro wrote:
> > One more note: IMO sb list lock is better off inside the hash one; when we
> > do per-chain hash locks, we'll be better off if we don't have to hold sb
> > one over the entire chain search.
> 
> Why would you nest these two at all?

[already said off-list, but since the question had been here...]

Insertion in hash and into sb list.  We *probably* don't care about
atomicity of that pair, but in this case we are dealing with two
topmost locks of hierarchy that might become independent.  That really
can be done as a followup.
