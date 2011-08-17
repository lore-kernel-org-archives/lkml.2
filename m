Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751543Ab1HQH2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 03:28:20 -0400
Received: from fanny.its.uu.se ([130.238.4.241]:54829 "EHLO fanny.its.uu.se"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751443Ab1HQH2T convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 03:28:19 -0400
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8BIT
Message-ID: <20043.28045.613130.691498@pilspetsen.it.uu.se>
Date: Wed, 17 Aug 2011 09:28:13 +0200
From: Mikael Pettersson <mikpe@it.uu.se>
To: Will Drewry <wad@chromium.org>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>,
        Mikael Pettersson <mikpe@it.uu.se>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Mike Frysinger <vapier@gentoo.org>,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [RFC,PATCH] arch/arm: compute and export NR_syscalls
In-Reply-To: <CABqD9hYavCxA38GbBhbCmBT+PEQQsvhbF4U7xY8P8ygbFy+=Ag@mail.gmail.com>
References: <1313529267-4428-1-git-send-email-wad@chromium.org>
	<1629809.vjtjo6obCs@wuerfel>
	<CABqD9hYavCxA38GbBhbCmBT+PEQQsvhbF4U7xY8P8ygbFy+=Ag@mail.gmail.com>
X-Mailer: VM 7.17 under Emacs 20.7.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Will Drewry writes:
 > On Tue, Aug 16, 2011 at 4:21 PM, Arnd Bergmann <arnd@arndb.de> wrote:
 > > On Tuesday 16 August 2011 16:14:26 Will Drewry wrote:
 > >>
 > >> asm-exports.c is added instead of reusing asm-offsets.c to avoid a
 > >> variety of collisions (VM_EXEC, DMA_*, etc).  It is possible to use the
 > >> same calls.S mechanism but add NR_syscalls to asm-offsets.c.  However,
 > >> at inclusion time for generated/asm-offsets.h, conflicting defines will
 > >> need to be #undef'd if !__ASSEMBLY__ since it appears that the purpose
 > >> of asm-offsets.h is to safely bind C language definitions to assembly
 > >> and not the reverse.
 > >>
 > >> - Is this approach palatable?
 > >> - Should I resend only when paired with the other ftrace-needed patches?
 > >
 > > This seems overly complex, compared to a one-line change adding the symbol
 > > to asm/unistd.h. The only other architecture that uses an approach
 > > like the one you have posted is x86-64, and it's simpler there
 > > because it can easily be done in asm-offsets.c there without the need
 > > to create another helper.
 > 
 > Agreed!
 > 
 > I proposed this approach based solely on prior threads I've seen. E.g.,
 > - https://lkml.org/lkml/2007/6/1/427
 >   (don't just #define)
 > - https://lkml.org/lkml/2009/8/27/280
 >   (todo: x86-32 to move to x86-64)
 > 
 > If a single line #define is good enough, then it certainly works for me.

Yes, the one-line #define NR_syscalls in unistd.h is a perfectly adequate,
if not entirely elegant, solution.  Adding asm-export.c just for this is
waaay overkill.

/Mikael
