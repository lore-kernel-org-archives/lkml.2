Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752186Ab2LTAxt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 19:53:49 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:44981 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab2LTAxp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 19:53:45 -0500
Date: Wed, 19 Dec 2012 16:53:43 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Hugh Dickins <hughd@google.com>
Cc: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH] mm/swap: add independed bio pool for swap
Message-Id: <20121219165343.ccb3a956.akpm@linux-foundation.org>
In-Reply-To: <alpine.LNX.2.00.1212172024500.5927@eggly.anvils>
References: <20121214110118.8387.66431.stgit@zurg>
	<alpine.LNX.2.00.1212172024500.5927@eggly.anvils>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 17 Dec 2012 20:45:13 -0800 (PST)
Hugh Dickins <hughd@google.com> wrote:

> On Fri, 14 Dec 2012, Konstantin Khlebnikov wrote:
> 
> > This bio pool guarantees reclaiming progress for anonymous pages.
> > All avaliable bio in fs_bio_set may be borrowed by writeback which may
> > never ends, because disk too slow or broken. I have seen this situation in
> > real life in system where was a lot of bio requests to a loop device which
> > laying on top of special fuse-based filesystem.
> 
> Hmm, perhaps, I'm not at all sure.

It probably maybe perhaps makes sense.  Of course, you're screwed if
one of your swap devices is "disk too slow or broken".

My crystal ball tells me that the 2015 kernel will have a bioset per
physical device...

