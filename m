Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755589Ab2IXNzN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 09:55:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48599 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755370Ab2IXNzI convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 09:55:08 -0400
Message-ID: <1348494895.11847.64.camel@twins>
Subject: Re: [PATCH RFC 0/2] kvm: Improving undercommit,overcommit scenarios
 in PLE handler
From: Peter Zijlstra <peterz@infradead.org>
To: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Avi Kivity <avi@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>, Andrew Jones <drjones@redhat.com>
Date: Mon, 24 Sep 2012 15:54:55 +0200
In-Reply-To: <50606050.309@linux.vnet.ibm.com>
References: <20120921115942.27611.67488.sendpatchset@codeblue>
	 <1348486479.11847.46.camel@twins> <50604988.2030506@linux.vnet.ibm.com>
	 <1348490165.11847.58.camel@twins> <50606050.309@linux.vnet.ibm.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 18:59 +0530, Raghavendra K T wrote:
> However Rik had a genuine concern in the cases where runqueue is not
> equally distributed and lockholder might actually be on a different run 
> queue but not running.

Load should eventually get distributed equally -- that's what the
load-balancer is for -- so this is a temporary situation.

We already try and favour the non running vcpu in this case, that's what
yield_to_task_fair() is about. If its still not eligible to run, tough
luck.

> Do you think instead of using rq->nr_running, we could get a global 
> sense of load using avenrun (something like avenrun/num_onlinecpus) 

To what purpose? Also, global stuff is expensive, so you should try and
stay away from it as hard as you possibly can.
