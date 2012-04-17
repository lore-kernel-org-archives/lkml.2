Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab2DQO4y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 10:56:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:13475 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756075Ab2DQO4w (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 10:56:52 -0400
Message-ID: <4F8D8498.4080409@redhat.com>
Date: Tue, 17 Apr 2012 17:56:24 +0300
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120329 Thunderbird/11.0.1
MIME-Version: 1.0
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
CC: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>, kvm-ppc@vger.kernel.org,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
References: <4F742951.7080003@linux.vnet.ibm.com> <4F82E04E.6000900@redhat.com> <20120409175829.GB21894@amt.cnet> <4F8329D3.7000605@gmail.com> <20120409194614.GB23053@amt.cnet> <4F840DD2.3090101@redhat.com> <20120410204031.ffb5b976225ac9fe6dae474e@gmail.com> <4F842074.1050108@linux.vnet.ibm.com> <20120411211514.35db29c11460516e604059b6@gmail.com> <4F857B61.9080602@linux.vnet.ibm.com> <20120411231441.9d0984672dd252b806f99128@gmail.com> <20120413232528.c5ddbddb3cc0870d6e85a332@gmail.com> <4F8A95CB.9070104@redhat.com> <20120417004935.a9a39d951b3c24588e29edd2@gmail.com> <4F8D0D29.9050009@linux.vnet.ibm.com> <4F8D210C.8070505@redhat.com> <20120417213748.f3c4ae8d0056676fd33a47c5@gmail.com> <4F8D6503.4040800@redhat.com> <20120417235450.c0972c06034002d7173eeb40@gmail.com>
In-Reply-To: <20120417235450.c0972c06034002d7173eeb40@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2012 05:54 PM, Takuya Yoshikawa wrote:
> On Tue, 17 Apr 2012 15:41:39 +0300
> Avi Kivity <avi@redhat.com> wrote:
>
> > > Since there are many known algorithms to predict hot memory pages,
> > > the userspace will be able to tune the frequency of GET_DIRTY_LOG for such
> > > parts not to get too many faults repeatedly, if we can restrict the range
> > > of pages to protect.
> > >
> > > This is the fine-grained control.
> > 
> > Do you want per-page control, or just range-based?
>
> Difficult question.
>
> For live migration, range-based control may be enough duo to the locality
> of WWS.

What's WWS?

I don't see a reason to assume locality in gpa space (or in gva space
either, for some workloads).

-- 
error compiling committee.c: too many arguments to function

