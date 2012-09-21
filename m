Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756641Ab2IUAfa (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Sep 2012 20:35:30 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60470 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755058Ab2IUAf2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Sep 2012 20:35:28 -0400
Date: Thu, 20 Sep 2012 17:35:23 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, neilb@suse.de
Subject: Re: [PATCH v2 20/26] block: Add bio_for_each_segment_all()
Message-ID: <20120921003523.GX7264@google.com>
References: <1347322957-25260-1-git-send-email-koverstreet@google.com>
 <1347322957-25260-21-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1347322957-25260-21-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Sep 10, 2012 at 05:22:31PM -0700, Kent Overstreet wrote:
> This is part of the immutable bvec prep work; bio_for_each_segment() is
> going to have a different implementation so these need to be split
> apart.
>
> This change is also to better document the intent of code that's using
> it - bio_for_each_segment_all() is only legal to use for code that owns
> the bio.

How about something like following?

 __bio_for_each_segment() iterates bvecs from the specified index
 instead of bio->bv_idx.  Currently, the only usage is to walk all the
 bvecs after the bio has been advanced by specifying 0 index.

 To help immutable bvec implementation, replace it with
 bio_for_each_segment_all() which also better documents the intent of
 code that's using it.  Note that bio_for_each_segment_all() should
 only be used by the code which owns the bio.

-- 
tejun
