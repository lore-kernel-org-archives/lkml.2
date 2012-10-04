Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557Ab2JDNHl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 09:07:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:34519 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932407Ab2JDNHj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 09:07:39 -0400
Message-ID: <1349356038.14388.3.camel@twins>
Subject: Re: [PATCH RFC 1/2] kvm: Handle undercommitted guest case in PLE
 handler
From: Peter Zijlstra <peterz@infradead.org>
To: Avi Kivity <avi@redhat.com>
Cc: Raghavendra K T <raghavendra.kt@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Ingo Molnar <mingo@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Srikar <srikar@linux.vnet.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        KVM <kvm@vger.kernel.org>, Jiannan Ouyang <ouyang@cs.pitt.edu>,
        chegu vinod <chegu_vinod@hp.com>,
        "Andrew M. Theurer" <habanero@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Srivatsa Vaddagiri <srivatsa.vaddagiri@gmail.com>,
        Gleb Natapov <gleb@redhat.com>
Date: Thu, 04 Oct 2012 15:07:18 +0200
In-Reply-To: <506D83EE.2020303@redhat.com>
References: <20120921115942.27611.67488.sendpatchset@codeblue>
	 <20120921120000.27611.71321.sendpatchset@codeblue>
	 <505C654B.2050106@redhat.com> <505CA2EB.7050403@linux.vnet.ibm.com>
	 <50607F1F.2040704@redhat.com> <20121003122209.GA9076@linux.vnet.ibm.com>
	 <506C7057.6000102@redhat.com> <506D69AB.7020400@linux.vnet.ibm.com>
	 <506D83EE.2020303@redhat.com>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
X-Mailer: Evolution 3.2.2- 
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-10-04 at 14:41 +0200, Avi Kivity wrote:
> 
> Again the numbers are ridiculously high for arch_local_irq_restore.
> Maybe there's a bad perf/kvm interaction when we're injecting an
> interrupt, I can't believe we're spending 84% of the time running the
> popf instruction. 

Smells like a software fallback that doesn't do NMI, hrtimer based
sampling typically hits popf where we re-enable interrupts.
