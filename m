Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754017Ab2ALPe2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 10:34:28 -0500
Received: from e4.ny.us.ibm.com ([32.97.182.144]:47782 "EHLO e4.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753958Ab2ALPe1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 10:34:27 -0500
Date: Thu, 12 Jan 2012 07:29:12 -0800
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Jan Engelhardt <jengelh@medozas.de>
Cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>, laijs@cn.fujitsu.com,
        manfred@colorfullife.com, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: avoid checking for constant
Message-ID: <20120112152912.GB2419@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1326345104-6919-1-git-send-email-jengelh@medozas.de>
 <20120112071431.GA1896@leaf>
 <alpine.LNX.2.01.1201121018430.31943@frira.zrqbmnf.qr>
 <20120112095257.GA2441@leaf>
 <alpine.LNX.2.01.1201121106040.17330@frira.zrqbmnf.qr>
 <1326365659.2950.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC>
 <alpine.LNX.2.01.1201121154530.21275@frira.zrqbmnf.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.01.1201121154530.21275@frira.zrqbmnf.qr>
User-Agent: Mutt/1.5.21 (2010-09-15)
x-cbid: 12011215-3534-0000-0000-000004775036
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 12, 2012 at 11:57:10AM +0100, Jan Engelhardt wrote:
> On Thursday 2012-01-12 11:54, Eric Dumazet wrote:
> 
> >Le jeudi 12 janvier 2012 à 11:34 +0100, Jan Engelhardt a écrit :
> >
> >> When compiling kernel or module code with -O0, "offset" is no longer
> >> considered a constant, and therefore always triggers the build error
> >> that BUILD_BUG_ON is defined to yield.
> >
> >Why compiling kernel with -O0 is even considered ?
> 
> The compile error was observed when trying to compile an out-of-tree 
> module with -O0.

Hmmm...  Why not have a glue .c file in your out-of-tree module
that contains function like:

	void kfree_rcu_foo(struct foo *fp)
	{
		kfree_rcu(fp, foo_rcu);
	}

Compile this .c file normally, then apply -O0 only to the other
files in your module.

							Thanx, Paul

