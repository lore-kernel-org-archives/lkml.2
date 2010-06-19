Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547Ab0FSRzH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 13:55:07 -0400
Received: from smtp.outflux.net ([198.145.64.163]:47407 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754549Ab0FSRzF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 13:55:05 -0400
Date: Sat, 19 Jun 2010 10:54:26 -0700
From: Kees Cook <kees.cook@canonical.com>
To: Arjan van de Ven <arjan@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       Alexander Potashev <aspotashev@gmail.com>,
       Tim Abbott <tabbott@ksplice.com>, Sam Ravnborg <sam@ravnborg.org>,
       Jan Beulich <jbeulich@novell.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] x86: clear XD_DISABLED flag on Intel to regain
 NX
Message-ID: <20100619175426.GX24749@outflux.net>
References: <20100619055010.GR24749@outflux.net>
 <874ogzph4m.fsf@basil.nowhere.org>
 <20100619081642.33b37676@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100619081642.33b37676@infradead.org>
Organization: Canonical
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Sat, Jun 19, 2010 at 08:16:42AM -0700, Arjan van de Ven wrote:
> On Sat, 19 Jun 2010 10:21:29 +0200
> Andi Kleen <andi@firstfloor.org> wrote:
> 
> > Kees Cook <kees.cook@canonical.com> writes:
> > 
> > > This will clear the MSR_IA32_MISC_ENABLE_XD_DISABLE bit so that NX
> > > cannot be inappropriately controlled by the BIOS on Intel CPUs.  If
> > > NX actually needs to be disabled, "noexec=off" can be used.
> > 
> > The patch still seems like a bad idea to me. What happens if 
> > the NX bit is broken for some reason and the BIOS is right
> > to disable it?
> 
> 
> overriding the bios like this is almost always a bad idea.
> (you're doing a blanket override, not a specific, verified override)

I've seen other things in the BIOS ignored (IDE bus settings jumps to
mind), so I figured it wasn't strictly bad.  From what I've been able to
gather, this setting is never correct.  If there are situations where it
must be left alone, we could add those as exceptions.

> you have no idea if the SMM code can deal with NX, etc etc.

The pages don't get marked as actually NX until setup_nx() is called, at
which point "noexec=off" would have already been handled, so if that
happens, a system can still boot with that cmdline option.

> the real answer is "fix your bios setting".

Well, the "best" answer is "fix the bios", which is why I got Dell to
fix their BIOSes.  Unfortunately, there are still systems with this
misconfigured.

> Don't as owner of the machine turn something off in the bios that you
> actually want.

Most people don't know/care, so if they do and it's a problem, I thought
using "noexec=off" would be sufficient while still allowing the bulk of
systems to end up with NX correctly enabled.

-Kees

-- 
Kees Cook
Ubuntu Security Team
