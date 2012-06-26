Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754850Ab2FZJhQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 05:37:16 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43941 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751015Ab2FZJhO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 05:37:14 -0400
Message-ID: <4FE982BD.1090004@suse.cz>
Date: Tue, 26 Jun 2012 11:37:01 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:11.0) Gecko/20120328 Thunderbird/11.0.1
MIME-Version: 1.0
To: Sam Ravnborg <sam@ravnborg.org>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 5/8] kbuild: move definitions from top-level Makefile
 to scripts/Kbuild.config
References: <20120505080640.GA13773@merkur.ravnborg.org> <1336205926-13946-5-git-send-email-sam@ravnborg.org>
In-Reply-To: <1336205926-13946-5-git-send-email-sam@ravnborg.org>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sam,

Sorry for the delay. I hope you still remember what you submitted ;)

On 5.5.2012 10:18, Sam Ravnborg wrote:
> +# Tools to build for the target
> +export AS       := $(CROSS_COMPILE)as
> +export LD       := $(CROSS_COMPILE)ld
> +export CC       := $(CROSS_COMPILE)gcc
> +export CPP      := $(CC) -E
> +export AR       := $(CROSS_COMPILE)ar
> +export NM       := $(CROSS_COMPILE)nm
> +export STRIP    := $(CROSS_COMPILE)strip
> +export OBJCOPY  := $(CROSS_COMPILE)objcopy
> +export OBJDUMP  := $(CROSS_COMPILE)objdump

The := assignments do not work if CROSS_COMPILE is set in .config or in
the arch Makefile. You have to use the deferred from here.

Michal
