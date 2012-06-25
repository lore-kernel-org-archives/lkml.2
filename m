Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754779Ab2FYJK1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jun 2012 05:10:27 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:48694 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752136Ab2FYJKZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jun 2012 05:10:25 -0400
Date: Mon, 25 Jun 2012 02:10:23 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Cong Wang <xiyou.wangcong@gmail.com>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: BUG: tracer_alloc_buffers returned with preemption imbalance
In-Reply-To: <20120625035733.GU2516@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.00.1206250208210.24381@chino.kir.corp.google.com>
References: <20120623101251.GA10162@localhost> <20120623170147.GI2516@linux.vnet.ibm.com> <20120623174830.GA5617@localhost> <CAM_iQpW-vtnHUOBoROueui-FCrw9zB4U3vwy=PnEOLXP713WWw@mail.gmail.com> <20120625035733.GU2516@linux.vnet.ibm.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 24 Jun 2012, Paul E. McKenney wrote:

> But in my case, the trailing preempt_enable() should not have been
> optimized away, right?  Wouldn't it be more like the following?
> 
> int a = 0;
> int main(void)
> {
> 	a++;
> 	return ++a;
> 	a++;
> }
> 
> Hmmm...  But this -still- doesn't emit any warnings.
> 

gcc removed -Wunreachable-code a couple years ago.  It doesn't complain 
when you pass it for backwards compatibility with old Makefiles.
