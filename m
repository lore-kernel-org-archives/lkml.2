Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753309Ab2CLRza (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 13:55:30 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:50458 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751499Ab2CLRz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 13:55:29 -0400
Date: Mon, 12 Mar 2012 10:54:32 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Lai Jiangshan <eag0628@gmail.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org, tj@kernel.org
Subject: Re: [RFC PATCH 5/6] implement per-cpu&per-domain state machine
 call_srcu()
Message-ID: <20120312175432.GF2471@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
 <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
 <1331027858-7648-5-git-send-email-laijs@cn.fujitsu.com>
 <1331032571.11248.277.camel@twins>
 <CACvQF52tYmG4Bx+L+cTjVRbvQxj=sKiKrxhuv35H=fAFVvQJ2Q@mail.gmail.com>
 <1331048093.11248.317.camel@twins>
 <20120308195825.GC2412@linux.vnet.ibm.com>
 <1331374193.18960.13.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331374193.18960.13.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12031217-6148-0000-0000-0000042FF7E5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 10, 2012 at 11:09:53AM +0100, Peter Zijlstra wrote:
> On Thu, 2012-03-08 at 11:58 -0800, Paul E. McKenney wrote:
> > 
> > But I guess I should ask...  Peter, what do you expect the maximum
> > call_srcu() rate to be in your use cases?  If tens of thousands are
> > possible, some adjustments will be needed. 
> 
> The one call-site I currently have is linked to vma lifetimes, so yeah,
> I guess that that can be lots.

So the worst case would be if several processes with lots of VMAs were
to exit at about the same time?  If so, my guess is that call_srcu()
needs to handle several thousand callbacks showing up within a few
tens of microseconds.  Is that a reasonable assumption, or am I missing
an order of magnitude or two in either direction?

							Thanx, Paul

