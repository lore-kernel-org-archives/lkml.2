Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756207Ab0FSPRU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 11:17:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:33491 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756157Ab0FSPRT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 11:17:19 -0400
Date: Sat, 19 Jun 2010 08:16:42 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Kees Cook <kees.cook@canonical.com>, x86@kernel.org,
       "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
       Ingo Molnar <mingo@redhat.com>,
       Alexander Potashev <aspotashev@gmail.com>,
       Tim Abbott <tabbott@ksplice.com>, Sam Ravnborg <sam@ravnborg.org>,
       Jan Beulich <jbeulich@novell.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] x86: clear XD_DISABLED flag on Intel to regain
 NX
Message-ID: <20100619081642.33b37676@infradead.org>
In-Reply-To: <874ogzph4m.fsf@basil.nowhere.org>
References: <20100619055010.GR24749@outflux.net>
	<874ogzph4m.fsf@basil.nowhere.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i386-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 19 Jun 2010 10:21:29 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> Kees Cook <kees.cook@canonical.com> writes:
> 
> > This will clear the MSR_IA32_MISC_ENABLE_XD_DISABLE bit so that NX
> > cannot be inappropriately controlled by the BIOS on Intel CPUs.  If
> > NX actually needs to be disabled, "noexec=off" can be used.
> 
> The patch still seems like a bad idea to me. What happens if 
> the NX bit is broken for some reason and the BIOS is right
> to disable it?


overriding the bios like this is almost always a bad idea.
(you're doing a blanket override, not a specific, verified override)

you have no idea if the SMM code can deal with NX, etc etc.

the real answer is "fix your bios setting".
Don't as owner of the machine turn something off in the bios that you
actually want.


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
