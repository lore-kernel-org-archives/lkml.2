Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754797Ab0FSIVc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Jun 2010 04:21:32 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59102 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754665Ab0FSIVb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Jun 2010 04:21:31 -0400
From: Andi Kleen <andi@firstfloor.org>
To: Kees Cook <kees.cook@canonical.com>
Cc: x86@kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Alexander Potashev <aspotashev@gmail.com>,
       Tim Abbott <tabbott@ksplice.com>, Sam Ravnborg <sam@ravnborg.org>,
       Jan Beulich <jbeulich@novell.com>,
       Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/4] x86: clear XD_DISABLED flag on Intel to regain NX
References: <20100619055010.GR24749@outflux.net>
Date: Sat, 19 Jun 2010 10:21:29 +0200
In-Reply-To: <20100619055010.GR24749@outflux.net> (Kees Cook's message of
	"Fri, 18 Jun 2010 22:50:10 -0700")
Message-ID: <874ogzph4m.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <kees.cook@canonical.com> writes:

> This will clear the MSR_IA32_MISC_ENABLE_XD_DISABLE bit so that NX cannot
> be inappropriately controlled by the BIOS on Intel CPUs.  If NX actually
> needs to be disabled, "noexec=off" can be used.

The patch still seems like a bad idea to me. What happens if 
the NX bit is broken for some reason and the BIOS is right
to disable it?

If there's some VM which doesn't ignore unknown MSR writes
it could also break early, and at best you get an ugly
message and at worst a crash.

Do you have evidence for a lot of systems where NX is disabled
this way without BIOS option? Really such information
should be in the patch description.

If you really need to apply it apply it in some place where
exception handling is possible at least.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
