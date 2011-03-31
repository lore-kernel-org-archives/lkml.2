Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756196Ab1CaJPJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 05:15:09 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:55230 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752491Ab1CaJPH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 05:15:07 -0400
Date: Thu, 31 Mar 2011 11:14:56 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Cliff Wickman <cpw@sgi.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, tglx@linutronix.de,
        rja@sgi.com
Subject: Re: [PATCH v2] x86: UV kdump reboot fix
Message-ID: <20110331091456.GB8296@elte.hu>
References: <E1Q4xxV-0004MJ-Pa@eag09.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1Q4xxV-0004MJ-Pa@eag09.americas.sgi.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Cliff Wickman <cpw@sgi.com> wrote:

> From: Cliff Wickman <cpw@sgi.com>
> 
> After a crash dump on an SGI Altix UV system the crash kernel fails to
> cause a reboot.  EFI mode is disabled in the kdump kernel, so only the
> reboot_type of BOOT_ACPI works.
> 
> native_machine_restart() is the generic restart function.  This patch
> overrides the generic version with a UV-specific version.
> (an earlier (6Dec2010) version of this patch was nack'd as it patched
>  native_machine_restart() with special case is_uv_system() kludge)

It was NAKed because a special case is_uv_system() kludge was put into
*generic x86 code*.

Kludging the generic code some more:

 >  arch/x86/include/asm/uv/uv.h       |    1 +
 >  arch/x86/kernel/apic/x2apic_uv_x.c |   18 ++++++++++++++++++
 >  arch/x86/kernel/reboot.c           |    2 +-
 >  3 files changed, 20 insertions(+), 1 deletion(-)

Does not help either.

The clean solution would be to add the reboot_type setting to an UV specific 
initialization function. That way only UV is affected and there's no extra 
kludge either, as reboot_type is already global.

Thanks,

	Ingo
