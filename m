Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753438Ab2DSJXN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 05:23:13 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:51180 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751699Ab2DSJXL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 05:23:11 -0400
Date: Thu, 19 Apr 2012 11:22:55 +0200
From: Borislav Petkov <bp@amd64.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@amd64.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Glauber de Oliveira Costa <gcosta@redhat.com>
Subject: Re: [PATCH 0/5] RFC: x86: Early exception table support
Message-ID: <20120419092255.GA29542@aftab>
References: <1334794610-5546-1-git-send-email-hpa@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334794610-5546-1-git-send-email-hpa@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Haha,

I was looking into that too and you beat me to it. Now isn't that great!
:-)

On Wed, Apr 18, 2012 at 05:16:45PM -0700, H. Peter Anvin wrote:
> If we get an exception during early boot, walk the exception table to
> see if we should intercept it.  The main use case for this is to allow
> rdmsr_safe()/wrmsr_safe() during CPU initialization.
> 
> Since the exception table is currently sorted at runtime, and fairly
> late in startup, this code walks the exception table linearly.  We
> obviously don't need to worry about modules, however: none have been
> loaded at this point.
> 
> In the future it would be better to have the table sorted at compile
> time, or even better, turned into a perfect hash.  At that point this
> code should be changed out from doing a linear search.

FWIW, I was thinking that maybe we could sort the main extable
(i.e., no modules) before we assign the early idt handlers in
x86_64_start_kernel() and this way use the binary search through it in
search_extable().

I'm sending the patches I had as a reply to this mail so that you can
get a better idea of what I mean. They're rough and the asm is f*cked
up so don't look at that - I was still figuring out the exception frame
layout to do it properly.

> This patchset also makes the early exception handling a little more
> similar between x86-64 and i386, but a lot of unification could (and
> should) still be done: in particular, setup done in C as in x86-64,
> and verbose error dump as in i386.

Yeah, I'll look through those and give them a test drive on my boxes
here.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
