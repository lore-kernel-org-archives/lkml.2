Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757292Ab0GPR6Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 13:58:24 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:55953 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756716Ab0GPR6W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 13:58:22 -0400
MIME-Version: 1.0
In-Reply-To: <1279296221.17878.66.camel@e102109-lin.cambridge.arm.com>
References: <20100713230352.6781.18644.stgit@angua> <1279296221.17878.66.camel@e102109-lin.cambridge.arm.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 16 Jul 2010 11:57:55 -0600
X-Google-Sender-Auth: dB0rVNNRRtDgNbDBMpbUtMIwD_o
Message-ID: <AANLkTinyFBTKYaryFANYheTuP-biJUws2x01NRNZPb4M@mail.gmail.com>
Subject: Re: [RFC PATCH] Kconfig: Enable Kconfig fragments to be used for 
	defconfig
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linuxppc-dev@lists.ozlabs.org, Nicolas Pitre <nico@fluxnic.net>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Russell King <rmk@arm.linux.org.uk>, Tony Lindgren <tony@atomide.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        =?ISO-8859-1?Q?Uwe_Kleine=2DK=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 16, 2010 at 10:03 AM, Catalin Marinas
<catalin.marinas@arm.com> wrote:
> On Wed, 2010-07-14 at 00:04 +0100, Grant Likely wrote:
>> - It still doesn't resolve dependencies.  A solver would help with this.
>>   For the time being I work around the problem by running the generated
>>   config through 'oldconfig' and looking for differences.  If the files
>>   differ (ignoring comments and generateconfig_* options) after oldconfig,
>>   then the <board>_defconfig target returns a failure.  (but leaves the
>>   new .config intact so the user can resolve it with menuconfig).  This
>>   way at least the user is told when a Kconfig fragment is invalid.
>
> It's not a solver but I'm pushing a patch to warn on selecting symbols
> with unmet dependencies so that you can select further symbols (manual
> solving). The patch is in linux-next but you also can grab it from:
>
> http://git.kernel.org/?p=linux/kernel/git/cmarinas/linux-2.6-cm.git;a=commitdiff_plain;h=5d87db2d2a332784bbf2b1ec3e141486f4d41d6f

sfr and I were talking about your patch the other day.  Just warning
on incomplete dependencies is enough to make it actually workable for
me (without my ugly post-processing step).  I was very happy to hear
that it is in linux-next.

Last missing piece is being able to do "select FOO = n", which Stephen
is currently working on.

g.
