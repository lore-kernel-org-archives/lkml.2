Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933116Ab2BBR4i (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Feb 2012 12:56:38 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38107 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932092Ab2BBR4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Feb 2012 12:56:37 -0500
Message-ID: <4F2ACE46.4000307@redhat.com>
Date: Thu, 02 Feb 2012 19:56:22 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:9.0) Gecko/20111222 Thunderbird/9.0
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong.eric@gmail.com>
CC: Marcelo Tosatti <mtosatti@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Stefan Hajnoczi <stefanha@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH v2 2/3] KVM: x86: add tracepoints to trace mmio begin
 and complete
References: <4F2AC707.7020801@gmail.com> <4F2AC790.1090805@gmail.com> <4F2AC9A0.7090904@redhat.com> <4F2ACE04.9040602@gmail.com>
In-Reply-To: <4F2ACE04.9040602@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/02/2012 07:55 PM, Xiao Guangrong wrote:
> On 02/03/2012 01:36 AM, Avi Kivity wrote:
>
> > On 02/02/2012 07:27 PM, Xiao Guangrong wrote:
> >> From: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
> >>
> >> 'perf kvm-events' will use kvm_exit and kvm_mmio(read...) to calculate
> >> mmio read emulated time for the old kernel, in order to trace mmio read
> >> event more exactly, we add kvm_mmio_begin to trace the time when mmio read
> >> begins
> >>
> >> Also, add kvm_mmio_done to trace the time when mmio/pio is completed
> > 
> > Previously, we discussed using the kvm_entry to do this.  This reduces
> > the number of tracepoints, and is backwards compatible.  What was the
> > conclusion?
> > 
>
>
> Since using kvm_entry can cause lots of unnecessary calculated, these new two
> tracepoints can let the result be exacter.

Do you have numbers on the ratio between kvm_entry traces and
kvm_mmio_begin/end traces?

> And, they are only used in new kernel, we will fall back to using kvm_entry if
> they are not existing, that means it does not break backwards compatible.

Ah ok.


-- 
error compiling committee.c: too many arguments to function

