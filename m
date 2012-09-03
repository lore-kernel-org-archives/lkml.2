Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756523Ab2ICQQG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 12:16:06 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35250 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756318Ab2ICQQD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 12:16:03 -0400
Date: Mon, 3 Sep 2012 18:15:52 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, vgoyal@redhat.com,
        mpatocka@redhat.com, bharrosh@panasas.com,
        Peter Osterlund <petero2@telia.com>
Subject: Re: [PATCH v6 04/13] pktcdvd: Switch to bio_kmalloc()
In-Reply-To: <20120822195546.GG19212@google.com>
Message-ID: <alpine.LNX.2.00.1209031814050.20709@pobox.suse.cz>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com> <1345655050-28199-5-git-send-email-koverstreet@google.com> <20120822195546.GG19212@google.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 22 Aug 2012, Tejun Heo wrote:

> > This is prep work for killing bi_destructor - previously, pktcdvd had
> > its own pkt_bio_alloc which was basically duplication bio_kmalloc(),
> > necessitating its own bi_destructor implementation.
> > 
> > v5: Un-reorder some functions, to make the patch easier to review
> > 
> > Signed-off-by: Kent Overstreet <koverstreet@google.com>
> > CC: Peter Osterlund <petero2@telia.com>
> 
> Apart from bio_reset() not resetting bi_end_io and bi_private, this
> looks fine to me but lack of testing makes me a bit hesitant to ack
> it.

I have just tested this v6 patchset (and it works for pktcddvd), only to 
see that Kent has sent out v7 (unfortunately he hasn't CCed me on it).

v6 works nicely, bus as far as I understand it, even in v7 we are not 
resetting bi_end_io and bi_private properly, right?

-- 
Jiri Kosina
SUSE Labs
