Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab1CWAHl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 20:07:41 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:38190 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755923Ab1CWAHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 20:07:39 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=5AMJFd0FRxYA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=qJ5E40sENuFz9wyZd3sA:9 a=s1HsB1tKvExfc_0C_DUA:7 a=mowh1lc_w7U_p1LCHOcjIc-D5HcA:4 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: Deadlock scenario in regulator core
From: Steven Rostedt <rostedt@goodmis.org>
To: David Collins <collinsd@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4D8933A8.8080607@codeaurora.org>
References: <4D891C59.1030009@codeaurora.org>
	 <20110322223702.GO14675@home.goodmis.org> <4D892C0A.1090606@codeaurora.org>
	 <1300835998.14261.13.camel@gandalf.stny.rr.com>
	 <4D8933A8.8080607@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 22 Mar 2011 20:07:36 -0400
Message-ID: <1300838856.14261.35.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-03-22 at 16:41 -0700, David Collins wrote:

> There seem to be very few uses of mutex_lock_nested() in the kernel.  Most
> of them use subclass = SINGLE_DEPTH_NESTING.  Would this be sufficient for
> usage in the regulator core in _notifier_call_chain (and perhaps other
> places) or should some other subclass be used?

Note, I do not know this code well enough to say. I'm assuming that an
rdevA on a rdevB->supply_list never has rdevB on its own
rdevA->supply_list.

If this is the case, and that you only ever have a lock nesting of one,
then sure, use the SINGLE_DEPTH_NESTING.

Peter or Ingo could correct me if I'm wrong.

-- Steve



