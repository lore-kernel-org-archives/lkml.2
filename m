Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab2FLRpd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 13:45:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:50951 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab2FLRpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 13:45:32 -0400
Date: Tue, 12 Jun 2012 10:45:28 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Joe Perches <joe@perches.com>
Cc: g@google.com, linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tejun@google.com, agk@redhat.com,
        dan.j.williams@intel.com
Subject: Re: [Bcache v14 16/16] bcache: Debug and tracing code
Message-ID: <20120612174528.GB11365@google.com>
References: <1339515562-14638-1-git-send-email-koverstreet@google.com>
 <1339515562-14638-17-git-send-email-koverstreet@google.com>
 <1339519858.2017.10.camel@joe2Laptop>
 <20120612172444.GA11365@google.com>
 <1339522543.2404.3.camel@joe2Laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339522543.2404.3.camel@joe2Laptop>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 12, 2012 at 10:35:43AM -0700, Joe Perches wrote:
> "(uint64_t *)k - i->d" is what type again?
> What is a %zu?
> 
> Isn't that a mismatch?

You're right - ssize_t and size_t. I think gcc just isn't checking
signedness at all, that %i should be a %u too. Good catch.

> 
> > > > +static int debug_seq_show(struct seq_file *f, void *data)
> > > > +{
> > > > +	static const char *tabs = "\t\t\t\t\t";
> > > 
> > > Seems a _very_ odd use.
> > 
> > It is a strange hack.
> > 
> > The idea is that we want to indent more as we recurse; we could build up
> > a new string of tabs each time we recurse that's got one more tab than
> > our parent's, but that'd be a pain in the ass and it'd use more stack
> > space (though that should be fine here), so instead it's just
> > decrementing the pointer to the tab string to produce a string with one
> > more tab.
> 
> It's a nice idea, but that's not what's happening
> as I believe you reference tabs only once as &tabs[4]

bch_btree_dump() prints out tabs, and passes tabs - 1 when it recurses.
