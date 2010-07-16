Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758821Ab0GPSSz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Jul 2010 14:18:55 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38594 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758789Ab0GPSSw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Jul 2010 14:18:52 -0400
MIME-Version: 1.0
In-Reply-To: <20100716180701.GA26854@n2100.arm.linux.org.uk>
References: <20100713230352.6781.18644.stgit@angua> <1279296221.17878.66.camel@e102109-lin.cambridge.arm.com> 
	<AANLkTinyFBTKYaryFANYheTuP-biJUws2x01NRNZPb4M@mail.gmail.com> 
	<20100716180701.GA26854@n2100.arm.linux.org.uk>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Fri, 16 Jul 2010 12:18:29 -0600
X-Google-Sender-Auth: zMDTWVRNcpg0BO9qI2sC6FtWUvk
Message-ID: <AANLkTilfgiQyvcBhEmdc5P8HXSUHgAG7SUa0Mz4ev6ze@mail.gmail.com>
Subject: Re: [RFC PATCH] Kconfig: Enable Kconfig fragments to be used for 
	defconfig
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Catalin Marinas <catalin.marinas@arm.com>, linuxppc-dev@lists.ozlabs.org,
        Nicolas Pitre <nico@fluxnic.net>,
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

On Fri, Jul 16, 2010 at 12:07 PM, Russell King - ARM Linux
<linux@arm.linux.org.uk> wrote:
> On Fri, Jul 16, 2010 at 11:57:55AM -0600, Grant Likely wrote:
>> Last missing piece is being able to do "select FOO = n", which Stephen
>> is currently working on.
>
> I thought Linus' idea was to use:
>
> KBUILD_KCONFIG=file make allnoconfig

That was more a prototype of the idea; but it's a pretty cumbersome
user interface.  :-)  By changing the makefile to look for kconfig
fragments in the configs directory, the user interface for choosing a
config remains exactly the same.

As for the allnoconfig bit....

> in which case any option which would be presented to the user which hasn't
> been selected by 'file' ends up being set to n.  That means there's no
> need for a special "select FOO=n" construct.

...Linus chimed in on this that he doesn't actually care much.  I
think defconfig with an empty initial config file makes a lot more
sense than allnoconfig so that we're using the default values from the
normal Kconfig files.

> See one of Linus' replies on June 3:
> Message-ID: <alpine.LFD.2.00.1006031317410.8175@i5.linux-foundation.org>

See this response:
Message-ID: <AANLkTik-QCXFnjma3J28B9h27uajOcDhthTGz99zKgVi@mail.gmail.com>

http://news.gmane.org/find-root.php?message_id=%3cAANLkTik%2dQCXFnjma3J28B9h27uajOcDhthTGz99zKgVi%40mail.gmail.com%3e

g.

-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
