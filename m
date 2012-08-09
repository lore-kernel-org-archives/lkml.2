Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755498Ab2HIRc0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 13:32:26 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:34850 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750791Ab2HIRcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 13:32:23 -0400
Date: Thu, 9 Aug 2012 10:32:17 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net, martin.petersen@oracle.com
Subject: Re: [PATCH v5 08/12] block: Introduce new bio_split()
Message-ID: <20120809173217.GA6644@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
 <1344290921-25154-9-git-send-email-koverstreet@google.com>
 <20120808230532.GH6983@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120809013923.GH7262@moria.home.lan>
 <20120809072217.GH2845@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120809073334.GD9128@dhcp-172-18-216-138.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120809073334.GD9128@dhcp-172-18-216-138.mtv.corp.google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Aug 09, 2012 at 03:33:34AM -0400, Kent Overstreet wrote:
> > If you think the active dropping is justified, please let the change
> > and justification clearly stated.  You're burying the active change in
> > two separate patches without even mentioning it or cc'ing people who
> > care about bio-integrity (Martin K. Petersen). 
> 
> Not intentionally, he isn't in MAINTAINERS so get_maintainers.pl missed
> it and it slipped by while I was looking for people to CC. Added him.

git-log is your friend.  For one-off patches, doing it this way might
be okay.  Higher layer maintainer would be able to redirect it but if
you intend to change block layer APIs significantly as you try to do
in this patch series, you need to be *way* more diligent than you
currently are.  At least I feel risky about acking patches in this
series.

* Significant change is buried without explicitly mentioning it or
  discussing its implications.

* The patchset makes block layer API changes which impact multiple
  stacking and low level drivers which are not particularly known for
  simplicity and robustness, but there's no mention of how the patches
  are tested and/or why the patches would be safe (e.g. reviewed all
  the users and tested certain code paths and am fairly sure all the
  changes should be safe because xxx sort of deal).  When asked about
  testing, not much seems to have been done.

* Responses and iterations across patch postings aren't responsive or
  reliable, making it worrisome what will happen when things go south
  after this hits mainline.

You're asking reviewers and maintainers to take a lot more risks than
they usually have to, which isn't a good way to make forward progress.

Thanks.

-- 
tejun
