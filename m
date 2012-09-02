Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755291Ab2IBX2G (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Sep 2012 19:28:06 -0400
Received: from hapkido.dreamhost.com ([66.33.216.122]:42603 "EHLO
	hapkido.dreamhost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755199Ab2IBX2E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Sep 2012 19:28:04 -0400
Subject: Re: [PATCH] KVM: VMX: invalidate vpid for invlpg instruction
From: Davidlohr Bueso <dave@gnu.org>
Reply-To: dave@gnu.org
To: Marcelo Tosatti <mtosatti@redhat.com>
Cc: Avi Kivity <avi@redhat.com>, KVM <kvm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <20120831173707.GA3895@amt.cnet>
References: <1346429448.2823.1.camel@offbook>
	 <20120831173707.GA3895@amt.cnet>
Content-Type: text/plain; charset="UTF-8"
Organization: GNU
Date: Mon, 03 Sep 2012 01:27:20 +0200
Message-ID: <1346628440.3170.3.camel@offbook>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-08-31 at 14:37 -0300, Marcelo Tosatti wrote:
> On Fri, Aug 31, 2012 at 06:10:48PM +0200, Davidlohr Bueso wrote:
> > For processors that support VPIDs we should invalidate the page table entry
> > specified by the lineal address. For this purpose add support for individual
> > address invalidations.
> 
> Not necessary - a single context invalidation is performed through
> KVM_REQ_TLB_FLUSH.

Since vpid_sync_context() supports both single and all-context vpid
invalidations, wouldn't it make sense to also add individual address
ones as well, supporting further granularity?

> 
> Single-context. If the INVVPID type is 1, the logical processor
> invalidates all
> linear mappings and combined mappings associated with the VPID specified
> in the INVVPID descriptor.
> 
> 


