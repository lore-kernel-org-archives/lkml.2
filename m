Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968089Ab2ERVsJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 17:48:09 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:64931 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S968062Ab2ERVsE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 17:48:04 -0400
Date: Fri, 18 May 2012 14:48:01 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de
Subject: Re: [PATCH 06/13] block: Add bio_reset()
Message-ID: <20120518214801.GA32300@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <9953623f6fae97018e59d96971a2612caf6c01e7.1337308722.git.koverstreet@google.com>
 <20120518161608.GF19388@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518161608.GF19388@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 09:16:08AM -0700, Tejun Heo wrote:
> Hello,
> 
> On Thu, May 17, 2012 at 10:59:53PM -0400, koverstreet@google.com wrote:
> > From: Kent Overstreet <koverstreet@google.com>
> > 
> > Reusing bios is something that's been highly frowned upon in the past,
> > but driver code keeps doing it anyways. If it's going to happen anyways,
> > we should provide a generic method.
> > 
> > This'll help with getting rid of bi_destructor.
> 
> It would be nice to explain a bit why this helps bi_destructor
> removal.

drivers/block/pktcdvd.c was open coding this - it was doing a bio_init()
and then resetting bi_destructor (and other stuff). The generic
bio_reset() means it doesn't have to know about bi_destructor anymore.

> 
> > +#define BIO_RESET_OFFSET	offsetof(struct bio, bi_max_vecs)
> 
> Maybe better named BIO_RESET_BYTES?  As offset tends to indicate the
> start of a region.

Yeah, that's a better name.
