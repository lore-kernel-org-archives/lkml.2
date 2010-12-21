Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752258Ab0LUO0u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Dec 2010 09:26:50 -0500
Received: from mail-bw0-f45.google.com ([209.85.214.45]:61320 "EHLO
	mail-bw0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751927Ab0LUO0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Dec 2010 09:26:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sjLgjbSWREtId+VbYeivboHzWBH4cUtX1EtFVxhUtfTo/kdJ8FHGDAWOLsUCxkN0/+
         qNpKSRQP0HomNLTOJd567fmB1Uz62oEZZ1iekG7kUu2wQre/HFYu6XiDNmFQD8FoYalL
         6uYRd+4iqKj9hhI2ozpApqSRsKCi6OHSglG0I=
Date: Tue, 21 Dec 2010 15:26:43 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: LKML <linux-kernel@vger.kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Steven Rostedt <rostedt@goodmis.org>,
        Lai Jiangshan <laijs@cn.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Anton Blanchard <anton@au1.ibm.com>,
        Tim Pepper <lnxninja@linux.vnet.ibm.com>
Subject: Re: [RFC PATCH 15/15] nohz_task: Procfs interface
Message-ID: <20101221142641.GI1750@nowhere>
References: <1292858662-5650-1-git-send-email-fweisbec@gmail.com>
 <1292858662-5650-16-git-send-email-fweisbec@gmail.com>
 <1292859744.5021.4.camel@laptop>
 <20101220155737.GA1742@nowhere>
 <1292861799.5021.27.camel@laptop>
 <20101221012418.GI1715@nowhere>
 <1292919280.5021.203.camel@laptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292919280.5021.203.camel@laptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 09:14:40AM +0100, Peter Zijlstra wrote:
> On Tue, 2010-12-21 at 02:24 +0100, Frederic Weisbecker wrote:
> > 
> > > Also, I'm not quite happy with the pure userspace restriction, but at
> > > least I see why you did that event though you didn't mention that.
> > 
> > What do you mean? The fact that kernel threads can not be nohz task? 
> 
> No, that you key off kernel/user boundary transitions. Arguably one
> could allow simply system calls and page-faults to happen without
> restarting the tick

This is what I do.

> then again, RCU is very pervasive these days so I'm
> not quite sure you can actually make that happen.

No it looks ok. If we entered the kernel and the tick is stopped, we
just exit the extended quiescent state from rcu point of view.

But because we don't tick, we don't notify quiescent state and
so rcu might notice an extended grace period. Then it will
send us the IPI that will make us restart the tick to make us
notifying quiescent states.
