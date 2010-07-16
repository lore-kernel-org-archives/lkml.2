Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758922Ab0GPSww (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 14:52:52 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:57879 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758851Ab0GPSwu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 14:52:50 -0400
MIME-Version: 1.0
In-Reply-To: <20100716183028.GB26854@n2100.arm.linux.org.uk>
References: <20100713230352.6781.18644.stgit@angua> <1279296221.17878.66.camel@e102109-lin.cambridge.arm.com> 
	<AANLkTinyFBTKYaryFANYheTuP-biJUws2x01NRNZPb4M@mail.gmail.com> 
	<alpine.LFD.2.00.1007161406120.10598@xanadu.home> <20100716183028.GB26854@n2100.arm.linux.org.uk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 16 Jul 2010 12:52:29 -0600
X-Google-Sender-Auth: hfFfqH-FgCeM9gNXao-FBK6U3zw
Message-ID: <AANLkTilSHe2KD-2LJeUZp-I30LgfjCCPuJnObVzG4Bzo@mail.gmail.com>
Subject: Re: [RFC PATCH] Kconfig: Enable Kconfig fragments to be used for 
	defconfig
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Nicolas Pitre <nico@fluxnic.net>,
        Catalin Marinas <catalin.marinas@arm.com>,
        linuxppc-dev@lists.ozlabs.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Tony Lindgren <tony@atomide.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 12:30 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Jul 16, 2010 at 02:19:31PM -0400, Nicolas Pitre wrote:
>> For example, if I want CONFIG_MTD_CMDLINE_PARTS=y, the system may be
>> smart enough to notice and automatically enable CONFIG_MTD and
>> CONFIG_MTD_PARTITIONS without having to carry those in the defconfig.
>
> How do you sort out something like this:
>
> config FOO
>        bool "Foo"
>        depends on (A && B) || C
>
> Do you enable A and B, A, B and C or just C?
>
> Bear in mind that A could be 'X86', 'M68K' or any other arch specific
> symbol.
>
> I prefer the warning method because it prompts you to investigate what's
> changed and sort out the problem by ensuring that the appropriate symbols
> are also selected.  The automatic selection of dependencies method carries
> the risk that it'll do the wrong thing with the above scenario.

Good point.

g.
