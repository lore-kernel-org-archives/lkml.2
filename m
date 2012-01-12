Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754233Ab2ALQIY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 11:08:24 -0500
Received: from seven.medozas.de ([188.40.89.202]:38585 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754132Ab2ALQIX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 11:08:23 -0500
Date: Thu, 12 Jan 2012 17:08:21 +0100 (CET)
From: Jan Engelhardt <jengelh@medozas.de>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Eric Dumazet <eric.dumazet@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>, laijs@cn.fujitsu.com,
        manfred@colorfullife.com, dhowells@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rcu: avoid checking for constant
In-Reply-To: <20120112152912.GB2419@linux.vnet.ibm.com>
Message-ID: <alpine.LNX.2.01.1201121657001.24875@frira.zrqbmnf.qr>
References: <1326345104-6919-1-git-send-email-jengelh@medozas.de> <20120112071431.GA1896@leaf> <alpine.LNX.2.01.1201121018430.31943@frira.zrqbmnf.qr> <20120112095257.GA2441@leaf> <alpine.LNX.2.01.1201121106040.17330@frira.zrqbmnf.qr>
 <1326365659.2950.3.camel@edumazet-HP-Compaq-6005-Pro-SFF-PC> <alpine.LNX.2.01.1201121154530.21275@frira.zrqbmnf.qr> <20120112152912.GB2419@linux.vnet.ibm.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 2012-01-12 16:29, Paul E. McKenney wrote:

>On Thu, Jan 12, 2012 at 11:57:10AM +0100, Jan Engelhardt wrote:
>> On Thursday 2012-01-12 11:54, Eric Dumazet wrote:
>> 
>> >Le jeudi 12 janvier 2012 à 11:34 +0100, Jan Engelhardt a écrit :
>> >
>> >> When compiling kernel or module code with -O0, "offset" is no longer
>> >> considered a constant, and therefore always triggers the build error
>> >> that BUILD_BUG_ON is defined to yield.
>> >
>> >Why compiling kernel with -O0 is even considered ?
>> 
>> The compile error was observed when trying to compile an out-of-tree 
>> module with -O0.
>
>Hmmm...  Why not have a glue .c file in your out-of-tree module
>that contains function like[...]

Maybe, maybe naah. The kernel relying on gcc's -O2 mode to do constant 
value analysis through and into inline functions does not sound too 
great. The compiler could change on the next moonphase. In fact, one 
can't use clang -O2 because of this. With my patch, one can again use 
clang -O2 [with respect to kfree_rcu].
