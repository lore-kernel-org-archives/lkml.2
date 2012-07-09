Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753945Ab2GIN0q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 09:26:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31247 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895Ab2GIN0o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 09:26:44 -0400
Date: Mon, 9 Jul 2012 16:26:42 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: X86: remove read buffer for mmio read
Message-ID: <20120709132642.GB7298@redhat.com>
References: <4FFA9E16.10001@linux.vnet.ibm.com>
 <4FFABD59.2070108@redhat.com>
 <20120709112346.GA23898@redhat.com>
 <4FFAD341.3080508@redhat.com>
 <4FFADB37.4090705@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FFADB37.4090705@linux.vnet.ibm.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 09:23:03PM +0800, Xiao Guangrong wrote:
> On 07/09/2012 08:49 PM, Avi Kivity wrote:
> > On 07/09/2012 02:23 PM, Gleb Natapov wrote:
> >>
> >>> kvm-unit-tests.git has a test for xchg to mmio.  Does it still work?
> >>>
> >>> I agree this code has to go, but it needs to be replaced by something.
> >>> Maybe a .valid flag in struct operand.
> >>>
> >> Valid will not enough for that.
> > 
> > If we make everything go through operands, any reason why not?
> > 
> 
> I noticed some instructions need to read ESP for many times (e.g, iret_real),
> maybe .valid flag is not enough for this case if the stack is in MMIO, yes?
> 
> IIUC, I also noticed ESP is not reset back if it is emulated fail (mmio is needed).
> If the stack located in mmio region, this kind of instruct will be broken, i know no
> guest will use mmio as stack but SDM does not limit it, is it valid?
> 
Good point about MMIO stack too.

--
			Gleb.
