Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755835Ab1G1NvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jul 2011 09:51:24 -0400
Received: from smtp102.prem.mail.ac4.yahoo.com ([76.13.13.41]:48300 "HELO
	smtp102.prem.mail.ac4.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755816Ab1G1NvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jul 2011 09:51:21 -0400
X-Yahoo-Newman-Property: ymail-3
X-YMail-OSG: bztAqFcVM1l366L3ewQ_NOYDZrchb2xUTbMuWOWRCATXh3L
 _F138dMDY2spVSPNSvljL8xDQw68msMOcq_176.WwxMo34Lb7iu.ZH0z6tgy
 YRRI0DldZO5Y8CeaQQBt14_SUS_jN1svEQkuFC811FjaIhx7372ucNylBVSr
 c85BZ8j0GpjYg4L2B5iLAwnJg0MBsSCAayaSNnpLn.KqpZQWsQReme3cOQY6
 ATj3hc4u7XPG2cdhkjNBbFiQN5yIX2qufqt765AJFlFzwxtSoEq2gQSZpJ50
 X9TgLh0zSlX_3ejax_qds3KqHWH3hYRd9n.adF2PzSsjesm73
X-Yahoo-SMTP: _Dag8S.swBC1p4FJKLCXbs8NQzyse1SYSgnAbY0-
Date: Thu, 28 Jul 2011 08:50:57 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@router.home
To: Thomas Gleixner <tglx@linutronix.de>
cc: Peter Zijlstra <peterz@infradead.org>, Tejun Heo <tj@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@us.ibm.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@elte.hu>, eric.dumazet@gmail.com
Subject: Re: per-cpu operation madness vs validation
In-Reply-To: <alpine.LFD.2.02.1107280006510.2660@ionos>
Message-ID: <alpine.DEB.2.00.1107280847270.12379@router.home>
References: <1311714410.24752.404.camel@twins>  <alpine.DEB.2.00.1107261624210.10273@router.home>  <1311768693.24752.488.camel@twins>  <alpine.DEB.2.00.1107270904290.9418@router.home> <1311783616.5890.178.camel@twins> <alpine.DEB.2.00.1107271204260.13058@router.home>
 <alpine.LFD.2.02.1107271919500.2660@ionos> <alpine.DEB.2.00.1107271542530.17752@router.home> <alpine.LFD.2.02.1107280006510.2660@ionos>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 28 Jul 2011, Thomas Gleixner wrote:

> We just have to understand, that preempt_disable, bh_disable,
> irq_disable are cpu local BKLs with very subtle semantics which are
> pretty close to the original BKL horror. All these mechanisms are per
> cpu locks in fact and we need to get some annotation in place which
> will help understandability and debugability in the first place. The
> side effect that it will help RT to deal with that is - of course
> desired from our side - but not the primary goal of that excercise.

Well the use of the per cpu atomic operations instead of disabling
preemption or scheduling helps RT too by removing the need to do so from
critical OS paths. F.e. we were able to remove most of that from counter
increments. There is still some more work to be done with these
byte/packet counters there as well.

