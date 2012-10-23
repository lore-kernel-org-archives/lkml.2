Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964811Ab2JWXLu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 19:11:50 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39094 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933803Ab2JWXLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 19:11:48 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1210231545030.1221@chino.kir.corp.google.com>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
	<1351022666-6960-159-git-send-email-keescook@chromium.org>
	<alpine.DEB.2.00.1210231545030.1221@chino.kir.corp.google.com>
Date: Tue, 23 Oct 2012 16:11:47 -0700
X-Google-Sender-Auth: WFn9Z4k4dnnJZUlxdd1WMq4CIzE
Message-ID: <CAGXu5j+5m+Gj9aYJpkxA+GsRm3rg-RohD5n88amRbn634P=epw@mail.gmail.com>
Subject: Re: [PATCH 158/193] mm: remove CONFIG_EXPERIMENTAL
From: Kees Cook <keescook@chromium.org>
To: David Rientjes <rientjes@google.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Jan Beulich <JBeulich@novell.com>, Mel Gorman <mel@csn.ul.ie>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 3:46 PM, David Rientjes <rientjes@google.com> wrote:
> On Tue, 23 Oct 2012, Kees Cook wrote:
>
>> diff --git a/mm/Kconfig b/mm/Kconfig
>> index a3f8ddd..679945e 100644
>> --- a/mm/Kconfig
>> +++ b/mm/Kconfig
>> @@ -1,6 +1,5 @@
>>  config SELECT_MEMORY_MODEL
>>       def_bool y
>> -     depends on EXPERIMENTAL || ARCH_SELECT_MEMORY_MODEL
>>
>>  choice
>>       prompt "Memory model"
>
> This makes ARCH_SELECT_MEMORY_MODEL pointless, why keep it around?

Good point. This seems to trigger much deeper changes. All of these
and their logic go away:

arch/arm/Kconfig:config ARCH_SELECT_MEMORY_MODEL
arch/arm/mach-clps711x/Kconfig: select ARCH_SELECT_MEMORY_MODEL
arch/arm64/Kconfig:config ARCH_SELECT_MEMORY_MODEL
arch/ia64/Kconfig:config ARCH_SELECT_MEMORY_MODEL
arch/parisc/Kconfig:config ARCH_SELECT_MEMORY_MODEL
arch/powerpc/Kconfig:config ARCH_SELECT_MEMORY_MODEL
arch/s390/Kconfig:config ARCH_SELECT_MEMORY_MODEL
arch/sh/mm/Kconfig:config ARCH_SELECT_MEMORY_MODEL
arch/sparc/Kconfig:config ARCH_SELECT_MEMORY_MODEL
arch/x86/Kconfig:config ARCH_SELECT_MEMORY_MODEL

Along with mm/Kconfig:config SELECT_MEMORY_MODEL and associated logic.

How about we handle this as a phase 2, and for phase 1, I just drop
EXPERIMENTAL?

-Kees

-- 
Kees Cook
Chrome OS Security
