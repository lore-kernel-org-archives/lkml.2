Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932187Ab2LMTFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 14:05:49 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40205 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932089Ab2LMTFr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 14:05:47 -0500
Date: Thu, 13 Dec 2012 20:05:44 +0100
From: Borislav Petkov <bp@alien8.de>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Joe Perches <joe@perches.com>, "Luck, Tony" <tony.luck@intel.com>,
        Jiri Kosina <trivial@kernel.org>, Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        "user-mode-linux-user@lists.sourceforge.net" 
	<user-mode-linux-user@lists.sourceforge.net>
Subject: Re: [TRIVIAL PATCH 16/26] x86: Convert print_symbol to %pSR
Message-ID: <20121213190544.GD31485@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"H. Peter Anvin" <hpa@zytor.com>, Joe Perches <joe@perches.com>,
	"Luck, Tony" <tony.luck@intel.com>,
	Jiri Kosina <trivial@kernel.org>, Jeff Dike <jdike@addtoit.com>,
	Richard Weinberger <richard@nod.at>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
	"linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
	"user-mode-linux-devel@lists.sourceforge.net" <user-mode-linux-devel@lists.sourceforge.net>,
	"user-mode-linux-user@lists.sourceforge.net" <user-mode-linux-user@lists.sourceforge.net>
References: <cover.1355335227.git.joe@perches.com>
 <054f8a88fe46ae0b4c2669d0e155d84c11b66115.1355335228.git.joe@perches.com>
 <20121212210959.GH8760@liondog.tnic>
 <1355347803.8538.16.camel@joe-AO722>
 <3908561D78D1C84285E8C5FCA982C28F1C969495@ORSMSX108.amr.corp.intel.com>
 <1355351039.27571.2.camel@joe-AO722>
 <20121212224550.GJ8760@liondog.tnic>
 <1355422990.13796.9.camel@joe-AO722>
 <20121213183659.GC31485@liondog.tnic>
 <50CA2194.40103@zytor.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <50CA2194.40103@zytor.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 10:42:28AM -0800, H. Peter Anvin wrote:
> On 12/13/2012 10:37 AM, Borislav Petkov wrote:
> >>
> >> If appropriate, the code could be changed to
> >>
> >> 	(void *)(unsigned long)m->ip
> > 
> > Can we explicitly cast it to what it is so that we can be explicit as to
> > what we're casting it? IOW:
> > 
> > 	(void *)(__u64)m->ip;
> > 
> > Does that even work on 32bit?
> > 
> > Also, does the compiler bitch about this useless cast when building with
> > W=123?
> > 
> 
> Uh... no.
> 
> The point is that (void *)(unsigned long) casts it to an integer of
> pointer size -- in userspace you would to (void *)(size_t) or (void
> *)(uintptr_t) -- so that the compiler knows "I meant to do that."

Ok, I grok it now. So, in most cases, mce.ip comes from pt_regs.ip which
is unsigned long so we're fine for both 32- and 64-bit. There's only the
case with precise RIP reporting where we get the rip from an MSR but
even then, it should be 4 bytes on 32-bit since our addresses there are
4 bytes.

So, actually struct mce should've had ->ip defined as an unsigned long
from the very beginning. But we can't change that now because this
struct is shared with userspace :(

So yes Joe, make it (void *)(unsigned long).

Thanks guys.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
