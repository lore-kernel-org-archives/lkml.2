Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756801Ab2EUTfk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 May 2012 15:35:40 -0400
Received: from mx1.redhat.com ([209.132.183.28]:51056 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755126Ab2EUTfi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 May 2012 15:35:38 -0400
Date: Mon, 21 May 2012 16:30:41 -0300
From: Marcelo Tosatti <mtosatti@redhat.com>
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
Cc: Gleb Natapov <gleb@redhat.com>, Avi Kivity <avi@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH] KVM: fix async page fault working for readonly mapping
Message-ID: <20120521193041.GA25940@amt.cnet>
References: <4FB9E499.2010505@linux.vnet.ibm.com>
 <20120521080856.GS10209@redhat.com>
 <4FB9F9B6.50101@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FB9F9B6.50101@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, May 21, 2012 at 04:15:50PM +0800, Xiao Guangrong wrote:
> On 05/21/2012 04:08 PM, Gleb Natapov wrote:
> 
> > On Mon, May 21, 2012 at 02:45:45PM +0800, Xiao Guangrong wrote:
> >> If we map a readonly memory space from host to guest and the page is
> >> not currently mapped in the host, we will get a fault-pfn and async
> >> is not allowed, then the vm will crash
> >>
> > Why would we want to map a readonly memory space from host to guest?
> > We may want to do it to support memory semantics on read and mmio on
> > write, but do not right now unless something changed while I was not
> > looking.
> 
> 
> Some test cases in kvm-unit-tests and the benchmark i am writing for KVM
> need map the function on host to guest.

Or ROM. Or read-only mappings of IVSHMEM (which don't exist yet).

