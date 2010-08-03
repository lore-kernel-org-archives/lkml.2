Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756712Ab0HCNsz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Aug 2010 09:48:55 -0400
Received: from cantor.suse.de ([195.135.220.2]:60886 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756696Ab0HCNsw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Aug 2010 09:48:52 -0400
Message-ID: <4C581DEE.8080205@suse.cz>
Date: Tue, 03 Aug 2010 15:47:26 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.10) Gecko/20100520 SUSE/3.0.5 Thunderbird/3.0.5
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
Cc: linux-kbuild <linux-kbuild@vger.kernel.org>, linux-arch@vger.kernel.org,
        Parisc List <linux-parisc@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
        Tim Abbott <tabbott@ksplice.com>, Tim Bird <tim.bird@am.sony.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Matt Fleming <matt@console-pimps.org>, Arnd Bergmann <arnd@arndb.de>,
        Anders Kaseorg <andersk@mit.edu>, Andi Kleen <andi@firstfloor.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH 2/4] module linker script: coalesce function and data
 sections
References: <1280360876-2571-1-git-send-email-vda.linux@googlemail.com> <1280360876-2571-3-git-send-email-vda.linux@googlemail.com>
In-Reply-To: <1280360876-2571-3-git-send-email-vda.linux@googlemail.com>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29.7.2010 01:47, Denys Vlasenko wrote:
>  SECTIONS {
> +
> +	/* Coalesce sections produced by gcc -ffunction-sections */
> +	.text   0 : AT(0) { *(.text .text.[A-Za-z0-9_$^]*) }
> +
> +	/* Coalesce sections produced by gcc -fdata-sections */
> +	.rodata 0 : AT(0) { *(.rodata .rodata.[A-Za-z0-9_$^]*) }
> +	.data   0 : AT(0) { *(.data .data.[A-Za-z0-9_$^]*) }
> +	.bss    0 : AT(0) { *(.bss .bss.[A-Za-z0-9_$^]*) }
> +
>  	/DISCARD/ : { *(.discard) }
>  }

I'm now getting

ld:/home/mmarek/linux-2.6/scripts/module-common.lds:23: ignoring invalid
character `^' in script
ld:/home/mmarek/linux-2.6/scripts/module-common.lds:26: ignoring invalid
character `^' in script
ld:/home/mmarek/linux-2.6/scripts/module-common.lds:27: ignoring invalid
character `^' in script
ld:/home/mmarek/linux-2.6/scripts/module-common.lds:28: ignoring invalid
character `^' in script

when linking modules and a similar warning when linking vmlinux (caused
by the next patch in series). I tried writing the carets as \^, but that
doesn't help at all...

$ ld --version
GNU ld (GNU Binutils; openSUSE Factory) 2.20.0.20100122-7

Michal
