Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752325Ab0HYMO3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 08:14:29 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:57967 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751840Ab0HYMO0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 08:14:26 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [PATCH v2] ARM: uaccess: Implement strict user copy checks
Date: Wed, 25 Aug 2010 14:14:16 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.35-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Stephen Boyd <sboyd@codeaurora.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Russell King <linux@arm.linux.org.uk>
References: <4C61EE55.5030506@codeaurora.org> <201008241726.08797.arnd@arndb.de> <20100824154740.GD2160@osiris.boeblingen.de.ibm.com>
In-Reply-To: <20100824154740.GD2160@osiris.boeblingen.de.ibm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008251414.16411.arnd@arndb.de>
X-Provags-ID: V02:K0:uvVPGNei2hnee/VfH7xmnfXyN4G2ZiRsiFu+FJbUcBw
 629Y2Fq4eMxgbAjUWcZC9ntpCFTjenkUc8KX06BhW+sDq50ZEg
 djLRSaqo7NVa1gTLJxpT0kAbnR7oiPmqVqg6I0TTmR9+7jqMVh
 5L0mRyEJzbfv/N64LzJ2Wcq2NATvFMGGm8fs2C9I2HdP6Gfem4
 1NhEXF14bS6A7Iygc5Lgg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 24 August 2010, Heiko Carstens wrote:
> On Tue, Aug 24, 2010 at 05:26:08PM +0200, Arnd Bergmann wrote:
> > Can't you just turn that option off then? Or are you worried about
> > allyesconfig builds?
> 
> I'd like to keep an allyesconfig compiling and booting.
> With the proposed change we would never see a green entry at
> http://kisskb.ellerman.id.au/kisskb/branch/9/ for s390's allyesconfig
> build ;)

Yes, that makes sense.

> Then maybe add a "choice" Kconfig option in a way that both allyesconfig
> as well as allnoconfig will build?

I think it would be easier to remove the config option entirely on s390
and just always warn. As I said earlier in this thread, I generally
don't think this particular warning is more important than a lot of
the other ones that we don't turn into errors.

I do think it would be helpful to optionally build parts of the kernel
with the much stronger '-Werror', which we already do for some
architectures. You could do that with inverted logic (bool "Disable -Werror
compile option) and fix all warnings in allnoconfig to make all of
allnoconfig, allyesconfig and defconfig build.

	Arnd
