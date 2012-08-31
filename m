Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754746Ab2HaRhO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 13:37:14 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20790 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754719Ab2HaRhN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 13:37:13 -0400
Date: Fri, 31 Aug 2012 14:37:07 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Davidlohr Bueso <dave@gnu.org>
Cc: Avi Kivity <avi@redhat.com>, KVM <kvm@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] KVM: VMX: invalidate vpid for invlpg instruction
Message-ID: <20120831173707.GA3895@amt.cnet>
References: <1346429448.2823.1.camel@offbook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346429448.2823.1.camel@offbook>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 06:10:48PM +0200, Davidlohr Bueso wrote:
> For processors that support VPIDs we should invalidate the page table entry
> specified by the lineal address. For this purpose add support for individual
> address invalidations.

Not necessary - a single context invalidation is performed through
KVM_REQ_TLB_FLUSH.

Single-context. If the INVVPID type is 1, the logical processor
invalidates all
linear mappings and combined mappings associated with the VPID specified
in the INVVPID descriptor.

