Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753617Ab2ALNyu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jan 2012 08:54:50 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.124]:40611 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753548Ab2ALNyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jan 2012 08:54:47 -0500
X-Authority-Analysis: v=2.0 cv=A5HuztqG c=1 sm=0 a=ZycB6UtQUfgMyuk2+PxD7w==:17 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=Wroz8SIv9vwfVFJ9MTEA:9 a=PUjeQqilurYA:10 a=5vOrHW2sovkaMX9G:21 a=BVJakVZxG_kOtngF:21 a=ZycB6UtQUfgMyuk2+PxD7w==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.80.29
Message-ID: <1326376484.7642.65.camel@gandalf.stny.rr.com>
Subject: Re: [ANNOUNCE] 3.0.14-rt31
From: Steven Rostedt <rostedt@goodmis.org>
To: Tim Sander <tim.sander@hbm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Clark Williams <williams@redhat.com>, John Kacur <jkacur@redhat.com>
Date: Thu, 12 Jan 2012 08:54:44 -0500
In-Reply-To: <201201121118.34776.tim.sander@hbm.com>
References: <1324525237.5916.114.camel@gandalf.stny.rr.com>
	 <201201121118.34776.tim.sander@hbm.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-01-12 at 11:18 +0100, Tim Sander wrote:
> Hi Steven
> 
> I have just tested 3.0.14 with some local adaptions. Unfortunatly there we 
> have still two errors here:
> Reboot ( of upstart) fails sometimes fails with the following message:
> "reboot: Unable to execute shutdown: Bad address"

What's the bad address? Was there a kernel oops?

> This problem can probably easily worked around by catching a failed execution 
> and retry, but i am afraid that execution fails more often in other places and 
> leads to silent functionality failures.
> 
> and the running wild ksoftirqd0 most probably after the kernel message:
> "sched: RT throttling activated"

Hmm, that's not good. It means that an RT task is spinning too much.

> It also seems as if the system looks up after running ifconfig. But it seems as 
> if the error only shows up most of the times if i am not around.

s/looks/locks/ ?

If it happens after ifconfig, then obviously that looks to be something
to do with either the network driver or the network stack.

But there's really nothing I can do to look into this without more
information.

-- Steve


