Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757482Ab2BBV7R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 16:59:17 -0500
Received: from merlin.infradead.org ([205.233.59.134]:42839 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751322Ab2BBV7Q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 16:59:16 -0500
Message-ID: <1328219944.2446.277.camel@twins>
Subject: Re: [PATCH] backing-dev: use synchronize_rcu_expedited instead of
 synchronize_rcu
From: Peter Zijlstra <peterz@infradead.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: axboe@kernel.dk, "Alasdair G. Kergon" <agk@redhat.com>,
        dm-devel@redhat.com, linux-kernel@vger.kernel.org,
        "Paul E. McKenney" <paulmck@us.ibm.com>
Date: Thu, 02 Feb 2012 22:59:04 +0100
In-Reply-To: <Pine.LNX.4.64.1202021538570.9035@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.1107202019420.26781@hs20-bc2-1.build.redhat.com>
	 <1328042063.2446.250.camel@twins>
	 <Pine.LNX.4.64.1202021538570.9035@hs20-bc2-1.build.redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.1- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-02 at 15:43 -0500, Mikulas Patocka wrote:
> Do you have some measurable use case where the user is removing block 
> devices so heavily that this causes a problem? 

Even one can be a problem, we're having people spend lots of time and
effort to reduce machine wide jitter and interference. Adding it with
such disregard isn't cool.

There's no reason a management cpu adding or removing block devices
should perturb the high-freq trading or industrial laser control running
on the other side of the machine.
