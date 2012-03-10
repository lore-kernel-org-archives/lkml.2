Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753331Ab2CJKKh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Mar 2012 05:10:37 -0500
Received: from casper.infradead.org ([85.118.1.10]:50762 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab2CJKKg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Mar 2012 05:10:36 -0500
Message-ID: <1331374193.18960.13.camel@twins>
Subject: Re: [RFC PATCH 5/6] implement per-cpu&per-domain state machine
 call_srcu()
From: Peter Zijlstra <peterz@infradead.org>
To: paulmck@linux.vnet.ibm.com
Cc: Lai Jiangshan <eag0628@gmail.com>, Lai Jiangshan <laijs@cn.fujitsu.com>,
        linux-kernel@vger.kernel.org, mingo@elte.hu, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        rostedt@goodmis.org, Valdis.Kletnieks@vt.edu, dhowells@redhat.com,
        eric.dumazet@gmail.com, darren@dvhart.com, fweisbec@gmail.com,
        patches@linaro.org, tj@kernel.org
Date: Sat, 10 Mar 2012 11:09:53 +0100
In-Reply-To: <20120308195825.GC2412@linux.vnet.ibm.com>
References: <1331023359-6987-1-git-send-email-laijs@cn.fujitsu.com>
	 <1331027858-7648-1-git-send-email-laijs@cn.fujitsu.com>
	 <1331027858-7648-5-git-send-email-laijs@cn.fujitsu.com>
	 <1331032571.11248.277.camel@twins>
	 <CACvQF52tYmG4Bx+L+cTjVRbvQxj=sKiKrxhuv35H=fAFVvQJ2Q@mail.gmail.com>
	 <1331048093.11248.317.camel@twins>
	 <20120308195825.GC2412@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-03-08 at 11:58 -0800, Paul E. McKenney wrote:
> 
> But I guess I should ask...  Peter, what do you expect the maximum
> call_srcu() rate to be in your use cases?  If tens of thousands are
> possible, some adjustments will be needed. 

The one call-site I currently have is linked to vma lifetimes, so yeah,
I guess that that can be lots.
