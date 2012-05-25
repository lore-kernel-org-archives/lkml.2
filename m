Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758993Ab2EYW7Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 18:59:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38292 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755340Ab2EYW7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 18:59:14 -0400
Date: Fri, 25 May 2012 23:58:52 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, tj@kernel.org,
        axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
        drbd-dev@lists.linbit.com, bharrosh@panasas.com, vgoyal@redhat.com,
        mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v3 13/16] Make generic_make_request handle arbitrarily
	large bios
Message-ID: <20120525225852.GG5761@agk-dp.fab.redhat.com>
Mail-Followup-To: Kent Overstreet <koverstreet@google.com>,
	linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
	dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, tj@kernel.org,
	axboe@kernel.dk, agk@redhat.com, neilb@suse.de,
	drbd-dev@lists.linbit.com, bharrosh@panasas.com, vgoyal@redhat.com,
	mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net
References: <1337977539-16977-1-git-send-email-koverstreet@google.com> <1337977539-16977-14-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337977539-16977-14-git-send-email-koverstreet@google.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 01:25:36PM -0700, Kent Overstreet wrote:
> But this approach becomes unwieldy and eventually breaks down with
> stacked devices and devices with dynamic limits, and it adds a lot of
> complexity. If the block layer could split bios as needed, we could

Complexity - yes - but if people didn't observe a genuine benefit, why
did they go to the trouble of writing this and getting it included?

> eliminate a lot of complexity elsewhere - particularly in stacked
> drivers. 

> Code that creates bios can then create whatever size bios are
> convenient, and more importantly stacked drivers don't have to deal with
> both their own bio size limitations and the limitations of the
> (potentially multiple) devices underneath them.

A theoretical argument.  Perhaps it's the right assessment of this
issue.  Perhaps it's not.  Or perhaps it depends on the use-case.

I made a theoretical argument from a different point of view in my last email.

I think a body of *empirical* evidence should provide the justification
for this particular change, and until such evidence is forthcoming we
should keep the status quo.

Alasdair

