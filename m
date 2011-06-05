Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753487Ab1FEQ0a (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Jun 2011 12:26:30 -0400
Received: from smtp-out2.tiscali.nl ([195.241.79.177]:40189 "EHLO
	smtp-out2.tiscali.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752533Ab1FEQ03 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Jun 2011 12:26:29 -0400
Subject: [PATCH 0/5] Demystified CFQ Oops
From: Paul Bolle <pebolle@tiscali.nl>
To: Jens Axboe <axboe@kernel.dk>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        linux-kernel@vger.kernel.org, Vivek Goyal <vgoyal@redhat.com>
Date: Sun, 05 Jun 2011 18:26:18 +0200
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.1.1 (3.1.1-3.fc16) 
Content-Transfer-Encoding: 7bit
Message-ID: <1307291187.8545.41.camel@t41.thuisdomein>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a set of five commits that should demystify a CFQ Oops that I
was able to easily trigger on a laptop I use. (It is actually still
unclear why it was exactly so easy for me to trigger it on that laptop.)

This set contains one trivial fix, three clean-ups and one commit that
should actually fix this issue. The clean-ups were essential in helping
pinpoint the problem and should make review a lot easier.

Review of the last patch - which covers stuff rather unfamiliar to me -
would be especially appreciated.

I must admit that, while finalizing this set, I have not tested that the
set is cleanly bisectable (ie, that all commits lead to a tree that at
least builds). I could still do that, but perhaps there's someone with
more experience and especially with (much) more powerful hardware for
whom that would be much easier to do than for me.

Paul Bolle (5):
  CFQ: make two functions static
  Rename two struct members called "cic_list"
  CFQ: rename ioc_data to last_cic
  block: rename the return of two functions
  CFQ: use proper locking for cache of last hit cic

 block/blk-ioc.c           |   50 ++++++++++++++++++++++----------------------
 block/cfq-iosched.c       |   49 +++++++++++++++++++++++++++-----------------
 include/linux/iocontext.h |    6 ++--
 3 files changed, 58 insertions(+), 47 deletions(-)

-- 
1.7.5.2



