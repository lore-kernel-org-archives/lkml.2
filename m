Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754887Ab2IJVdz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 17:33:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:51091 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300Ab2IJVdx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 17:33:53 -0400
Date: Mon, 10 Sep 2012 14:33:49 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, Vivek Goyal <vgoyal@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>, bharrosh@panasas.com,
        david@fromorbit.com
Subject: Re: [PATCH 2/2] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120910213349.GH16360@google.com>
References: <1347055973-11581-1-git-send-email-koverstreet@google.com>
 <1347055973-11581-3-git-send-email-koverstreet@google.com>
 <20120908193641.GB12773@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120910002810.GA23241@moria.home.lan>
 <20120910172210.GC14103@google.com>
 <20120910202435.GG16360@google.com>
 <20120910204010.GA32310@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910204010.GA32310@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 01:40:10PM -0700, Tejun Heo wrote:
> Hello, Kent.
> 
> On Mon, Sep 10, 2012 at 01:24:35PM -0700, Kent Overstreet wrote:
> > And at that point, why duplicate that line of code? It doesn't matter that
> > much, but IMO a goto retry better labels what's actually going on (it's
> > something that's not uncommon in the kernel and if I see a retry label
> > in a function I pretty immediately have an idea of what's going on).
> > 
> > So we could do
> > 
> > retry:
> > p = mempool_alloc(bs->bio_pool, gfp_mask);
> > if (!p && gfp_mask != saved_gfp) {
> > 	punt_bios_to_rescuer(bs);
> > 	gfp_mask = saved_gfp;
> > 	goto retry;
> > }
> 
> Yes, we do retry loops if that makes the code simpler.  Doing that to
> save one extra alloc call, I don't think so.

"Simpler" isn't really an objective thing though. To me the goto version
is more obvious/idiomatic.

Eh. I'll do it your way, but consider this a formal objection :p
