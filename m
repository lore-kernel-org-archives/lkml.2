Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757506Ab1EMHbc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 03:31:32 -0400
Received: from mx2.mail.elte.hu ([157.181.151.9]:52531 "EHLO mx2.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757231Ab1EMHba (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 03:31:30 -0400
Date: Fri, 13 May 2011 09:31:01 +0200
From: Ingo Molnar <mingo@elte.hu>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
        linux-parisc@vger.kernel.org, linux-s390@vger.kernel.org,
        Arjan van de Ven <arjan@linux.intel.com>, Helge Deller <deller@gmx.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Chris Metcalf <cmetcalf@tilera.com>,
        Arjan van de Ven <arjan@infradead.org>
Subject: Re: [PATCH 9/9] Consolidate CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
Message-ID: <20110513073101.GD10584@elte.hu>
References: <1305244212-19183-1-git-send-email-sboyd@codeaurora.org>
 <1305244212-19183-10-git-send-email-sboyd@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1305244212-19183-10-git-send-email-sboyd@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.3.1
	-2.0 BAYES_00               BODY: Bayes spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephen Boyd <sboyd@codeaurora.org> wrote:

> The help text for this config is duplicated across the x86,
> parisc, and s390 Kconfig.debug files. Arnd Bergman noted that the
> help text was slightly misleading and should be fixed to state
> that enabling this option isn't a problem when using pre 4.4 gcc.
> 
> To simplify the rewording, consolidate the text into
> lib/Kconfig.debug and modify it there to be more explicit about
> when you should say N to this config.
> 
> Also, make the text a bit more generic by stating that this
> option enables compile time checks so we can cover architectures
> which emit warnings vs. ones which emit errors. The details of
> how an architecture decided to implement the checks isn't as
> important as the concept of compile time checking of
> copy_from_user() calls.
> 
> While we're doing this, remove all the copy_from_user_overflow()
> code that's duplicated many times and place it into lib/ so that
> any architecture supporting this option can get the function for
> free.
> 
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: x86@kernel.org
> Cc: linux-parisc@vger.kernel.org
> Cc: linux-s390@vger.kernel.org
> Cc: Arjan van de Ven <arjan@linux.intel.com>
> Cc: Helge Deller <deller@gmx.de>
> Cc: Heiko Carstens <heiko.carstens@de.ibm.com>
> Cc: Stephen Rothwell <sfr@canb.auug.org.au>
> Cc: Chris Metcalf <cmetcalf@tilera.com>
> Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/parisc/Kconfig             |    1 +
>  arch/parisc/Kconfig.debug       |   14 --------------
>  arch/s390/Kconfig               |    1 +
>  arch/s390/Kconfig.debug         |   14 --------------
>  arch/s390/lib/Makefile          |    1 -
>  arch/s390/lib/usercopy.c        |    8 --------
>  arch/sparc/lib/Makefile         |    1 -
>  arch/sparc/lib/usercopy.c       |    8 --------
>  arch/tile/Kconfig               |    8 +-------
>  arch/tile/include/asm/uaccess.h |    7 ++++++-
>  arch/tile/lib/uaccess.c         |    8 --------
>  arch/x86/Kconfig                |    1 +
>  arch/x86/Kconfig.debug          |   14 --------------
>  arch/x86/lib/usercopy_32.c      |    6 ------
>  arch/x86/lib/usercopy_64.c      |    6 ------
>  lib/Kconfig.debug               |   18 ++++++++++++++++++
>  lib/Makefile                    |    1 +
>  lib/usercopy.c                  |    8 ++++++++
>  18 files changed, 37 insertions(+), 88 deletions(-)
>  delete mode 100644 arch/s390/lib/usercopy.c
>  delete mode 100644 arch/sparc/lib/usercopy.c
>  create mode 100644 lib/usercopy.c

Very nice!

Acked-by: Ingo Molnar <mingo@elte.hu>

	Ingo
