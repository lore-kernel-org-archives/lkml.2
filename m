Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758339Ab2IJXfK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 19:35:10 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49140 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757916Ab2IJXfH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 19:35:07 -0400
Date: Mon, 10 Sep 2012 16:35:02 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
        device-mapper development <dm-devel@redhat.com>, david@fromorbit.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>, bharrosh@panasas.com,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/2] block: Avoid deadlocks with bio
 allocation by stacking drivers
Message-ID: <20120910233502.GH7677@google.com>
References: <20120910172210.GC14103@google.com>
 <20120910202435.GG16360@google.com>
 <20120910204010.GA32310@google.com>
 <20120910213349.GH16360@google.com>
 <20120910213710.GA7677@google.com>
 <20120910215633.GA19739@google.com>
 <20120910220910.GB7677@google.com>
 <20120910225057.GA10477@agk-dp.fab.redhat.com>
 <CAOS58YO5puV2iPhwe0vbyEydPnR=eWPStNRm=xEpMeo-TMHCaw@mail.gmail.com>
 <20120910230917.GB10477@agk-dp.fab.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910230917.GB10477@agk-dp.fab.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Alasdair.

On Tue, Sep 11, 2012 at 12:09:17AM +0100, Alasdair G Kergon wrote:
> On Mon, Sep 10, 2012 at 04:01:01PM -0700, Tejun Heo wrote:
> > IIUC, Kent posted a patch which converts all of them to use front-pad
> 
> The only patch I saw posted here only handles one of the easier cases so far.
> 
> The others are a bit trickier and probably involve a decision about which way to
> change an in-kernel dm interface.

Ah, I see.  Thought that was full conversion.  I still think this is
the right direction to be headed tho.  Using multiple mempools from
the stacking drivers is way too fragile and difficult to verify and
debug.  Would it be difficult to convert dm drivers to collect size
requirements and use front-pad for all per-bio data?

Thanks.

-- 
tejun
