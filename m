Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752368Ab2JAUax (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 16:30:53 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:46524 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252Ab2JAUav (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 16:30:51 -0400
X-Originating-IP: 217.70.178.136
X-Originating-IP: 173.246.103.110
Date: Mon, 1 Oct 2012 13:30:40 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Len Brown <lenb@kernel.org>,
        Matt Fleming <matt.fleming@intel.com>, Olof Johansson <olof@lixom.net>,
        Matthew Garrett <mjg@redhat.com>, David Howells <dhowells@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Jim Cromie <jim.cromie@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-acpi@vger.kernel.org
Subject: Re: [PATCHv3 1/4] efi: Add a stub for efi_enter_virtual_mode on
 non-x86
Message-ID: <20121001203040.GA8478@jtriplet-mobl1>
References: <cover.1347141698.git.josh@joshtriplett.org>
 <993c7f2ee7d53cc480280653a7df500db0882342.1347141698.git.josh@joshtriplett.org>
 <201210012028.32710.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201210012028.32710.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 01, 2012 at 08:28:32PM +0000, Arnd Bergmann wrote:
> On Saturday 08 September 2012, Josh Triplett wrote:
> > +#ifdef CONFIG_X86
> >  extern void efi_enter_virtual_mode (void);     /* switch EFI to virtual mode, if possible */
> > +#else
> > +static void efi_enter_virtual_mode(void) {}
> > +#endif
> 
> This has suddenly appeared in linux-next now and is causing warnings.
> 
> 8<---
> efi: fix prototype for API stubs
> 
> Some functions in the efi API have recently been added as versions for non-x86,
> but are missing an "inline" keyword, which causes these warnings:
> 
> include/linux/efi.h:503:13: error: 'efi_enter_virtual_mode' defined but not used [-Werror=unused-function]
> include/linux/efi.h:504:13: error: 'efi_late_init' defined but not used [-Werror=unused-function]
> include/linux/efi.h:505:13: error: 'efi_free_boot_services' defined but not used [-Werror=unused-function]

Already fixed in current tip; please refresh from there.

- Josh Triplett
