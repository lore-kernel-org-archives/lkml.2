Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755438Ab2ALV0d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 16:26:33 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:43568 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754520Ab2ALV0b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 16:26:31 -0500
Date: Thu, 12 Jan 2012 13:26:29 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Hocko <mhocko@suse.cz>
Cc: Mel Gorman <mgorman@suse.de>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        David Rientjes <rientjes@google.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH] mm: __count_immobile_pages make sure the node is online
Message-Id: <20120112132629.345e0e37.akpm@linux-foundation.org>
In-Reply-To: <20120112123555.GF1042@tiehlicka.suse.cz>
References: <1326213022-11761-1-git-send-email-mhocko@suse.cz>
	<alpine.DEB.2.00.1201101326080.10821@chino.kir.corp.google.com>
	<20120111084802.GA16466@tiehlicka.suse.cz>
	<20120112111702.3b7f2fa2.kamezawa.hiroyu@jp.fujitsu.com>
	<20120112082722.GB1042@tiehlicka.suse.cz>
	<20120112173536.db529713.kamezawa.hiroyu@jp.fujitsu.com>
	<20120112092314.GC1042@tiehlicka.suse.cz>
	<20120112183323.1bb62f4d.kamezawa.hiroyu@jp.fujitsu.com>
	<20120112100521.GD1042@tiehlicka.suse.cz>
	<20120112111415.GH4118@suse.de>
	<20120112123555.GF1042@tiehlicka.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 12 Jan 2012 13:35:55 +0100
Michal Hocko <mhocko@suse.cz> wrote:

> On Thu 12-01-12 11:14:15, Mel Gorman wrote:
> > On Thu, Jan 12, 2012 at 11:05:21AM +0100, Michal Hocko wrote:
> 
> > Be aware that this is not the version picked up by Andrew. It would
> > not hurt to resend as V2 with a changelog and a note saying it replaces
> > mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch in mmotm.

They're rather different things? According to the changelogs,
mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch fixes a
known-to-occur oops. 
mm-__count_immobile_pages-make-sure-the-node-is-online.patch fixes a
bug which might happen in the future if we change the node_zones layut?

So I'm thinking that
mm-fix-null-ptr-dereference-in-__count_immobile_pages.patch is 3.3 and
-stable material, whereas this patch
(mm-__count_immobile_pages-make-sure-the-node-is-online.patch) is 3.3
material.  (Actually, it's 3.4 material which I shall stuff into 3.3
because the amount of MM material which we're putting into 3.3 is just
off the charts and I fear that 3.4 will be similar)

> > This is just in case the wrong one gets merged due to this thread
> > getting lost in the noise of Andrew's inbox.

It won't get lost, but there's a higher-than-usual chance of delays if
the patch happens during the merge window: if I see a lengthy patch
thread I'll move it into my to-apply folder for consideration later on.
So I will look at it, but it might be after the merge window.  We can
still apply a fix after the merge window of course, but this all might
end up leaving buggy code in the tree for longer than we'd like.

