Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756467Ab2LMShG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Dec 2012 13:37:06 -0500
Received: from mail.skyhub.de ([78.46.96.112]:40273 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756268Ab2LMShE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Dec 2012 13:37:04 -0500
Date: Thu, 13 Dec 2012 19:37:00 +0100
From: Borislav Petkov <bp@alien8.de>
To: Joe Perches <joe@perches.com>
Cc: "Luck, Tony" <tony.luck@intel.com>, Jiri Kosina <trivial@kernel.org>,
        Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, "x86@kernel.org" <x86@kernel.org>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "user-mode-linux-devel@lists.sourceforge.net" 
	<user-mode-linux-devel@lists.sourceforge.net>,
        "user-mode-linux-user@lists.sourceforge.net" 
	<user-mode-linux-user@lists.sourceforge.net>
Subject: Re: [TRIVIAL PATCH 16/26] x86: Convert print_symbol to %pSR
Message-ID: <20121213183659.GC31485@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Joe Perches <joe@perches.com>, "Luck, Tony" <tony.luck@intel.com>,
	Jiri Kosina <trivial@kernel.org>, Jeff Dike <jdike@addtoit.com>,
	Richard Weinberger <richard@nod.at>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
	"x86@kernel.org" <x86@kernel.org>,
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
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1355422990.13796.9.camel@joe-AO722>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 13, 2012 at 10:23:10AM -0800, Joe Perches wrote:
> m->ip is a u64 so, when compiling x86-32, there's a new warning
> "cast to pointer from integer of different size".  This isn't new
> different behavior, just a new warning.  The previous print_symbol
> took a ulong and the u64 was silently truncated.
> 
>   CC      arch/x86/kernel/cpu/mcheck/mce.o
> arch/x86/kernel/cpu/mcheck/mce.c: In function ‘print_mce’:
> arch/x86/kernel/cpu/mcheck/mce.c:246:4: warning: cast to pointer from integer of different size [-Wint-to-pointer-cast]
> 
> If appropriate, the code could be changed to
> 
> 	(void *)(unsigned long)m->ip

Can we explicitly cast it to what it is so that we can be explicit as to
what we're casting it? IOW:

	(void *)(__u64)m->ip;

Does that even work on 32bit?

Also, does the compiler bitch about this useless cast when building with
W=123?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
