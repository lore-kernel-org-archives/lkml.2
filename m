Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756070Ab0E2JHS (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 May 2010 05:07:18 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:40254 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753409Ab0E2JHL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 May 2010 05:07:11 -0400
Date: Sat, 29 May 2010 05:07:08 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Sage Weil <sage@newdream.net>, linux-kernel@vger.kernel.org,
       linux-fsdevel@vger.kernel.org
Subject: Re: [git pull] vfs pile, part 2
Message-ID: <20100529090708.GA20606@infradead.org>
References: <20100528155102.GK31073@ZenIV.linux.org.uk> <Pine.LNX.4.64.1005281221090.27944@cobra.newdream.net> <20100528194753.GL31073@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100528194753.GL31073@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 28, 2010 at 08:47:53PM +0100, Al Viro wrote:
> My apologies, I thought you'd been Cc'd on the discussions with Ian concerning
> that stuff, but...
> 
> The bottom line: "autofs4: always use lookup for lookup" is needed for them
> and it had to be reverted since it'd been FUBAR.
> 
> Details: we really, *really* can not do things in ->d_revalidate() and count
> on ->lookup() to come and finish them.  Think for a minute and you'll see why -
> between these two calls we allocate a dentry to pass to ->lookup().  What
> happens if that allocation fails?
> 
> And without that patch your stuff breaks autofs4.  So it's waiting for the
> ->d_revalidate() interface redesign.  Hopefully in the coming cycle...

In addition to that autofs also needs either major surgery or to be
dropped.  If we want to do the latter we'd be better of to strongly
deprecate it now.

