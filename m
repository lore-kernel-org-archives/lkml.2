Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752793Ab2E1Bwd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 May 2012 21:52:33 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40160 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab2E1Bw1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 May 2012 21:52:27 -0400
Date: Mon, 28 May 2012 10:52:11 +0900
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com,
        bharrosh@panasas.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v3 06/16] block: Add an explicit bio flag for bios that
 own their bvec
Message-ID: <20120528015211.GF9891@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1337977539-16977-1-git-send-email-koverstreet@google.com>
 <1337977539-16977-7-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337977539-16977-7-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 01:25:29PM -0700, Kent Overstreet wrote:
> This is for the new bio splitting code. When we split a bio, if the
> split occured on a bvec boundry we reuse the bvec for the new bio. But
> that means bio_free() can't free it, hence the explicit flag.

I keep having the same complaints.  The explanation isn't detailed
enough.  So, the necessity for this patch arises from the fact that
the current bio_split doesn't use the usual bio allocation path to
create split bio - it just supports fixed bvec allocation via bio_pair
allocation which is allowable because of the severe restrictions the
current bio_split() - but the new bio_split() wants to do it in
general manner and thus wants the usual bvec allocation.

Why do I (or anyone for that matter) have to go forward in the patch
series to reconstruct the rationale?  Why doesn't the patch
description already explain this?  Why isn't this still fixed when
lack of proper patch description has already been pointed out multiple
times?

I'm gonna stop here on this series.

* *Please* spend more effort on patch description and understanding
  and applying the reviews.  If you don't like the opinions expressed
  in reviews, please argue.  If reviews get ignored, why would anyone
  review your patches at all?

* It would probably be better to split the series so that more
  experimental / constroversial stuff is in separate patch series.

Thanks.

-- 
tejun
