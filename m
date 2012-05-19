Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1946197Ab2ESA7q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 20:59:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13470 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759853Ab2ESA7n (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 20:59:43 -0400
Date: Sat, 19 May 2012 01:59:32 +0100
From: Alasdair G Kergon <agk@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: koverstreet@google.com, axboe@kernel.dk, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, agk@redhat.com
Subject: Re: [dm-devel] [PATCH 12/13] Make generic_make_request handle
	arbitrarily large bios
Message-ID: <20120519005932.GM29330@agk-dp.fab.redhat.com>
Mail-Followup-To: Tejun Heo <tj@kernel.org>, koverstreet@google.com,
	axboe@kernel.dk, dm-devel@redhat.com, linux-kernel@vger.kernel.org,
	linux-bcache@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	agk@redhat.com
References: <cover.1337308722.git.koverstreet@google.com> <1114e7019b0055fc09a54b59b36398d5c54f5e32.1337308722.git.koverstreet@google.com> <20120518175216.GL19388@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120518175216.GL19388@google.com>
Organization: Red Hat UK Ltd. Registered in England and Wales, number
	03798903. Registered Office: 64 Baker Street, 4th floor, London,
	W1U 7DF.
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 18, 2012 at 10:52:16AM -0700, Tejun Heo wrote:
> Does this by any chance allow killing ->merge_bvec_fn()?

merge_bvec also has an impact on efficiency.

Why create a too-large bio in the first place if it's only going to have to
get split up again?

If a change like this goes in, the various trade-offs should be re-examined.

Alasdair
