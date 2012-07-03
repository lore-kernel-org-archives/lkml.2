Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362Ab2GCIZx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 04:25:53 -0400
Received: from e23smtp02.au.ibm.com ([202.81.31.144]:50397 "EHLO
	e23smtp02.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750710Ab2GCIZt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 04:25:49 -0400
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: peterz@infradead.org, mingo@elte.hu, avi@redhat.com,
        raghukt@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, jeremy@goop.org,
        vatsa@linux.vnet.ibm.com, hpa@zytor.com
Subject: Re: [PATCH v2 5/7] KVM: Introduce PV kick in flush tlb
In-Reply-To: <20120703080713.GA12579@amt.cnet>
References: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com> <20120604050755.4560.24727.stgit@abhimanyu.in.ibm.com> <20120703080713.GA12579@amt.cnet>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/24.0.95.1 (x86_64-unknown-linux-gnu)
Date: Tue, 03 Jul 2012 13:55:02 +0530
Message-ID: <87r4stckv5.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
x-cbid: 12070222-5490-0000-0000-000001B5F279
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 3 Jul 2012 05:07:13 -0300, Marcelo Tosatti <mtosatti@redhat.com> wrote:
> On Mon, Jun 04, 2012 at 10:38:17AM +0530, Nikunj A. Dadhania wrote:
> > In place of looping continuously introduce a halt if we do not succeed
> > after some time.
> > 
> > For vcpus that were running an IPI is sent.  In case, it went to sleep
> > between this, we will be doing flush_on_enter(harmless). But as a
> > flush IPI was already sent, that will be processed in ipi handler,
> > this might result into something undesireable, i.e. It might clear the
> > flush_mask of a new request.
> > 
> > So after sending an IPI and waiting for a while, do a halt and wait
> > for a kick from the last vcpu.
> > 
> > Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> > Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>
> 
> Again, was it determined that this is necessary from data of 
> benchmarking on the in-guest-mode/out-guest-mode patch?
> 
No, this is more of a fix wrt algo.

