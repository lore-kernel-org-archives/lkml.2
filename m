Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934144Ab2JWXPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 19:15:52 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:65508 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934100Ab2JWXPi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 19:15:38 -0400
Date: Tue, 23 Oct 2012 16:15:36 -0700 (PDT)
From: David Rientjes <rientjes@google.com>
X-X-Sender: rientjes@chino.kir.corp.google.com
To: Kees Cook <keescook@chromium.org>
cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Beulich <JBeulich@novell.com>, Mel Gorman <mel@csn.ul.ie>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: Re: [PATCH 158/193] mm: remove CONFIG_EXPERIMENTAL
In-Reply-To: <CAGXu5j+5m+Gj9aYJpkxA+GsRm3rg-RohD5n88amRbn634P=epw@mail.gmail.com>
Message-ID: <alpine.DEB.2.00.1210231613300.3408@chino.kir.corp.google.com>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org> <1351022666-6960-159-git-send-email-keescook@chromium.org> <alpine.DEB.2.00.1210231545030.1221@chino.kir.corp.google.com>
 <CAGXu5j+5m+Gj9aYJpkxA+GsRm3rg-RohD5n88amRbn634P=epw@mail.gmail.com>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Oct 2012, Kees Cook wrote:

> > This makes ARCH_SELECT_MEMORY_MODEL pointless, why keep it around?
> 
> Good point. This seems to trigger much deeper changes. All of these
> and their logic go away:
> 
> arch/arm/Kconfig:config ARCH_SELECT_MEMORY_MODEL
> arch/arm/mach-clps711x/Kconfig: select ARCH_SELECT_MEMORY_MODEL
> arch/arm64/Kconfig:config ARCH_SELECT_MEMORY_MODEL
> arch/ia64/Kconfig:config ARCH_SELECT_MEMORY_MODEL
> arch/parisc/Kconfig:config ARCH_SELECT_MEMORY_MODEL
> arch/powerpc/Kconfig:config ARCH_SELECT_MEMORY_MODEL
> arch/s390/Kconfig:config ARCH_SELECT_MEMORY_MODEL
> arch/sh/mm/Kconfig:config ARCH_SELECT_MEMORY_MODEL
> arch/sparc/Kconfig:config ARCH_SELECT_MEMORY_MODEL
> arch/x86/Kconfig:config ARCH_SELECT_MEMORY_MODEL
> 
> Along with mm/Kconfig:config SELECT_MEMORY_MODEL and associated logic.
> 
> How about we handle this as a phase 2, and for phase 1, I just drop
> EXPERIMENTAL?
> 

Yeah, sounds like a good idea.  If anybody complains because they were 
allowed to select their memory model because CONFIG_EXPERIMENTAL=y and not 
because ARCH_SELECT_MEMORY_MODEL, then we should be able to fix the option 
for their arch.
