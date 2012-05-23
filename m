Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933066Ab2EWRYm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 13:24:42 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47131 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753056Ab2EWRYk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 13:24:40 -0400
Date: Wed, 23 May 2012 10:24:35 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Bcache v13 11/16] bcache: Core btree code
Message-ID: <20120523172435.GB18143@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <7f1de39b6d7040b3fe271500776f4b985b21ea82.1336619038.git.koverstreet@google.com>
 <20120522221259.GJ14339@google.com>
 <20120523034546.GB607@dhcp-172-18-216-138.mtv.corp.google.com>
 <20120523052054.GB29976@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120523053403.GB14312@dhcp-172-18-216-138.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120523053403.GB14312@dhcp-172-18-216-138.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, May 23, 2012 at 01:34:03AM -0400, Kent Overstreet wrote:
> On Tue, May 22, 2012 at 10:20:54PM -0700, Tejun Heo wrote:
> > Hmmm... I would prefer it to be defined explicitly as union.  It's
> > rather easy to define it incorrectly (ie. using struct bkey) and then
> > pass it around expecting it to have the pad.
> 
> Thing is, things don't expect the pad - bkeys are normally just in a big
> chunk of memory concatenated together, and the same functions have to
> work both with those and with bare bkeys the code occasionally
> manipulates.

Hmmm... so it's actually just padding?  Padding for what?  I thought
it was there to provide space for ptr[], no?

> > I'm a bit confused.  Cache device or cached device?  Isn't the key
> > dev:offset:size of the cached device?
> 
> No - bkey->key is the offset on the cached device, PTR_OFFSET is on the
> cache.
> 
> Confusing, I know. Any ideas for better terminology?

Double confused by the "no" and the following sentence seemingly
agreeing with what I wrote.  So, bkey->key indexes the backend device
- the slow big disk and the associated PTRs point into the fast SSD
caching device, right?  If so, I think 'key' is fine, that's the only
thing which can be key anyway.  As for PTR_XXX, maybe something which
can signify they're the cache would be nicer but with proper comments
I don't think it's big deal.

Thanks.

-- 
tejun
