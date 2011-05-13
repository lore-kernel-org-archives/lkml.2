Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab1EMAze (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 May 2011 20:55:34 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:29640 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752320Ab1EMAzc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 May 2011 20:55:32 -0400
Message-ID: <4DCC817D.3090005@tilera.com>
Date: Thu, 12 May 2011 20:55:25 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 5.1; en-US; rv:1.9.2.17) Gecko/20110414 Lightning/1.0b2 Thunderbird/3.1.10
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Andrew Morton <akpm@linux-foundation.org>, <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, <x86@kernel.org>,
        <linux-parisc@vger.kernel.org>, <linux-s390@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>, Helge Deller <deller@gmx.de>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 9/9] Consolidate CONFIG_DEBUG_STRICT_USER_COPY_CHECKS
References: <1305244212-19183-1-git-send-email-sboyd@codeaurora.org> <1305244212-19183-10-git-send-email-sboyd@codeaurora.org>
In-Reply-To: <1305244212-19183-10-git-send-email-sboyd@codeaurora.org>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/12/2011 7:50 PM, Stephen Boyd wrote:
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
> ---
>  arch/tile/Kconfig               |    8 +-------
>  arch/tile/include/asm/uaccess.h |    7 ++++++-
>  arch/tile/lib/uaccess.c         |    8 --------

Acked-by: Chris Metcalf <cmetcalf@tilera.com>

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com


