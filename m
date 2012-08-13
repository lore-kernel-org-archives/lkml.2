Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755137Ab2HMWHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 18:07:43 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58152 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755002Ab2HMWFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 18:05:39 -0400
Date: Mon, 13 Aug 2012 15:05:34 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v5 08/12] block: Introduce new bio_split()
Message-ID: <20120813220534.GB25632@google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-9-git-send-email-koverstreet@google.com>
 <20120808225839.GG6983@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120813215511.GE9541@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120813215511.GE9541@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Mon, Aug 13, 2012 at 02:55:11PM -0700, Kent Overstreet wrote:
> > If the condition is detectable, WARN_ON_ONCE() please.
> 
> I know I said I liked this idea, but I changed my mind.
> 
> Sticking a WARN_ON_ONCE() there is saying that passing __GFP_WAIT from
> under generic_make_request() is always wrong - it might as well be a
> BUG_ON() except warn is better for the user.

WARN_ON_ONCE(), as opposed to BUG_ON(), doesn't mean that something
isn't always wrong.  It's just better to always use WARN variant if
the system doesn't *need* to be put down immediately to avoid, say,
massive data corruption - limping machine is simply better than dead
one.

> If that's true, then an assertion is completely wrong because we can
> just do the right thing instead - mask out __GFP_WAIT if
> current->bio_list != NULL and document that it can fail in that
> situation.

That's worse because it confuses the reader.  Taking something which
is as well-known as __GFP_WAIT and then silently ignoring it isn't a
good idea.  Please just add a WARN_ON.

Thanks.

-- 
tejun
