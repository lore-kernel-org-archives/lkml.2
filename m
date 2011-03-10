Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab1CJAIP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Mar 2011 19:08:15 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:43177 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab1CJAIN convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Mar 2011 19:08:13 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: matthieu castet <castet.matthieu@free.fr>
Subject: Re: [tip:x86/trampoline] x86, trampoline: Use the unified trampoline setup for ACPI wakeup
Date: Thu, 10 Mar 2011 01:07:57 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.4.4; x86_64; ; )
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, sfr@canb.auug.org.au, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
References: <4D5DFBE4.7090104@intel.com> <tip-d1ee433539ea5963a8f946f3428b335d1c5fdb20@git.kernel.org> <4D780221.1030209@free.fr>
In-Reply-To: <4D780221.1030209@free.fr>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103100107.57887.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, March 09, 2011, matthieu castet wrote:
> Hi,
> 
> tip-bot for H. Peter Anvin a écrit :
> > Commit-ID:  d1ee433539ea5963a8f946f3428b335d1c5fdb20
> > Gitweb:     http://git.kernel.org/tip/d1ee433539ea5963a8f946f3428b335d1c5fdb20
> > Author:     H. Peter Anvin <hpa@linux.intel.com>
> > AuthorDate: Mon, 14 Feb 2011 15:42:46 -0800
> > Committer:  H. Peter Anvin <hpa@linux.intel.com>
> > CommitDate: Thu, 17 Feb 2011 21:05:06 -0800
> > 
> > diff --git a/arch/x86/kernel/acpi/wakeup_rm.S b/arch/x86/kernel/acpi/wakeup_rm.S
> > index 6ff3b57..6ce81ee 100644
> > --- a/arch/x86/kernel/acpi/wakeup_rm.S
> > +++ b/arch/x86/kernel/acpi/wakeup_rm.S
> > @@ -2,9 +2,11 @@
> >   * Wrapper script for the realmode binary as a transport object
> >   * before copying to low memory.
> >   */
> > -	.section ".rodata","a"
> > -	.globl	wakeup_code_start, wakeup_code_end
> > -wakeup_code_start:
> > +#include <asm/page_types.h>
> > +
> > +	.section ".x86_trampoline","a"
> > +	.balign PAGE_SIZE
> > +	.globl	acpi_wakeup_code
> > +acpi_wakeup_code:
> >  	.incbin	"arch/x86/kernel/acpi/realmode/wakeup.bin"
> > -wakeup_code_end:
> >  	.size	wakeup_code_start, .-wakeup_code_start
> It doesn't build for me, Shouldn't you change this to 
> .size	acpi_wakeup_code, .-acpi_wakeup_code ?

Yes, and the fix is already in the tip tree.

Thanks,
Rafael
