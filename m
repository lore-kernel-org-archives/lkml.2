Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab1CCPC6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Mar 2011 10:02:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:2518 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752886Ab1CCPC5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Mar 2011 10:02:57 -0500
From: Jeff Moyer <jmoyer@redhat.com>
To: Tao Ma <tm@tao.ma>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH] blktrace: Remove blk_fill_rwbs_rq.
References: <1299137380-4119-1-git-send-email-tm@tao.ma>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 03 Mar 2011 10:02:49 -0500
In-Reply-To: <1299137380-4119-1-git-send-email-tm@tao.ma> (Tao Ma's message of
	"Thu, 3 Mar 2011 15:29:40 +0800")
Message-ID: <x49k4ggs0va.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Tao Ma <tm@tao.ma> writes:

> From: Tao Ma <boyu.mt@taobao.com>
>
> If we enable trace events to trace block actions, We use
> blk_fill_rwbs_rq to analyze the corresponding actions
> in request's cmd_flags, but we only choose the minor 2 bits
> from it, so most of other flags(e.g, REQ_SYNC) are missing.
> For example, with a sync write we get:
> write_test-2409  [001]   160.013869: block_rq_insert: 3,64 W 0 () 258135 + 8 [write_test]
>
> Since now we have integrated the flags of both bio and request,
> it is safe to pass rq->cmd_flags directly to blk_fill_rwbs and
> blk_fill_rwbs_rq isn't needed any more.
>
> With this patch, after a sync write we get:
> write_test-2417  [000]   226.603878: block_rq_insert: 3,64 WS 0 () 258135 + 8 [write_test]

Looks good to me.  It looks like the limited number of flags passed
through was simply an oversight (going back even to when the bio and
request flags were not merged, there was still special casing for
discard, at least).

Anywho...

Acked-by: Jeff Moyer <jmoyer@redhat.com>
