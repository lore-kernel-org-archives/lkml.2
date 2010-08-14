Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757252Ab0HNWi0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 18:38:26 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43985 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757105Ab0HNWiZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 18:38:25 -0400
Message-ID: <4C671ADF.6090006@suse.cz>
Date: Sun, 15 Aug 2010 00:38:23 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; cs-CZ; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kconfig: fix segfault when detecting recursive dependency
References: <20100814124329.GA28377@merkur.ravnborg.org> <20100814124458.GA28387@merkur.ravnborg.org>
In-Reply-To: <20100814124458.GA28387@merkur.ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dne 14.8.2010 14:44, Sam Ravnborg napsal(a):
> From 705dbd8a31520722bda78e1bc731e2880f8df0ff Mon Sep 17 00:00:00 2001
> From: Sam Ravnborg <sam@ravnborg.org>
> Date: Sat, 14 Aug 2010 14:40:00 +0200
> Subject: [PATCH] kconfig: fix segfault when detecting recursive dependency
> 
> Following sample Kconfig generated a segfault:
> 
> config FOO
>         bool
>         select PERF_EVENTS if HAVE_HW_BREAKPOINT
> 
> config PERF_EVENTS
>         bool
> 
> config HAVE_HW_BREAKPOINT
>         bool
>         depends on PERF_EVENTS
> 
> Fix by reverting back to a valid property if there was no
> property on the stack of symbols.

Applied, thanks.

Michal
