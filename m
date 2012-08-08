Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759400Ab2HHXJz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 19:09:55 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49202 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759318Ab2HHXJu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 19:09:50 -0400
Date: Wed, 8 Aug 2012 16:09:44 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v5 09/12] block: Rework bio_pair_split()
Message-ID: <20120808230944.GI6983@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-10-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344290921-25154-10-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Aug 06, 2012 at 03:08:38PM -0700, Kent Overstreet wrote:
> This changes bio_pair_split() to use the new bio_split() underneath,
> which gets rid of the single page bio limitation. The various callers
> are fixed up for the slightly different struct bio_pair, and to remove
> the unnecessary checks.
> 
> v5: Move extern declaration to proper patch, per Boaz

I don't get this.  Why can't bio_split() chain the split to the
original one thus make bio_pair unnecessary?  It's not like completing
the split bio with the same end_io ever makes sense.

Thanks.

-- 
tejun
