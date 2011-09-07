Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754584Ab1IGMzA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 08:55:00 -0400
Received: from cantor2.suse.de ([195.135.220.15]:49176 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754273Ab1IGMy4 (ORCPT <rfc822;linux-kernel@[209.132.180.67]>);
	Wed, 7 Sep 2011 08:54:56 -0400
Message-ID: <4E67699E.80208@suse.cz>
Date: Wed, 07 Sep 2011 14:54:54 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Shakthi Kannan <shakthimaan@gmail.com>
Cc: linux-kernel@[209.132.180.67]
Subject: Re: CRC calculation in Module.symvers
References: <CABG-yt0t0sgAvcDDLhjyNFGpY22tL0CtDvXV9+CxYJMf0MdVfA@mail.gmail.com>
In-Reply-To: <CABG-yt0t0sgAvcDDLhjyNFGpY22tL0CtDvXV9+CxYJMf0MdVfA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 7.9.2011 07:58, Shakthi Kannan wrote:
> 1. How the CRC is computed for an exported symbol present in
> Module.symvers file, and

The symbol type is recursively expanded and a checksum is computed from
the expanded


> 2. Given a kernel .c file, how can I obtain the CRC checksums for a symbol.
> 
> For linux-3.0.2 (example), I compiled with CONFIG_MODVERSIONS=y, and
> running 'make' built vmlinux, and generated the Module.symvers file. I
> believe genksyms is used to create the Module.symvers file?
> 
> I had referred the "Kernel Symbols and CONFIG_MODVERSIONS"
> documentation [1] written by Mark McLoughlin. I tried the following in
> the top-level kernel sources:
> 
>  $ gcc -E -D__GENKSYMS__ -DCONFIG_MODVERSIONS -DEXPORT_SYMTAB
> crypto/api.c -I/tmp/linux-3.0.2/include
> -I/tmp/linux-3.0.2/arch/x86/include | ./scripts/genksyms/genksyms

You need at least -include include/generated/autoconf.h, but the easies
would be

$ make V=1 crypto/api.symtypes

this will generate a file with the symbol expansions. And if you copy
the commandline without the >/dev/null redirection, you'll see the
calculated checksums on standard output.

Michal
