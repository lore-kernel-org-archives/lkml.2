Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758217Ab2IJXNc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 19:13:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62387 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460Ab2IJXNa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 19:13:30 -0400
Date: Mon, 10 Sep 2012 16:13:26 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, axboe@kernel.dk, Vivek Goyal <vgoyal@redhat.com>,
        Mikulas Patocka <mpatocka@redhat.com>, bharrosh@panasas.com,
        david@fromorbit.com
Subject: Re: [PATCH 2/2] block: Avoid deadlocks with bio allocation by
 stacking drivers
Message-ID: <20120910231326.GG7677@google.com>
References: <1347055973-11581-3-git-send-email-koverstreet@google.com>
 <20120908193641.GB12773@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120910002810.GA23241@moria.home.lan>
 <20120910172210.GC14103@google.com>
 <20120910202435.GG16360@google.com>
 <20120910204010.GA32310@google.com>
 <20120910213349.GH16360@google.com>
 <20120910213710.GA7677@google.com>
 <20120910215633.GA19739@google.com>
 <20120910220910.GB7677@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910220910.GB7677@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, again.

On Mon, Sep 10, 2012 at 03:09:10PM -0700, Tejun Heo wrote:
> I'm still a bit scared but think this is correct.
> 
>  Acked-by: Tejun Heo <tj@kernel.org>
> 
> One last thing is that we may want to add @name on bioset creation so
> that we can name the workqueue properly but that's for another patch.

Yet another thing that I noticed in a different discussion.

  http://thread.gmane.org/gmane.linux.network.drbd.devel/2130

Before this, I think bios didn't get reordered while they're traveling
down the stacked bio drivers.  After this, I don't think that's true
anymore.  Currently, IIRC, we don't have any ordering functionality at
bio interface, so I don't think this breaks anything but this can lead
to stupidly subtle bugs if the upper layer is making assumption on
ordering somehow.  It's something which at least should be noted, I
think.  Whether we want to update the code so that ordering is
maintained, I don't know.  I hope not.  It's already crazy complex. :(

Thanks.

-- 
tejun
