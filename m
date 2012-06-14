Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab2FNJAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 05:00:05 -0400
Received: from www.linutronix.de ([62.245.132.108]:54717 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755189Ab2FNJAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 05:00:03 -0400
Date: Thu, 14 Jun 2012 10:59:58 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Namhyung Kim <namhyung@kernel.org>
cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [RFC patch 1/5] kthread: Implement park/unpark facility
In-Reply-To: <alpine.LFD.2.02.1206141020370.3086@ionos>
Message-ID: <alpine.LFD.2.02.1206141059290.3086@ionos>
References: <20120613102823.373180763@linutronix.de> <20120613105815.132283147@linutronix.de> <8762au62u1.fsf@sejong.aot.lge.com> <alpine.LFD.2.02.1206141020370.3086@ionos>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Jun 2012, Thomas Gleixner wrote:
> On Thu, 14 Jun 2012, Namhyung Kim wrote:
> > I wonder whether it also needs to unpark @k. Isn't it possible to stop a
> > parked thread?
> 
> Right, it should be possible and it is. Clearing the park flag is not
> strictly necessary, but yes we should do that.

And it's necessary as parkme() wont return otherwise :)
