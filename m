Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754760Ab2HIGeP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Aug 2012 02:34:15 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:62927 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751034Ab2HIGeL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Aug 2012 02:34:11 -0400
MIME-Version: 1.0
In-Reply-To: <20120809061214.GA9128@dhcp-172-18-216-138.mtv.corp.google.com>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
	<1344290921-25154-6-git-send-email-koverstreet@google.com>
	<20120808222223.GD6983@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120809002154.GE7262@moria.home.lan>
	<20120809060517.GB2845@dhcp-172-17-108-109.mtv.corp.google.com>
	<20120809061214.GA9128@dhcp-172-18-216-138.mtv.corp.google.com>
Date: Wed, 8 Aug 2012 23:34:09 -0700
X-Google-Sender-Auth: _EnrB3GkL6kW7VzsgYYz__ugD7w
Message-ID: <CAOS58YOHZmNWezg0uDhDeKP1dAt8fmmcLjmzKGShrw6PCpCFpg@mail.gmail.com>
Subject: Re: [PATCH v5 05/12] block: Kill bi_destructor
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, vgoyal@redhat.com, mpatocka@redhat.com,
        sage@newdream.net, yehuda@hq.newdream.net
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Wed, Aug 8, 2012 at 11:12 PM, Kent Overstreet <koverstreet@google.com> wrote:
> But if it's a pointer to heap allocated memory, but the bio was embedded
> in another struct? I've seen a fair number of instances of that (md, off
> the top of my head).
>
> If you're sure that in a normal config the slab allocator is going to
> complain right away and not corrupt itself, fine. But I've been bitten
> way too hard by bugs that could've been caught right away by a simple
> assert and instead I had to spend hours backtracking, and the block
> layer is _rife_ with that kind of thing.

Let's let slab debug code deal with that.  I really don't see much
benefit in doing this.  The said kind of bugs aren't particularly
difficult to track down.

Thanks.

-- 
tejun
