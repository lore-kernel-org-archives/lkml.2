Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932999Ab0J1HlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Oct 2010 03:41:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21469 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932356Ab0J1HlS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Oct 2010 03:41:18 -0400
Date: Thu, 28 Oct 2010 09:41:13 +0200
From: Gleb Natapov <gleb@redhat.com>
To: Xiao Guangrong <xiaoguangrong@cn.fujitsu.com>
Cc: Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 5/8] KVM: don't touch vcpu stat after async pf is
 complete
Message-ID: <20101028074113.GS26191@redhat.com>
References: <4CC7EA7D.5020901@cn.fujitsu.com>
 <4CC7EB75.9030709@cn.fujitsu.com>
 <20101027104412.GO26191@redhat.com>
 <4CC927B1.2020807@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CC927B1.2020807@cn.fujitsu.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 28, 2010 at 03:35:13PM +0800, Xiao Guangrong wrote:
> On 10/27/2010 06:44 PM, Gleb Natapov wrote:
> > On Wed, Oct 27, 2010 at 05:05:57PM +0800, Xiao Guangrong wrote:
> >> Don't make a KVM_REQ_UNHALT request after async pf is completed since it
> >> can break guest's 'halt' instruction.
> >>
> > Why is it a problem? CPU may be unhalted by different events so OS
> > shouldn't depend on it.
> > 
> 
> We don't know how guest OS handles it after HLT instruction is completed,
> according to X86's spec, only NMI/INTR/RESET/INIT/SMI can break halt state,
> it violations the hardware behavior if we allow other event break this
> state. Your opinion? :-)
I agree in principle, but since SMI (which is completely out of guest OS
control) can cause CPU to exit halt, in practice OS can't rely on CPU to
be unhalted only by events controlled by OS itself. In the past we had a
bug that any timer even unhalted vcpu even when timer interrupt was masked.
The only practical problem it caused was that vcpu that executed cli;
1: hlt; jmp 1b sequence still consumed host cpu time. That said I am not
against fixing it if the fix is easy. Your current fix though relies on
patch 4 that I have problem with. 

--
			Gleb.
