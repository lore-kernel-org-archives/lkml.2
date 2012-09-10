Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758543Ab2IJXpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Sep 2012 19:45:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:7314 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758333Ab2IJXps (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Sep 2012 19:45:48 -0400
Date: Tue, 11 Sep 2012 00:45:34 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
        device-mapper development <dm-devel@redhat.com>, david@fromorbit.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        Mikulas Patocka <mpatocka@redhat.com>, bharrosh@panasas.com,
        Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [dm-devel] [PATCH 2/2] block: Avoid deadlocks with bio
	allocation by stacking drivers
Message-ID: <20120910234534.GD10477@agk-dp.fab.redhat.com>
Mail-Followup-To: Tejun Heo <tj@kernel.org>,
	Kent Overstreet <koverstreet@google.com>, axboe@kernel.dk,
	device-mapper development <dm-devel@redhat.com>,
	david@fromorbit.com, linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org, Mikulas Patocka <mpatocka@redhat.com>,
	bharrosh@panasas.com, Vivek Goyal <vgoyal@redhat.com>
References: <20120910202435.GG16360@google.com> <20120910204010.GA32310@google.com> <20120910213349.GH16360@google.com> <20120910213710.GA7677@google.com> <20120910215633.GA19739@google.com> <20120910220910.GB7677@google.com> <20120910225057.GA10477@agk-dp.fab.redhat.com> <CAOS58YO5puV2iPhwe0vbyEydPnR=eWPStNRm=xEpMeo-TMHCaw@mail.gmail.com> <20120910230917.GB10477@agk-dp.fab.redhat.com> <20120910233502.GH7677@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120910233502.GH7677@google.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 04:35:02PM -0700, Tejun Heo wrote:
> debug.  Would it be difficult to convert dm drivers to collect size
> requirements and use front-pad for all per-bio data?
 
I can't give a quick answer because a single bio may require a variable
number (depending on the bio content) of (sequential) mempool_allocs from the
same mempool to complete its processing, so we do have to audit all this very
carefully to see what can/can't be pulled out.

Alasdair

