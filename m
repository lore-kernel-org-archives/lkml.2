Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab2JJBvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 21:51:22 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:6303 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755250Ab2JJBvU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 21:51:20 -0400
X-Authority-Analysis: v=2.0 cv=YP4dOG6x c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=F0my4ousGMIA:10 a=QyXUC8HyAAAA:8 a=_AK6OjIAExR561qcSJwA:9 a=PUjeQqilurYA:10 a=dGJ0OcVc7YAA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Originating-IP: 74.67.115.198
Message-ID: <1349833878.24256.49.camel@gandalf.local.home>
Subject: Re: [ANNOUNCE] 3.6.1-rt1
From: Steven Rostedt <rostedt@goodmis.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>
Date: Tue, 09 Oct 2012 21:51:18 -0400
In-Reply-To: <1349828517.24256.47.camel@gandalf.local.home>
References: <alpine.LFD.2.02.1210091535140.10988@ionos>
	 <1349806792.24256.34.camel@gandalf.local.home>
	 <1349828517.24256.47.camel@gandalf.local.home>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-10-09 at 20:21 -0400, Steven Rostedt wrote:

> > 0007-stomp-machine-deal-clever-with-stopper-lock.patch
> 
> With this one, things have changed quite a bit. I'll take a deeper look
> at what you did and figure out how this applies to v3.0-rt.

It doesn't look like this patch is needed for v3.0-rt as the patch
addresses the new stop_machine_from_inactive_cpu() API used by the mtrr
code added by this commit:

commit 192d8857427dd23707d5f0b86ca990c3af6f2d74
Author: Suresh Siddha <suresh.b.siddha@intel.com>
Date:   Thu Jun 23 11:19:29 2011 -0700

    x86, mtrr: use stop_machine APIs for doing MTRR rendezvous


This was added in 3.1 so the patch is still required for v3.2-rt.

-- Steve


