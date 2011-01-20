Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755523Ab1ATMsJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jan 2011 07:48:09 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:42699 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752933Ab1ATMsH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jan 2011 07:48:07 -0500
Date: Thu, 20 Jan 2011 07:47:30 -0500
From: Christoph Hellwig <hch@infradead.org>
To: Nitin Gupta <ngupta@vflare.org>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>,
        "Kirill A. Shutemov" <kirill@shutemov.name>,
        Pekka Enberg <penberg@cs.helsinki.fi>,
        Hugh Dickins <hugh.dickins@tiscali.co.uk>,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <greg@kroah.com>,
        Rik van Riel <riel@redhat.com>, Avi Kivity <avi@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Konrad Wilk <konrad.wilk@oracle.com>, linux-mm <linux-mm@kvack.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/8] zcache: page cache compression support
Message-ID: <20110120124730.GA7284@infradead.org>
References: <1279283870-18549-1-git-send-email-ngupta@vflare.org20110110131626.GA18407@shutemov.name>
 <9e7aa896-ed1f-4d50-8227-3a922be39949@default>
 <4D382B99.7070005@vflare.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D382B99.7070005@vflare.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 20, 2011 at 07:33:29AM -0500, Nitin Gupta wrote:
> I just started looking into kztmem (weird name!) but on
> the high level it seems so much similar to zcache with some
> dynamic resizing added (callback for shrinker interface).
> 
> Now, I'll try rebuilding zcache according to new cleancache
> API as provided by these set of patches. This will help refresh
> whatever issues I was having back then with pagecache
> compression and maybe pick useful bits/directions from
> new kztmem work.

Yes, we shouldn't have two drivers doing almost the same in the
tree.  Also adding core hooks for staging drivers really is against
the idea of staging of having a separate crap tree.  So it would be
good to get zcache into a state where we can merge it into the
proper tree first.  And then we can discuss if adding an abstraction
layer between it and the core VM really makes sense, and if it does
how.   But I'm pretty sure there's now need for multiple layers of
abstraction for something that's relatively core VM functionality.

E.g. the abstraction should involve because of it's users, not the
compressed caching code should involve because it's needed to present
a user for otherwise useless code.
