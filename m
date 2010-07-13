Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756916Ab0GMUXB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Jul 2010 16:23:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60055 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752381Ab0GMUXA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Jul 2010 16:23:00 -0400
Message-ID: <4C3CCB1C.40206@suse.cz>
Date: Tue, 13 Jul 2010 22:22:52 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>,
        Catalin Marinas <catalin.marinas@arm.com>
Subject: Re: [PATCH] kbuild: Enable building defconfigs from Kconfig files
References: <20100713114322.57c8b166.sfr@canb.auug.org.au>
In-Reply-To: <20100713114322.57c8b166.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2010 03:43 AM, Stephen Rothwell wrote:
> After this change, doing a "make xxx_defconfig" will check first for
> a file called arch/<arch>/configs/Kconfig.xxx and use that to generate
> the .config (effectively starting from an allnoconfig).  If that file
> doesn't exist, it will use arch/<ARCH>/configs/xxx_defconfig as now.
> 
> Signed-off-by: Stephen Rothwell <sfr@canb.auug.org.au>
> ---
>  scripts/kconfig/Makefile |   14 +++++++++++++-
>  1 files changed, 13 insertions(+), 1 deletions(-)
> 
> Hi Linus,
> 
> Is this more the direction you want to take?
> 
> There are still 2 main problems with is approach:
> 
> 	- there are some config options that are globally and
> unconditionally enabled that some platforms may not want.  The only way
> currently to turn them off is to reproduce the config entry with the
> different default.  I am not sure if we need a wa to turn them off or to
> just change them to being neede to be selected by those that do want them.
> 	- we have no way to select options that are neither bool or
> tristate to suitable values.  Again the only way to do that currently is
> to reproduce the config entry with a different default value.

Hi Stephen,

how are these Kconfig.xxx files going look like? A list of 'select FOO'
 and 'include "Kconfig.other"' statements?

What about adding support for an include statement to the .config file
format and using that in the defconfigs instead? The VARIABLE=VALUE
grammar seems much more suitable for this than the kconfig language.

Michal
