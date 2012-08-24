Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030233Ab2HXC0P (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Aug 2012 22:26:15 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:25677 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932135Ab2HXC0M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Aug 2012 22:26:12 -0400
To: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>, linux-bcache@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com, vgoyal@redhat.com,
        mpatocka@redhat.com, bharrosh@panasas.com,
        Jens Axboe <axboe@kernel.dk>, NeilBrown <neilb@suse.de>,
        Lars Ellenberg <lars.ellenberg@linbit.com>,
        Peter Osterlund <petero2@telia.com>, Sage Weil <sage@inktank.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v6 11/13] block: Rework bio_pair_split()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle
References: <1345655050-28199-1-git-send-email-koverstreet@google.com>
	<1345655050-28199-12-git-send-email-koverstreet@google.com>
	<20120822210410.GL19212@google.com>
Date: Thu, 23 Aug 2012 22:25:47 -0400
In-Reply-To: <20120822210410.GL19212@google.com> (Tejun Heo's message of "Wed,
	22 Aug 2012 14:04:10 -0700")
Message-ID: <yq1y5l5hvpw.fsf@sermon.lab.mkp.net>
User-Agent: Gnus/5.130005 (Ma Gnus v0.5) Emacs/24.0.97 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> "Tejun" == Tejun Heo <tj@kernel.org> writes:

Tejun> I complained about this in the last posting and in the previous
Tejun> patch.  Please respond.  Martin, are you okay with these
Tejun> integrity changes?

I missed the first several iterations of all this while I was out on
vacation. I'll have to try to wrap my head around the new approach.

However, I'm not sure I like the overall approach of the new splitting.
Instead of all this cloning, slicing and dicing of bio_vecs I'd rather
we bit the bullet and had an offset + length for the vector inside each
bio. That way we could keep the bio_vec immutable and make clones more
lightweight since their vecs would always point to the parent. This also
makes it trivial to split I/Os in the stacking drivers and removes evils
in the partial completion code path. It would also allow to sever the
ties between "size of block range operated on" vs. bi_size which we need
for copy offload, discard, etc.

-- 
Martin K. Petersen	Oracle Linux Engineering
