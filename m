Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760764Ab2FDPI4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Jun 2012 11:08:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59286 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760720Ab2FDPIy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Jun 2012 11:08:54 -0400
Date: Mon, 4 Jun 2012 11:08:31 -0400
From: Don Zickus <dzickus@redhat.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Witold Baryluk <baryluk@smp.if.uj.edu.pl>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org
Subject: Re: WARNING: arch/x86/built-in.o: Section mismatch in reference from
 the variable test_nmi_ipi_callback_na to function
 .ini.text:test_nmi_ipi_callback
Message-ID: <20120604150831.GO32472@redhat.com>
References: <20120602161502.GW16584@smp.if.uj.edu.pl>
 <20120604143643.GJ32472@redhat.com>
 <4FCCCD5D.6010005@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FCCCD5D.6010005@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 04, 2012 at 07:59:41AM -0700, H. Peter Anvin wrote:
> On 06/04/2012 07:36 AM, Don Zickus wrote:
> > 
> > Basically the test registers two nmi_handlers, run some tests, and
> > then unregisters them.  Those handlers are what the compiler seems to be
> > complaining about.  I do not know what magic to pass the compiler to let
> > it know that both of the handlers will be unregistered before the init
> > section is destroyed.
> > 
> > Perhaps I should tag those callbacks with __ref? I am not sure the right
> > thing to do here.
> > 
> 
> Using __ref is the right thing, although __ref is hard to use right...

Thanks!  I'll poke at it and see how lucky I get.

Cheers,
Don
