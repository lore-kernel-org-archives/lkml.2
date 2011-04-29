Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755253Ab1D2GxX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 02:53:23 -0400
Received: from vpn.id2.novell.com ([195.33.99.129]:56429 "EHLO
	vpn.id2.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753878Ab1D2GxW convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-JBeulich@novell.com:4:1>);
	Fri, 29 Apr 2011 02:53:22 -0400
Message-Id: <4DBA7CCC020000780003ED3A@vpn.id2.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.1 
Date: Fri, 29 Apr 2011 07:54:36 +0100
From: "Jan Beulich" <JBeulich@novell.com>
To: "Dave Jones" <davej@redhat.com>
Cc: <mingo@elte.hu>, <tglx@linutronix.de>, <linux-kernel@vger.kernel.org>,
        <hpa@zytor.com>
Subject: Re: [PATCH, v2] i386: tighten dependencies of CPU_SUP_*_32
References: <4DB9498B020000780003E9A0@vpn.id2.novell.com>
 <20110428164228.GA8336@redhat.com>
In-Reply-To: <20110428164228.GA8336@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 28.04.11 at 18:42, Dave Jones <davej@redhat.com> wrote:
> On Thu, Apr 28, 2011 at 10:03:39AM +0100, Jan Beulich wrote:
>  
>  > --- 2.6.39-rc5/arch/x86/Kconfig.cpu
>  > +++ 2.6.39-rc5-i386-cpu-sup-dependencies/arch/x86/Kconfig.cpu
>  > @@ -440,7 +440,7 @@ config CPU_SUP_INTEL
>  >  config CPU_SUP_CYRIX_32
>  >  	default y
>  >  	bool "Support Cyrix processors" if PROCESSOR_SELECT
>  > -	depends on !64BIT
>  > +	depends on M386 || M486 || M586 || M586TSC || M586MMX || (EXPERT && !64BIT)
>  >  	---help---
>  >  	  This enables detection, tunings and quirks for Cyrix processors
>  >  
>  > @@ -494,7 +494,7 @@ config CPU_SUP_TRANSMETA_32
>  >  config CPU_SUP_UMC_32
>  >  	default y
>  >  	bool "Support UMC processors" if PROCESSOR_SELECT
>  > -	depends on !64BIT
>  > +	depends on M386 || M486 || (EXPERT && !64BIT)
>  >  	---help---
>  >  	  This enables detection, tunings and quirks for UMC processors
> 
> PROCESSOR_SELECT is already dependant on EXPERT being set.

If EXPERT was omitted from the depends condition, then the whole
option would be unavailable (and hence the prompt invisible) even
if PROCESSOR_SELECT=y (and e.g. M686=y).

The intention, however, is to allow the option to be selectable in
an EXPERT configuration (to have a temporary workaround in
case the condition set isn't precise, or to do testing on
hypothetical new CPUs).

Or to put it differently, the intended behavior change is precisely
for the PROCESSOR_SELECT=n case, so that no impossible CPUs
get auto-enabled.

Jan

