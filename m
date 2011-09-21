Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753414Ab1IUL50 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 07:57:26 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:47110 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752794Ab1IUL5Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 07:57:24 -0400
Subject: Re: [PATCH v2 10/10] x86, efi: EFI boot stub support
From: Matt Fleming <matt@console-pimps.org>
To: Maarten Lankhorst <m.b.lankhorst@gmail.com>
Cc: Matt Domsch <Matt_Domsch@Dell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Matthew Garrett <mjg@redhat.com>, "x86@kernel.org" <x86@kernel.org>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        Mike Waychison <mikew@google.com>, Andi Kleen <andi@firstfloor.org>,
        "Hargrave, Jordan" <Jordan_Hargrave@Dell.com>
In-Reply-To: <4E748EB2.1000203@gmail.com>
References: <1315838094-2307-1-git-send-email-matt@console-pimps.org>
	 <1315838094-2307-11-git-send-email-matt@console-pimps.org>
	 <4E6F69A1.9030406@gmail.com>
	 <1316016478.3466.74.camel@mfleming-mobl1.ger.corp.intel.com>
	 <20110915045231.GA32136@emperor.us.dell.com> <4E71B196.1060504@gmail.com>
	 <20110915115255.GA4669@emperor.us.dell.com>  <4E71F33C.2010809@gmail.com>
	 <1316259866.3578.20.camel@mfleming-mobl1.ger.corp.intel.com>
	 <4E748EB2.1000203@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 12:57:21 +0100
Message-ID: <1316606241.5262.15.camel@mfleming-mobl1.ger.corp.intel.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 (2.32.2-1.fc14) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-09-17 at 14:12 +0200, Maarten Lankhorst wrote:
> Anyhow it seems the cmdline_size is meant for reading, and setting it
> is completely ignored, see below. Could we make it a static array so
> no allocation needs to be done?

D'oh. Yeah, you're right, there's no point in updating cmdline_size.

What would be the benefit of making cmdline a static array and skipping
the allocation? I doubt it would improve boot time, and we'd end up
making the bzImage larger.

> > Hmm... I'm really not convinced that we need to support ASCII cmdline
> > arguments, sorry. efibootmgr has support for UCS-2, so that's what
> > should be used.
> >
> I know, but this is nicer for displaying, compare this efibootmgr -v output:
> 
> Boot0002* Linux ASCII Boot     HD(...)File(\vmlinuz.efi)root=/dev/sdb2 console=ttyS0,115200n8.
> Boot0003* Linux UCS-2 Boot     HD(...)File(\vmlinuz.efi)r.o.o.t.=./.d.e.v./.s.d.b.2. .c.o.n.s.o.l.e.=.t.t.y.S.0.,.1.1.5.2.0.0.n.8...
> 
> And it's more foolproof, since it's easy to pass strings as
> ASCII since it's the default, and it would show up readable in efibootmgr.

But if you don't like the output from efibootmgr, you should fix
efibootmgr, not cram more string manipulation code into the EFI stub.

If there were other cases where an ASCII cmdline was passed to the stub
I'd be more inclined to support it. But if it's just a case of "the EFI
boot stub doesn't parse arguments when efibootmgr passes them as ASCII"
my response is "Pass them as UCS-2 then".

-- 
Matt Fleming, Intel Open Source Technology Center

