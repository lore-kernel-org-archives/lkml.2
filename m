Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753303Ab1FXHqd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jun 2011 03:46:33 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38804 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752015Ab1FXHqc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jun 2011 03:46:32 -0400
Subject: Re: [patch 3/4] stop_machine: implement
 stop_machine_from_offline_cpu()
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "mingo@elte.hu" <mingo@elte.hu>, "tglx@linutronix.de" <tglx@linutronix.de>,
        "hpa@zytor.com" <hpa@zytor.com>, "trenn@novell.com" <trenn@novell.com>,
        "prarit@redhat.com" <prarit@redhat.com>,
        "tj@kernel.org" <tj@kernel.org>,
        "rusty@rustcorp.com.au" <rusty@rustcorp.com.au>,
        "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "torvalds@linux-foundation.org" <torvalds@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Song, Youquan" <youquan.song@intel.com>
In-Reply-To: <1308853153.15847.90.camel@sbsiddha-MOBL3.sc.intel.com>
References: <20110622222021.904952469@sbsiddha-MOBL3.sc.intel.com>
	 <20110622222044.038298780@sbsiddha-MOBL3.sc.intel.com>
	 <1308821119.1022.84.camel@twins>
	 <1308853153.15847.90.camel@sbsiddha-MOBL3.sc.intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Fri, 24 Jun 2011 09:45:34 +0200
Message-ID: <1308901534.27849.10.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-06-23 at 11:19 -0700, Suresh Siddha wrote:
> > In commit d0af9eed5aa91b6b7b5049cae69e5ea956fd85c3 you mention that its
> > specific to HT, wouldn't it make sense to limit the stop-machine use in
> > the next patch to the sibling mask instead of the whole machine?
> 
> That specific issue was seen in the context of HT. But the SDM
> guidelines (pre date HT and) are applicable for SMP too. 

Sure, but we managed to ignore those long enough, could we not continue
to violate them and keep to the minimum that is working in practice?

>From what I understand the explosion is WSM+/VMX on HT only because the
siblings share state, or do we have proof that it yields problems
between cores as well?
