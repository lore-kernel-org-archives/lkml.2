Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756147Ab2GaMnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 Jul 2012 08:43:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:21204 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752875Ab2GaMnu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 Jul 2012 08:43:50 -0400
X-Authority-Analysis: v=2.0 cv=IOWA+3TG c=1 sm=0 a=s5Htg7xnQOKvHEu9STBOug==:17 a=OpT9cpI26MMA:10 a=3Odpp9koIGIA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=meVymXHHAAAA:8 a=ayC55rCoAAAA:8 a=U_kkepbrXWwOoSmH2SUA:9 a=PUjeQqilurYA:10 a=s5Htg7xnQOKvHEu9STBOug==:117
X-Cloudmark-Score: 0
X-Originating-IP: 72.230.195.127
Message-ID: <1343738627.27983.30.camel@gandalf.stny.rr.com>
Subject: Re: Testing tracer wakeup_rt: .. no entries found ..FAILED!
From: Steven Rostedt <rostedt@goodmis.org>
To: Avi Kivity <avi@redhat.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>,
        Steven Rostedt <srostedt@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>
Date: Tue, 31 Jul 2012 08:43:47 -0400
In-Reply-To: <5017D19B.5080806@redhat.com>
References: <20120724090330.GA9830@localhost>
	 <20120724090720.GA10434@localhost> <1343663105.3847.7.camel@fedora>
	 <20120731121759.GA17822@localhost> <5017D19B.5080806@redhat.com>
Content-Type: text/plain; charset="ISO-8859-15"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-07-31 at 15:37 +0300, Avi Kivity wrote:
> On 07/31/2012 03:17 PM, Fengguang Wu wrote:
> > 
> > It's good to quickly get to the root cause :) Can we possibly detect
> > whether we are in a virtual machine and hence skip this particular
> > test case?
> 
> cpu_has(&boot_cpu, X86_FEATURE_HYPERVISOR)
> 

Yeah, but then it is still broken on non-x86 code (the test lives in
core kernel).

As it is just testing the events for wakeup, I could probably just add a
completion and force the other thread to just wait for it. I'll write up
a patch. But it wont make it in till 3.7.

-- Steve


