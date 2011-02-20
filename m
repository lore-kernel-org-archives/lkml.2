Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753368Ab1BTUAu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Feb 2011 15:00:50 -0500
Received: from mail.perches.com ([173.55.12.10]:3816 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750958Ab1BTUAt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Feb 2011 15:00:49 -0500
Subject: Re: [PATCH] kbuild: Add extra gcc checks
From: Joe Perches <joe@perches.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Sam Ravnborg <sam@ravnborg.org>, Michal Marek <mmarek@suse.cz>,
        torvalds@linux-foundation.org, x86@kernel.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@elte.hu>,
        linux-kbuild@vger.kernel.org
In-Reply-To: <20110220193906.GC6713@liondog.tnic>
References: <1298219710-9846-1-git-send-email-bp@alien8.de>
	 <20110220175709.GA5178@merkur.ravnborg.org>
	 <20110220193906.GC6713@liondog.tnic>
Content-Type: text/plain; charset="UTF-8"
Date: Sun, 20 Feb 2011 12:00:47 -0800
Message-ID: <1298232047.1284.14.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2011-02-20 at 20:39 +0100, Borislav Petkov wrote:
> diff --git a/scripts/Makefile.build b/scripts/Makefile.build
> +# make W=1 settings
> +ifdef KBUILD_ENABLE_EXTRA_GCC_CHECKS

ifeq ($(KBUILD_ENABLE_EXTRA_GCC_CHECKS),1)

> +EXTRA_CFLAGS += -Wextra -Wno-unused

Why add -Wno-unused ?

If it's because of verbosity, maybe

ifeq ($(KBUILD_ENABLE_EXTRA_GCC_CHECKS),2)
EXTRA_CFLAGS += -Wunused
endif

