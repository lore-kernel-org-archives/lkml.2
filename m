Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753905Ab1CVWhH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Mar 2011 18:37:07 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:52415 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751939Ab1CVWhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Mar 2011 18:37:05 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=XYJHFtupD_QA:10 a=5AMJFd0FRxYA:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=PZ4ppi3ymc145MsgPx4A:9 a=KuJVh36FunGghv2rj4oA:7 a=kult7QAeYQwSn-WcOgpqoPnFv6oA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Tue, 22 Mar 2011 18:37:02 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: David Collins <collinsd@codeaurora.org>
Cc: Liam Girdwood <lrg@slimlogic.co.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Deadlock scenario in regulator core
Message-ID: <20110322223702.GO14675@home.goodmis.org>
References: <4D891C59.1030009@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D891C59.1030009@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 22, 2011 at 03:02:01PM -0700, David Collins wrote:
> Assume that A has already called regulator_enable for S1 some time in the
> past.
> 
> Consumer A thread execution:
> 	regulator_disable(S1)
> 	mutex_lock(S1)
> 	_regulator_disable(S1)
> 	_notifier_call_chain(S1)
> 	mutex_lock(L2)
> 
> Consumer B thread execution:
> 	regulator_enable(L2)
> 	mutex_lock(L2)
> 	_regulator_enable(L2)
> 	mutex_lock(S1)
> 
> The locks for S1 and L2 are taken in opposite orders in the two threads;
> therefore, it is possible to achieve deadlock.  I am not sure about the
> best way to resolve this situation.  Is there a correctness requirement
> that regulator_enable holds the child regulator's lock when it attempts to
> enable the parent regulator?  Likewise, is the lock around
> _notifier_call_chain required?

I'm curious, if you had enabled lockdep, do you get a warning? If not,
why not?

Thanks,

-- Steve

