Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab0ENO5l (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 10:57:41 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:37316 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751374Ab0ENO5j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 10:57:39 -0400
Date: Fri, 14 May 2010 07:54:53 -0700 (PDT)
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Eric W. Biederman" <ebiederm@xmission.com>
cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-input@vger.kernel.org, Bastien Nocera <hadess@hadess.net>
Subject: Re: [git pull] Input updates for 2.6.34-rc6
In-Reply-To: <m1aas2kjb6.fsf@fess.ebiederm.org>
Message-ID: <alpine.LFD.2.00.1005140751300.3711@i5.linux-foundation.org>
References: <20100513075728.GF30110@core.coreip.homeip.net> <alpine.LFD.2.00.1005130724280.3711@i5.linux-foundation.org> <20100513160117.GB22238@core.coreip.homeip.net> <alpine.LFD.2.00.1005130943460.3711@i5.linux-foundation.org> <20100513171639.GA23708@core.coreip.homeip.net>
 <alpine.LFD.2.00.1005131017070.3711@i5.linux-foundation.org> <20100513181002.GB23708@core.coreip.homeip.net> <alpine.LFD.2.00.1005131253310.3711@i5.linux-foundation.org> <m1aas2kjb6.fsf@fess.ebiederm.org>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Fri, 14 May 2010, Eric W. Biederman wrote:
> 
> efi_enabled is a guard on efi calls.  If it is true it tells you that
> you can make runtime efi calls.  If it is false you can't use runtime
> efi calls. efi_enabled does not tell you about the presence of efi
> on a system.

We don't really want to know about the "presense". What we want to know 
about is whether we were _loaded_ with EFI or not.

IOW, even if the system is EFI-capable, if we actually booted through the 
legacy BIOS interfaces, we would consider ourselves in "legacy" mode.

> All of which means in the normal case pay attention to acpi.  That is
> more likely to be correct and usable than EFI anything.

Oh yes. ACPI is actually _tested_, so while it's buggy, it's unlikely to 
be quite as spectacularly buggy as any EFI interfaces probably are.

But the issue here is that on a "legacy PC", we can't just say "ACPI 
doesn't mention this device, so it can't exist". Because in a legacy PC 
model, that simply isn't true. All those motherboard devices can easily 
exist (and do!) even if ACPI/PnP don't mention them.

But if we live in a non-legacy world (ie we were loaded through EFI), I 
think it's much more reasonable to say "we'll ignore any devices not 
mentioned by ACPI".

			Linus
