Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509Ab2IKWH4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 18:07:56 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65472 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752289Ab2IKWHy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 18:07:54 -0400
Date: Tue, 11 Sep 2012 15:07:50 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, tj@kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [dm-devel] [PATCH v2 01/26] block: Convert integrity to
 bvec_alloc_bs(), and a bugfix
Message-ID: <20120911220750.GM19739@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-2-git-send-email-koverstreet@google.com>
 <20120911203643.GC17113@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120911203643.GC17113@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 11, 2012 at 04:36:43PM -0400, Vivek Goyal wrote:
> Also there seems to be too much happening in this patch. Please break
> it down in 2. First fix the bio integrity bug you mentioned then
> introduce your changes on top.

Oh, I forgot - the reason I squashed them into one patch is fixing the
bug came for free with the rest of the refactoring, and combining them
touches less code.

To fix the bug first, I'd have to reorder struct bio_pair and then just
delete two lines of code from bio_integrity_split(). But the reordering
is unnecessary with the refactoring.
