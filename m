Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753883Ab1AYOPZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jan 2011 09:15:25 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:51438 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753870Ab1AYOPY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jan 2011 09:15:24 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Russell King - ARM Linux" <linux@arm.linux.org.uk>
Subject: Re: [PATCH v4 01/19] ARM: Make the argument to virt_to_phys() "const volatile"
Date: Tue, 25 Jan 2011 15:14:43 +0100
User-Agent: KMail/1.12.2 (Linux/2.6.35-22-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
References: <1295891761-18366-1-git-send-email-catalin.marinas@arm.com> <201101251100.11052.arnd@arndb.de> <20110125102905.GC11507@n2100.arm.linux.org.uk>
In-Reply-To: <20110125102905.GC11507@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201101251514.43808.arnd@arndb.de>
X-Provags-ID: V02:K0:kLu+4p1LRXCjlEPcP58gOXjbZVR2oFrtVpttgkHmQ+j
 CMpaMdQTpmtyoK/hyTG2zLayWqhYGhsfU5eXNtpNuG0cUZPDG3
 q2BohKmVXVYeBkl4DygBSX672ei7w/RbGjWzZjs8AzDBpmWQU/
 OP+W2Aw88TENkLDyxaxW/QqxiKrFdNGUFdqLtwPLO7o9mBI/De
 /6Lu1i+XHPbUihmWpfZ3g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 25 January 2011, Russell King - ARM Linux wrote:
> > Stephen, you might want to have a look at why the warning even appears
> > on MSM. Most uses of 'volatile' are misguided, and there could be an
> > actual bug in there.
> 
> It's actually the right thing - look at x86's definition:
> 
> static inline phys_addr_t virt_to_phys(volatile void *address)

Yes, the definition of virt_to_phys using a volatile pointer makes sense
because it allows you to pass volatile pointers, even if it doesn't
make any volatile accesses itself, hence my Acked-by.

However, marking variables as volatile needs to be done very carefully,
and the particular use in arch/arm/mach-msm/smd.c looks suspicious.
I don't think it can cause any actual harm to add volatile to the
smd_half_channel variables, but it disables some optimizations that
gcc can otherwise make, and it's not a replacement for locking or
atomic accesses.

	Arnd
