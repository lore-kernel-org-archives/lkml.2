Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab2GJQEj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jul 2012 12:04:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:27706 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753213Ab2GJQEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jul 2012 12:04:35 -0400
Message-ID: <4FFC528D.8040900@redhat.com>
Date: Tue, 10 Jul 2012 19:04:29 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Gleb Natapov <gleb@redhat.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 1/2] KVM: X86: remove read buffer for mmio read
References: <4FFA9E16.10001@linux.vnet.ibm.com> <4FFABD59.2070108@redhat.com> <20120709112346.GA23898@redhat.com> <4FFAD341.3080508@redhat.com> <4FFADB37.4090705@linux.vnet.ibm.com> <4FFADDFA.5000603@redhat.com> <20120710103629.GC23898@redhat.com> <4FFC07BB.8080802@redhat.com> <20120710104847.GD23898@redhat.com> <4FFC251F.4050504@redhat.com> <20120710130149.GE23898@redhat.com>
In-Reply-To: <20120710130149.GE23898@redhat.com>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2012 04:01 PM, Gleb Natapov wrote:
> On Tue, Jul 10, 2012 at 03:50:39PM +0300, Avi Kivity wrote:
> > On 07/10/2012 01:48 PM, Gleb Natapov wrote:
> > > > > > 
> > > > > But the code is already here, why drop it?
> > > > 
> > > > The read cache is not effective for multiple disjunct reads.
> > > What do you mean?
> > 
> > If an instruction reads from several sources in mmio, then the first
> > read will be flushed from the cache by the second read.  So if we need a
> > third read, we'll have to exit for the first again.
> > 
> The cache is flashed only before instruction decode, never during
> emulation.

Oh, I misread the code.

-- 
I have a truly marvellous patch that fixes the bug which this
signature is too narrow to contain.

