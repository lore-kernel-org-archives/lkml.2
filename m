Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756707Ab2ISRZk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 13:25:40 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:35045 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753954Ab2ISRZi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 13:25:38 -0400
Date: Wed, 19 Sep 2012 10:06:48 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Dave Jones <davej@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: RCU idle CPU detection is broken in linux-next
Message-ID: <20120919170648.GF2455@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <5050CCE0.4090403@gmail.com>
 <20120919153934.GB2455@linux.vnet.ibm.com>
 <5059F458.3000407@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5059F458.3000407@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091917-4242-0000-0000-000002F48D9F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 19, 2012 at 06:35:36PM +0200, Sasha Levin wrote:
> On 09/19/2012 05:39 PM, Paul E. McKenney wrote:
> > On Wed, Sep 12, 2012 at 07:56:48PM +0200, Sasha Levin wrote:
> >> > Hi Paul,
> >> > 
> >> > While fuzzing using trinity inside a KVM tools guest, I've managed to trigger
> >> > "RCU used illegally from idle CPU!" warnings several times.
> >> > 
> >> > There are a bunch of traces which seem to pop exactly at the same time and from
> >> > different places around the kernel. Here are several of them:
> > Hello, Sasha,
> > 
> > OK, interesting.  Could you please try reproducing with the diagnostic
> > patch shown below?
> 
> Sure - here are the results (btw, it reproduces very easily):
> 
> [ 13.525119] ================================================
> [ 13.527165] [ BUG: lock held when returning to user space! ]
> [ 13.528752] 3.6.0-rc6-next-20120918-sasha-00002-g190c311-dirty #362 Tainted: GW
> [ 13.531314] ------------------------------------------------
> [ 13.532918] init/1 is leaving the kernel with locks still held!
> [ 13.534574] 1 lock held by init/1:
> [ 13.535533] #0: (rcu_idle){.+.+..}, at: [<ffffffff811c36d0>]
> rcu_eqs_enter_common+0x1a0/0x9a0
> 
> I'm basically seeing lots of the above, so I can't even get to the point where I
> get the previous lockdep warnings.

OK, that diagnostic patch was unhelpful.  Back to the drawing board...

							Thanx, Paul

