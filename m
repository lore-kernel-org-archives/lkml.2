Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab2BCAbH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 19:31:07 -0500
Received: from e7.ny.us.ibm.com ([32.97.182.137]:38665 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753190Ab2BCAbE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 19:31:04 -0500
Date: Thu, 2 Feb 2012 16:29:02 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mikulas Patocka <mpatocka@redhat.com>, axboe@kernel.dk,
        "Alasdair G. Kergon" <agk@redhat.com>, dm-devel@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] backing-dev: use synchronize_rcu_expedited instead of
 synchronize_rcu
Message-ID: <20120203002902.GQ2518@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <Pine.LNX.4.64.1107202019420.26781@hs20-bc2-1.build.redhat.com>
 <1328042063.2446.250.camel@twins>
 <Pine.LNX.4.64.1202021538570.9035@hs20-bc2-1.build.redhat.com>
 <1328219944.2446.277.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328219944.2446.277.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12020300-5806-0000-0000-00001200CE68
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 02, 2012 at 10:59:04PM +0100, Peter Zijlstra wrote:
> On Thu, 2012-02-02 at 15:43 -0500, Mikulas Patocka wrote:
> > Do you have some measurable use case where the user is removing block 
> > devices so heavily that this causes a problem? 
> 
> Even one can be a problem, we're having people spend lots of time and
> effort to reduce machine wide jitter and interference. Adding it with
> such disregard isn't cool.
> 
> There's no reason a management cpu adding or removing block devices
> should perturb the high-freq trading or industrial laser control running
> on the other side of the machine.

Very true for real-time applications!

For the heavy trading apps, given Frederic's upcoming user-mode-idle work,
I can keep this stuff from perturbing the apps.  Still, batching would
be preferable.

							Thanx, Paul

