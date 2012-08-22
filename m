Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755919Ab2HVTzz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 15:55:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53674 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752170Ab2HVTzv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 15:55:51 -0400
Date: Wed, 22 Aug 2012 12:55:46 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, vgoyal@redhat.com, mpatocka@redhat.com,
        bharrosh@panasas.com, Peter Osterlund <petero2@telia.com>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: [PATCH v6 04/13] pktcdvd: Switch to bio_kmalloc()
Message-ID: <20120822195546.GG19212@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-5-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1345655050-28199-5-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc'ing Jiri, hi!)

On Wed, Aug 22, 2012 at 10:04:01AM -0700, Kent Overstreet wrote:
> This is prep work for killing bi_destructor - previously, pktcdvd had
> its own pkt_bio_alloc which was basically duplication bio_kmalloc(),
> necessitating its own bi_destructor implementation.
> 
> v5: Un-reorder some functions, to make the patch easier to review
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>
> CC: Peter Osterlund <petero2@telia.com>

Apart from bio_reset() not resetting bi_end_io and bi_private, this
looks fine to me but lack of testing makes me a bit hesitant to ack
it.

Peter doesn't want to be the maintainer of pktcdvd anymore.  Maybe
Jiri can be tricked into taking this one too?  :)

Thanks.

-- 
tejun
