Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760715Ab1D1Qm5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Apr 2011 12:42:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49963 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757644Ab1D1Qm4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Apr 2011 12:42:56 -0400
Date: Thu, 28 Apr 2011 12:42:28 -0400
From: Dave Jones <davej@redhat.com>
To: Jan Beulich <JBeulich@novell.com>
Cc: mingo@elte.hu, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH, v2] i386: tighten dependencies of CPU_SUP_*_32
Message-ID: <20110428164228.GA8336@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Jan Beulich <JBeulich@novell.com>, mingo@elte.hu,
	tglx@linutronix.de, hpa@zytor.com, linux-kernel@vger.kernel.org
References: <4DB9498B020000780003E9A0@vpn.id2.novell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DB9498B020000780003E9A0@vpn.id2.novell.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 10:03:39AM +0100, Jan Beulich wrote:
 
 > --- 2.6.39-rc5/arch/x86/Kconfig.cpu
 > +++ 2.6.39-rc5-i386-cpu-sup-dependencies/arch/x86/Kconfig.cpu
 > @@ -440,7 +440,7 @@ config CPU_SUP_INTEL
 >  config CPU_SUP_CYRIX_32
 >  	default y
 >  	bool "Support Cyrix processors" if PROCESSOR_SELECT
 > -	depends on !64BIT
 > +	depends on M386 || M486 || M586 || M586TSC || M586MMX || (EXPERT && !64BIT)
 >  	---help---
 >  	  This enables detection, tunings and quirks for Cyrix processors
 >  
 > @@ -494,7 +494,7 @@ config CPU_SUP_TRANSMETA_32
 >  config CPU_SUP_UMC_32
 >  	default y
 >  	bool "Support UMC processors" if PROCESSOR_SELECT
 > -	depends on !64BIT
 > +	depends on M386 || M486 || (EXPERT && !64BIT)
 >  	---help---
 >  	  This enables detection, tunings and quirks for UMC processors

PROCESSOR_SELECT is already dependant on EXPERT being set.

	Dave

