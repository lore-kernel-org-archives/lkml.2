Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752706Ab0LWKV2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 05:21:28 -0500
Received: from canuck.infradead.org ([134.117.69.58]:60772 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752453Ab0LWKV0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 05:21:26 -0500
Subject: Re: [PATCH] kernel: clean up USE_GENERIC_SMP_HELPERS
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Cong Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Koichi Yasutake <yasutake.koichi@jp.panasonic.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Yinghai Lu <yinghai@kernel.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Venkatesh Pallipadi <venki@google.com>, linux-am33-list@redhat.com
In-Reply-To: <4D131E42.1000201@redhat.com>
References: <1291010778-5669-1-git-send-email-amwang@redhat.com>
	 <1293023333.2170.120.camel@laptop>  <4D131E42.1000201@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 23 Dec 2010 11:21:10 +0100
Message-ID: <1293099670.2170.459.camel@laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-12-23 at 18:02 +0800, Cong Wang wrote:
> 于 2010年12月22日 21:08, Peter Zijlstra 写道:
> > On Mon, 2010-11-29 at 14:06 +0800, Amerigo Wang wrote:
> >> For arch which needs USE_GENERIC_SMP_HELPERS, it has to
> >> select USE_GENERIC_SMP_HELPERS, rather than leaving a choice
> >> to user, since they don't provide their own implementions.
> >>
> >
> >>   config MN10300_CURRENT_IN_E2
> >> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> >> index e330da2..736beea 100644
> >> --- a/arch/x86/Kconfig
> >> +++ b/arch/x86/Kconfig
> >> @@ -65,6 +65,7 @@ config X86
> >>   	select HAVE_SPARSE_IRQ
> >>   	select GENERIC_IRQ_PROBE
> >>   	select GENERIC_PENDING_IRQ if SMP
> >> +	select USE_GENERIC_SMP_HELPERS if SMP
> >>
> >>   config INSTRUCTION_DECODER
> >>   	def_bool (KPROBES || PERF_EVENTS)
> >> @@ -203,10 +204,6 @@ config HAVE_INTEL_TXT
> >>   	def_bool y
> >>   	depends on EXPERIMENTAL&&  DMAR&&  ACPI
> >>
> >> -config USE_GENERIC_SMP_HELPERS
> >> -	def_bool y
> >> -	depends on SMP
> >> -
> >>   config X86_32_SMP
> >>   	def_bool y
> >>   	depends on X86_32&&  SMP
> >
> > That changelog and the patch don't match, the patch is a total NOP,
> > users never see that config option.
> 
> Ok, but isn't 'select' is supposed to be better to express this here? :)

It sure is shorter, so on that ground one can argue so indeed. Its just
that the discrepancy between the Changelog (describing an actual change
in semantics) and the patch (being a NOP) bothered me.

> This patch also moves on_each_cpu() to kernel/smp.c, btw.

Right, it does that, it would probably have been better if that were a
patch on its own, seeing as its a completely orthogonal change.
