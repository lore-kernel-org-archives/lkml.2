Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753078Ab2DTIqy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 04:46:54 -0400
Received: from s15943758.onlinehome-server.info ([217.160.130.188]:56570 "EHLO
	mail.x86-64.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752827Ab2DTIqu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 04:46:50 -0400
Date: Fri, 20 Apr 2012 10:46:47 +0200
From: Borislav Petkov <bp@amd64.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Borislav Petkov <bp@amd64.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 3/3] x86, extable: Handle early exceptions
Message-ID: <20120420084647.GA3247@aftab.osrc.amd.com>
References: <1334794610-5546-1-git-send-email-hpa@zytor.com>
 <20120419092255.GA29542@aftab>
 <20120419092630.GD29542@aftab>
 <4F904541.2030200@zytor.com>
 <CA+55aFwMsm7zVqPjKptm38zJAbJpF=9e51ew7BP6S5YnoJa3ig@mail.gmail.com>
 <20120419173802.GI3221@aftab.osrc.amd.com>
 <CA+55aFywgsZsxRpYeY2TCHUuK6uRvp8fp8GZEVk50qNc=WS=dw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFywgsZsxRpYeY2TCHUuK6uRvp8fp8GZEVk50qNc=WS=dw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 11:11:00AM -0700, Linus Torvalds wrote:
> > OTOH, if we can share early and normal exception handling lookup code, then a
> > perfect hash would make sense as those exceptions would pile up.
> 
> Oh, any of this only makes sense if we can share it with the runtime
> exception lookup.
> 
> They are *seldom* hugely performance-critical, but there are some
> unusual loads where you do get a fair number of exceptions.

I was thinking, and this is probably purely hypothetical and tangential
to the topic but, what happens if we get an exception right in the
middle between using the early_idt_handler's and switching to the normal
trap handlers in trap_init()?

write_idt_entry() is a simple memcpy so what happens if we have a
half-written descriptor? Won't we need some locking there to atomize the
switch?

Or am I dreaming?

Thanks.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
GM: Alberto Bozzo
Reg: Dornach, Landkreis Muenchen
HRB Nr. 43632 WEEE Registernr: 129 19551
