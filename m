Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754331Ab2IYOVe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 10:21:34 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44146 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753334Ab2IYOV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 10:21:29 -0400
Date: Tue, 25 Sep 2012 23:21:22 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Subject: Re: [PATCH RFC 1/2] kvm: Handle undercommitted guest case in PLE
 handler
Message-Id: <20120925232122.e6fabbc5c472148aeec70234@gmail.com>
In-Reply-To: <50616781.3000406@redhat.com>
References: <20120921115942.27611.67488.sendpatchset@codeblue>
	<20120921120000.27611.71321.sendpatchset@codeblue>
	<505C654B.2050106@redhat.com>
	<505CA2EB.7050403@linux.vnet.ibm.com>
	<50607F1F.2040704@redhat.com>
	<50615EE4.1040809@linux.vnet.ibm.com>
	<50616781.3000406@redhat.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Sep 2012 10:12:49 +0200
Avi Kivity <avi@redhat.com> wrote:

> It will.  The tradeoff is between false-positive costs (undercommit) and
> true positive costs (overcommit).  I think undercommit should perform
> well no matter what.
> 
> If we utilize preempt notifiers to track overcommit dynamically, then we
> can vary the spin time dynamically.  Keep it long initially, as we get
> more preempted vcpus make it shorter.

What will happen if we pin each vcpu thread to some core?
I don't want to see so many vcpu threads moving around without
being pinned at all.

In that case, we don't want to make KVM do any work of searching
a vcpu thread to yield to.

Thanks,
	Takuya
