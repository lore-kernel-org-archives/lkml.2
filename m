Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030520Ab2HXU6W (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Aug 2012 16:58:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:41657 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030240Ab2HXU6R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Aug 2012 16:58:17 -0400
Date: Fri, 24 Aug 2012 13:58:12 -0700
From: Tejun Heo <tj@kernel.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Kent Overstreet <koverstreet@google.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, vgoyal@redhat.com,
        mpatocka@redhat.com, bharrosh@panasas.com,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Peter Osterlund <petero2@telia.com>, Sage Weil <sage@inktank.com>
Subject: Re: [PATCH v6 11/13] block: Rework bio_pair_split()
Message-ID: <20120824205812.GJ21325@google.com>
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
 <1345655050-28199-12-git-send-email-koverstreet@google.com>
 <20120822210410.GL19212@google.com>
 <yq1y5l5hvpw.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1y5l5hvpw.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Martin.

On Thu, Aug 23, 2012 at 10:25:47PM -0400, Martin K. Petersen wrote:
> However, I'm not sure I like the overall approach of the new splitting.
> Instead of all this cloning, slicing and dicing of bio_vecs I'd rather
> we bit the bullet and had an offset + length for the vector inside each
> bio. That way we could keep the bio_vec immutable and make clones more
> lightweight since their vecs would always point to the parent. This also
> makes it trivial to split I/Os in the stacking drivers and removes evils
> in the partial completion code path. It would also allow to sever the
> ties between "size of block range operated on" vs. bi_size which we need
> for copy offload, discard, etc.

Yeah, I'm fairly sure we all want that but that's gonna have to be a
separate not-so-small project.  Also, how we split underlying bvec
doesn't affect the split interface update being done here.  This
patchset is updating split so that it can handle arbirarily sized
bios, which is useful whether its implementation is using immutable
bvec or COWing it.

Thanks.

-- 
tejun
