Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980Ab2JSPQp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 11:16:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3459 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752234Ab2JSPQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 11:16:44 -0400
Date: Fri, 19 Oct 2012 11:16:28 -0400
From: Mike Snitzer <snitzer@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, vgoyal@redhat.com
Subject: Re: [PATCH v4 00/24] Prep work for immutable bio vecs
Message-ID: <20121019151628.GA9496@redhat.com>
References: <1350331769-14856-1-git-send-email-koverstreet@google.com>
 <20121019011445.GJ13370@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121019011445.GJ13370@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18 2012 at  9:14pm -0400,
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Mon, Oct 15, 2012 at 01:08:34PM -0700, Kent Overstreet wrote:
> > Since last time - split bio integrity stuff out into its own 2 patch series.
> > 
> > Also changed bio_advance() a bit - it now explicitly special cases discard and
> > WRITE_SAME requests, so that partial completions will work. Previously, partial
> > completions worked for other requests but would've silently blown up for those
> > - this'll be of use later too, for generic bio splitting.
> > 
> > I've got 3 patch series queued up but they all should be independent - git tree
> > is at
> > 
> > http://evilpiepirate.org/git/linux-bcache.git for-jens
> > 
> > It's on top of jens' for-next branch.
> 
> Your patch series posting is messed up somehow.  I'm gonna review from
> the git branch and post comments here but you'll probably have to post
> them again.

Kent's threading was definitely messed up in this wave.  But threading
aside, I think all the posted patches are what he intended.

Looks like the "3 patch series" mentioned above map to:

[PATCH v2 00/26] Prep work for immutable bio vecs
[PATCH v4 00/24] Prep work for immutable bio vecs
[PATCH v4 1/2] block: Fix a buffer overrun in bio_integrity_split()

So you can key off of "v2 xx/26" vs "v4 xx/24" vs "v4 x/2"

But, yeah, not ideal..
