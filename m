Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030202Ab2GCIMp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 04:12:45 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58003 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756148Ab2GCIMk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 04:12:40 -0400
Date: Tue, 3 Jul 2012 05:07:13 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>
Cc: peterz@infradead.org, mingo@elte.hu, avi@redhat.com,
        raghukt@linux.vnet.ibm.com, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org, jeremy@goop.org,
        vatsa@linux.vnet.ibm.com, hpa@zytor.com
Subject: Re: [PATCH v2 5/7] KVM: Introduce PV kick in flush tlb
Message-ID: <20120703080713.GA12579@amt.cnet>
References: <20120604050223.4560.2874.stgit@abhimanyu.in.ibm.com>
 <20120604050755.4560.24727.stgit@abhimanyu.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120604050755.4560.24727.stgit@abhimanyu.in.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 10:38:17AM +0530, Nikunj A. Dadhania wrote:
> In place of looping continuously introduce a halt if we do not succeed
> after some time.
> 
> For vcpus that were running an IPI is sent.  In case, it went to sleep
> between this, we will be doing flush_on_enter(harmless). But as a
> flush IPI was already sent, that will be processed in ipi handler,
> this might result into something undesireable, i.e. It might clear the
> flush_mask of a new request.
> 
> So after sending an IPI and waiting for a while, do a halt and wait
> for a kick from the last vcpu.
> 
> Signed-off-by: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
> Signed-off-by: Nikunj A. Dadhania <nikunj@linux.vnet.ibm.com>

Again, was it determined that this is necessary from data of 
benchmarking on the in-guest-mode/out-guest-mode patch?

