Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756492Ab2IXPee (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:34:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45756 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756411Ab2IXPed convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:34:33 -0400
Message-ID: <1348500861.11847.72.camel@twins>
Subject: Re: [PATCH RFC 2/2] kvm: Be courteous to other VMs in overcommitted
 scenario in PLE handler
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@redhat.com>,
        Rik van Riel <riel@redhat.com>, Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Date: Mon, 24 Sep 2012 17:34:21 +0200
In-Reply-To: <50607BBE.8070507@redhat.com>
References: <20120921115942.27611.67488.sendpatchset@codeblue>
	 <20120921120019.27611.66093.sendpatchset@codeblue>
	 <50607BBE.8070507@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-09-24 at 17:26 +0200, Avi Kivity wrote:
> I think this is a no-op these (CFS) days.  To get schedule() to do
> anything, you need to wake up a task, or let time pass, or block.
> Otherwise it will see that nothing has changed and as far as it's
> concerned you're still the best task to be running (otherwise it
> wouldn't have picked you in the first place). 

Time could have passed enough before calling this that there's now a
different/more eligible task around to schedule.

Esp. for a !PREEMPT kernel this is could be significant.
