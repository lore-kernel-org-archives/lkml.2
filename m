Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753701Ab2BPRZy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 12:25:54 -0500
Received: from smtp.snhosting.dk ([87.238.248.203]:59569 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751800Ab2BPRZx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 12:25:53 -0500
Date: Thu, 16 Feb 2012 18:25:51 +0100
From: Sam Ravnborg <sam@ravnborg.org>
To: Alessandro Rubini <rubini@gnudd.com>, Arnd Bergmann <arnd@arndb.de>
Cc: linux@arm.linux.org.uk, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, giancarlo.asnaghi@st.com,
        alan@linux.intel.com
Subject: Re: [PATCH] ARM: amba: don't include <asm/sizes.h>
Message-ID: <20120216172551.GA31306@merkur.ravnborg.org>
References: <20120216160525.GA30558@mail.gnudd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120216160525.GA30558@mail.gnudd.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 05:05:25PM +0100, Alessandro Rubini wrote:
> The file uses no SZ_* symbol and some architectures miss sizes.h
> 
> Signed-off-by: Alessandro Rubini <rubini@gnudd.com>
> Acked-by: Giancarlo Asnaghi <giancarlo.asnaghi@st.com>
> ---
> 
> There a number of files including but not using it. This one
> in particular I need under x86 so the fix is trivial.
> 
> However, I remember different feelings about sizes.h . Should it die
> or should it proliferate to other archs using asm-generic/sizes.h ?

It would be good to have it included for all architectures.
It really has nothing arch specific in it so it ought to live in
include/linux:

    git mv include/asm-generic include/linux
    And a fix for the archs that will be broken by this.
    A small wrapper in arch/$ARCH/include/asm could do the trick


And speaking of this file I sometime have missed:
#define SZ_1K_BITS                       10
#define SZ_2K_BITS                       11

Or something similar.

	Sam
