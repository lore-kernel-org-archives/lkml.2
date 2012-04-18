Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753326Ab2DRMIu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 08:08:50 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:23481 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab2DRMIs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 08:08:48 -0400
X-Authority-Analysis: v=2.0 cv=IaEFqBWa c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=XQbtiDEiEegA:10 a=7aeNQT76kZUA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=1nSz6Ew-AAAA:8 a=a4_uneVjj7txR2gEEl4A:9 a=Uy1nVvS-j2C6ZxjBkQYA:7 a=PUjeQqilurYA:10 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1334750926.28106.36.camel@gandalf.stny.rr.com>
Subject: Re: BUG: sleeping function called from invalid context at
 kernel/mutex.c:271
From: Steven Rostedt <rostedt@goodmis.org>
To: "Alexander E. Patrakov" <patrakov@gmail.com>
Cc: paulmck@linux.vnet.ibm.com, linux-kernel@vger.kernel.org
Date: Wed, 18 Apr 2012 08:08:46 -0400
In-Reply-To: <1334724679.2019.20.camel@aep-desktop>
References: <1334561244.3339.7.camel@aep-desktop>
	 <20120418025626.GB23877@home.goodmis.org>
	 <20120418040636.GD2449@linux.vnet.ibm.com>
	 <1334724679.2019.20.camel@aep-desktop>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-18 at 10:51 +0600, Alexander E. Patrakov wrote:

> > > 
> > > Hmm, this can also be reported if you have an rcu leak. Which would also
> > > explain your memory leak. RCU is the kernel's "garbage collector" and if
> > > it gets stuck, then you will definitely start seeing memory leaks, as
> > > memory wont be freed.
> > 
> > If RCU is stuck, you should see RCU CPU stall warnings, which can
> > give clues as to what is causing RCU to get stuck.
> 
> Yes, there were such warnings, but all of them said that the stall ended
> before dump start. So nothing reportable here, but I have just found
> that https://bugzilla.novell.com/show_bug.cgi?id=754186 looks quite
> similar in the sense that it (and duplicates) also has undumpable stalls
> of increasing length, and IPv6 is in use both at home and at work.
> 

Do you see the RT throttling message too? That's a bug with an RT task
going haywire. If that is happening, an RT task may be preventing an RCU
grace period to finish, and causing the RCU stalls.

Just because they ended, doesn't mean that the problem went a way. If
RCU is being blocked, you will start to see memory leaks. As I said, RCU
works as the kernels garbage collector. If it stops or just slows down
significantly, memory does not get freed.

-- Steve


