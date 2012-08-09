Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759408Ab2HIAPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 20:15:05 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:38358 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758531Ab2HIAPC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 20:15:02 -0400
Date: Wed, 8 Aug 2012 17:14:27 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Mike Snitzer <snitzer@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, mpatocka@redhat.com,
        vgoyal@redhat.com, yehuda@hq.newdream.net, tj@kernel.org,
        sage@newdream.net, agk@redhat.com, drbd-dev@lists.linbit.com
Subject: Re: [PATCH v5 05/12] block: Kill bi_destructor
Message-ID: <20120809001427.GD7262@moria.home.lan>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-6-git-send-email-koverstreet@google.com>
 <20120807031921.GA31977@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120807031921.GA31977@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 06, 2012 at 11:19:21PM -0400, Mike Snitzer wrote:
> On Mon, Aug 06 2012 at  6:08pm -0400,
> Kent Overstreet <koverstreet@google.com> wrote:
> 
> > Now that we've got generic code for freeing bios allocated from bio
> > pools, this isn't needed anymore.
> > 
> > This also changes the semantics of bio_free() a bit - it now also frees
> > bios allocated by bio_kmalloc(). It's also no longer exported, as
> > without bi_destructor there should be no need for it to be called
> > anywhere else.
> 
> Seems you forgot to remove bio_free's EXPORT_SYMBOL

Whoops - thanks, fixed.
