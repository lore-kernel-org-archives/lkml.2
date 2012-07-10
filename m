Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755777Ab2GJNB7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 09:01:59 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37563 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755744Ab2GJNB4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 09:01:56 -0400
Date: Tue, 10 Jul 2012 16:01:50 +0300
From: Gleb Natapov <gleb@redhat.com>
To: Avi Kivity <avi@redhat.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: X86: remove read buffer for mmio read
Message-ID: <20120710130149.GE23898@redhat.com>
References: <4FFA9E16.10001@linux.vnet.ibm.com>
 <4FFABD59.2070108@redhat.com>
 <20120709112346.GA23898@redhat.com>
 <4FFAD341.3080508@redhat.com>
 <4FFADB37.4090705@linux.vnet.ibm.com>
 <4FFADDFA.5000603@redhat.com>
 <20120710103629.GC23898@redhat.com>
 <4FFC07BB.8080802@redhat.com>
 <20120710104847.GD23898@redhat.com>
 <4FFC251F.4050504@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FFC251F.4050504@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 10, 2012 at 03:50:39PM +0300, Avi Kivity wrote:
> On 07/10/2012 01:48 PM, Gleb Natapov wrote:
> > > > > 
> > > > But the code is already here, why drop it?
> > > 
> > > The read cache is not effective for multiple disjunct reads.
> > What do you mean?
> 
> If an instruction reads from several sources in mmio, then the first
> read will be flushed from the cache by the second read.  So if we need a
> third read, we'll have to exit for the first again.
> 
The cache is flashed only before instruction decode, never during
emulation.

--
			Gleb.
