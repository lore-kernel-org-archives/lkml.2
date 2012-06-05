Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753731Ab2FEQNV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 12:13:21 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:30300 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2FEQNU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 12:13:20 -0400
Date: Tue, 5 Jun 2012 18:13:18 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Don Zickus <dzickus@redhat.com>
Cc: Jan Beulich <JBeulich@suse.com>, x86@kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] x86,nmi: Fix section mismatch warnings on 32-bit
Message-ID: <20120605161318.GA29751@merkur.ravnborg.org>
References: <1338839763-11140-1-git-send-email-dzickus@redhat.com> <4FCDDB7D0200007800088390@nat28.tlf.novell.com> <20120605144734.GU32472@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120605144734.GU32472@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 05, 2012 at 10:47:34AM -0400, Don Zickus wrote:
> On Tue, Jun 05, 2012 at 09:12:13AM +0100, Jan Beulich wrote:
> > >>> On 04.06.12 at 21:56, Don Zickus <dzickus@redhat.com> wrote:
> > > It was reported that compiling for 32-bit caused a bunch of section
> > > mismatch warnings:
> > > 
> > >  VDSOSYM arch/x86/vdso/vdso32-syms.lds
> > >   LD      arch/x86/vdso/built-in.o
> > >   LD      arch/x86/built-in.o
> > > WARNING: arch/x86/built-in.o(.data+0x5af0): Section mismatch in reference 
> > > from the variable
> > > test_nmi_ipi_callback_na.10451 to the function 
> > 
> > Did you check what this (compiler introduced) variable actually
> > represents? The problem clearly is that the compiler has no way
> > of knowing that data it generates referencing an __init function
> > would actually need to go into .init.data or alike.
> 
> I do not know enough about behind the scene compiler magic to track this
> down correctly.  So any insight/help is greatly appreciated. :-)

We register a function annotated __init. And the normal use of this register()
is for functions that survive the init phase.
So drop the __init annotation on the function we register and the mismatch is fixed.

	Sam
