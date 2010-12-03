Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932301Ab0LCD61 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Dec 2010 22:58:27 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:47721 "HELO mail.gmx.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with SMTP
	id S932199Ab0LCD60 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Dec 2010 22:58:26 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+EKF95PziEsEVm9Tsn+H2cR7Y3NH6uYcNiFJQ8hQ
	7rq/gS/iaFsjkA
Subject: Re: mmotm 2010-11-23 + autogroups -> inconsistent lock state
From: Mike Galbraith <efault@gmx.de>
To: paulmck@linux.vnet.ibm.com
Cc: Valdis.Kletnieks@vt.edu, akpm@linux-foundation.org,
        Ingo Molnar <mingo@elte.hu>, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20101202181658.GG2085@linux.vnet.ibm.com>
References: <201011240045.oAO0jYQ5016010@imap1.linux-foundation.org>
	 <6003.1290574869@localhost> <1290630325.4050.12.camel@maggy.simson.net>
	 <20101202181658.GG2085@linux.vnet.ibm.com>
Content-Type: text/plain
Date: Fri, 03 Dec 2010 04:58:22 +0100
Message-Id: <1291348702.7633.33.camel@marge.simson.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.24.1.1 
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-02 at 10:16 -0800, Paul E. McKenney wrote:
> On Wed, Nov 24, 2010 at 01:25:25PM -0700, Mike Galbraith wrote:
>  
> > Despite task groups being freed via rcu, update_shares_cup() hits freed
> > memory and explodes, and nothing I've tried has been able to stop it.
> > The only thing I haven't tried (aside from the right thing;) is to take
> > rcu out of the picture entirely.
> 
> Is your new autogroup structure retaining a pointer to memory that
> is freed by RCU?

That turned out to be a typo that left freed cfs_rq registered.  No dark
elves (memory ordering), just a defenseless little typo.

	-Mike

