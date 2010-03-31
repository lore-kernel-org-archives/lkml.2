Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756937Ab0CaSpe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Mar 2010 14:45:34 -0400
Received: from mail-qy0-f179.google.com ([209.85.221.179]:46643 "EHLO
	mail-qy0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751285Ab0CaSpc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Mar 2010 14:45:32 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=oj5rbtrT3s5sYfeAL1zlrfgNuwEph6GkNvJ6odTqXUcRZJqQdem6nIeYW5uOVDZfVW
         J/i3SRFsSgCSZwQhLn9SVJ4KkiLAfI6uVaL6kVQB0N4+DuZYvftV1Fjz2vVMJWcj21QM
         A4bFeWlbaMIKCTTyTe1+iKwc6trt9CJtlRx80=
Date: Thu, 1 Apr 2010 00:15:50 +0530
From: Rabin Vincent <rabin@rab.in>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
       Frederic Weisbecker <fweisbec@gmail.com>,
       Ingo Molnar <mingo@redhat.com>,
       Abhishek Sagar <sagar.abhishek@gmail.com>,
       Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
Subject: Re: [PATCH 07/10] ftrace: pass KBUILD_CFLAGS to record_mcount.pl
Message-ID: <20100331184549.GA20223@debian>
References: <1268462987-8271-1-git-send-email-rabin@rab.in>
 <1268462987-8271-8-git-send-email-rabin@rab.in>
 <1268585771.13400.5.camel@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268585771.13400.5.camel@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 14, 2010 at 12:56:11PM -0400, Steven Rostedt wrote:
> On Sat, 2010-03-13 at 12:19 +0530, Rabin Vincent wrote:
> > diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> > index 0b94d2f..2535c11 100644
> > --- a/scripts/Makefile.build
> > +++ b/scripts/Makefile.build
> > @@ -209,7 +209,8 @@ ifdef CONFIG_FTRACE_MCOUNT_RECORD
> >  cmd_record_mcount = set -e ; perl $(srctree)/scripts/recordmcount.pl "$(ARCH)" \
> >  	"$(if $(CONFIG_CPU_BIG_ENDIAN),big,little)" \
> >  	"$(if $(CONFIG_64BIT),64,32)" \
> > -	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC)" "$(LD)" "$(NM)" "$(RM)" "$(MV)" \
> > +	"$(OBJDUMP)" "$(OBJCOPY)" "$(CC) $(KBUILD_CFLAGS)" \
> > +	"$(LD)" "$(NM)" "$(RM)" "$(MV)" \
> 
> Again, I'll have to test this on other archs, just to make sure its does
> not cause any side effects. Oh, I forgot I now have a MIPS board I can
> test on too. I'll probably do this on Monday.

I've now built PowerPC, SH, and MIPS kernels with dynamic ftrace enabled
and checked that the obj files don't change as the result of this
series.  I've run the MIPS kernel on QEMU and x86_64 on my PC.

Rabin
