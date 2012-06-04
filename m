Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932433Ab2FDQgA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 12:36:00 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:63370 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755294Ab2FDQf7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 12:35:59 -0400
Date: Mon, 4 Jun 2012 18:35:56 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Witold Baryluk <baryluk@smp.if.uj.edu.pl>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Subject: Re: WARNING: arch/x86/built-in.o: Section mismatch in reference
	from the variable test_nmi_ipi_callback_na to function
	.ini.text:test_nmi_ipi_callback
Message-ID: <20120604163556.GA12303@merkur.ravnborg.org>
References: <20120602161502.GW16584@smp.if.uj.edu.pl> <20120604143643.GJ32472@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120604143643.GJ32472@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 10:36:43AM -0400, Don Zickus wrote:
> On Sat, Jun 02, 2012 at 06:15:02PM +0200, Witold Baryluk wrote:
> > Hello everybody,
> > 
> > x86 32-bit Build just got 2 WARNINGS when building kernel on Linus' tree.
> 
> Hi Witold,
> 
> Thanks for the warnings.
> 
> > 
> > 
> >  VDSOSYM arch/x86/vdso/vdso32-syms.lds
> >   LD      arch/x86/vdso/built-in.o
> >   LD      arch/x86/built-in.o
> > WARNING: arch/x86/built-in.o(.data+0x5af0): Section mismatch in reference from the variable test_nmi_ipi_callback_na.10451 to the function .init.text:test_nmi_ipi_callback()
> > The variable test_nmi_ipi_callback_na.10451 references
> > the function __init test_nmi_ipi_callback()
> > If the reference is valid then annotate the
> > variable with __init* or __refdata (see linux/init.h) or name the variable:
> > *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
> > 
> > WARNING: arch/x86/built-in.o(.data+0x5b04): Section mismatch in reference from the variable nmi_unk_cb_na.10399 to the function .init.text:nmi_unk_cb()
> > The variable nmi_unk_cb_na.10399 references
> > the function __init nmi_unk_cb()
> > If the reference is valid then annotate the
> > variable with __init* or __refdata (see linux/init.h) or name the variable:
> > *_template, *_timer, *_sht, *_ops, *_probe, *_probe_one, *_console
> 
> These are intermediate variables test_nmi_ipi_callback_na.10451 and
> nmi_unk_cb_na.10399.  I do not know how to fix them.
> 
> Basically the test registers two nmi_handlers, run some tests, and
> then unregisters them.  Those handlers are what the compiler seems to be
> complaining about.  I do not know what magic to pass the compiler to let
> it know that both of the handlers will be unregistered before the init
> section is destroyed.
> 
> Perhaps I should tag those callbacks with __ref? I am not sure the right
> thing to do here.

Drop the __init from nmi_unk_cb() and test_nmi_ipi_callback().
Then the warnings are gone.

Trying to let register_nmi_handler() accept a function annotated __init is
wrong as we do not want this.
I someone try this in 'real' code we would be screwed.

	Sam
