Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754761Ab1HJTKV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 15:10:21 -0400
Received: from mail.windriver.com ([147.11.1.11]:34962 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753890Ab1HJTKT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 15:10:19 -0400
Message-ID: <4E42D769.8030704@windriver.com>
Date: Wed, 10 Aug 2011 15:09:29 -0400
From: Paul Gortmaker <paul.gortmaker@windriver.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Mike Frysinger <vapier.adi@gmail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>, <mingo@elte.hu>,
        <linux-kernel@vger.kernel.org>, <akpm@linux-foundation.org>,
        <linux-arch@vger.kernel.org>, <sfr@canb.auug.org.au>
Subject: Re: [RFC/PULL 00/11] introduce export.h; reduce module.h usage
References: <1311830178-30314-1-git-send-email-paul.gortmaker@windriver.com> <CA+55aFwtyfzaFABHKD+OMWsojGov0JLmnrZimhVaOcrer=tJjQ@mail.gmail.com> <20110802183019.GB8393@windriver.com> <CAMjpGUcOagn-o_mETLDr-=pa-3sxq_iDjF=A8OGhdJg5+9ewpA@mail.gmail.com>
In-Reply-To: <CAMjpGUcOagn-o_mETLDr-=pa-3sxq_iDjF=A8OGhdJg5+9ewpA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [128.224.146.65]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-08-07 10:42 PM, Mike Frysinger wrote:

[...]

> 
> Blackfin is broken because of this.  a simple grep of the tree

I've run all the in-tree blackfin configs, so it is all good.

Have you thought about getting at least one blackfin defconfig in
the linux-next build coverage?  Gives you a better chance of
having people see when they've broken it.

Thanks,
Paul.

> probably could pick this up.  maybe something like:
> grep EXPORT_SYMBOL * -rIl | xargs grep -L linux/export.h
> 
> from my logs, i see at least:
> arch/blackfin/kernel/dma-mapping.c:103: warning: type defaults to
> 'int' in declaration of 'EXPORT_SYMBOL'
> arch/blackfin/kernel/dma-mapping.c:111: warning: type defaults to
> 'int' in declaration of 'EXPORT_SYMBOL'
> arch/blackfin/kernel/dma-mapping.c:121: warning: type defaults to
> 'int' in declaration of 'EXPORT_SYMBOL'
> arch/blackfin/kernel/dma-mapping.c:136: warning: type defaults to
> 'int' in declaration of 'EXPORT_SYMBOL'
> arch/blackfin/kernel/dma-mapping.c:148: warning: type defaults to
> 'int' in declaration of 'EXPORT_SYMBOL'
> arch/blackfin/kernel/sys_bfin.c:50: warning: type defaults to 'int' in
> declaration of 'EXPORT_SYMBOL'
> arch/blackfin/mach-bf518/boards/ezbrd.c:825: warning: type defaults to
> 'int' in declaration of 'EXPORT_SYMBOL'
> arch/blackfin/mach-bf527/boards/ad7160eval.c:852: warning: type
> defaults to 'int' in declaration of 'EXPORT_SYMBOL'
> arch/blackfin/mach-bf527/boards/ezbrd.c:876: warning: type defaults to
> 'int' in declaration of 'EXPORT_SYMBOL'
> arch/blackfin/mach-bf527/boards/ezkit.c:1317: warning: type defaults
> to 'int' in declaration of 'EXPORT_SYMBOL'
> arch/blackfin/mach-bf527/boards/tll6527m.c:938: warning: type defaults
> to 'int' in declaration of 'EXPORT_SYMBOL'
> arch/blackfin/mach-bf537/boards/dnp5370.c:396: warning: type defaults
> to 'int' in declaration of 'EXPORT_SYMBOL'
> arch/blackfin/mm/init.c:22: warning: type defaults to 'int' in
> declaration of 'EXPORT_SYMBOL'
> arch/blackfin/mm/init.c:32: warning: type defaults to 'int' in
> declaration of 'EXPORT_SYMBOL'
> sound/soc/blackfin/bf5xx-sport.c:1002: warning: type defaults to 'int'
> in declaration of 'EXPORT_SYMBOL'
> sound/soc/blackfin/bf5xx-sport.c:107: warning: type defaults to 'int'
> in declaration of 'EXPORT_SYMBOL'
> sound/soc/blackfin/bf5xx-sport.c:1089: warning: type defaults to 'int'
> in declaration of 'EXPORT_SYMBOL'
> sound/soc/blackfin/bf5xx-sport.c:124: warning: type defaults to 'int'
> in declaration of 'EXPORT_SYMBOL'
> sound/soc/blackfin/bf5xx-sport.c:271: warning: type defaults to 'int'
> in declaration of 'EXPORT_SYMBOL'
> sound/soc/blackfin/bf5xx-sport.c:293: warning: type defaults to 'int'
> in declaration of 'EXPORT_SYMBOL'
> sound/soc/blackfin/bf5xx-sport.c:353: warning: type defaults to 'int'
> in declaration of 'EXPORT_SYMBOL'
> sound/soc/blackfin/bf5xx-sport.c:373: warning: type defaults to 'int'
> in declaration of 'EXPORT_SYMBOL'
> sound/soc/blackfin/bf5xx-sport.c:451: warning: type defaults to 'int'
> in declaration of 'EXPORT_SYMBOL'
> sound/soc/blackfin/bf5xx-sport.c:515: warning: type defaults to 'int'
> in declaration of 'EXPORT_SYMBOL'
> sound/soc/blackfin/bf5xx-sport.c:591: warning: type defaults to 'int'
> in declaration of 'EXPORT_SYMBOL'
> sound/soc/blackfin/bf5xx-sport.c:599: warning: type defaults to 'int'
> in declaration of 'EXPORT_SYMBOL'
> sound/soc/blackfin/bf5xx-sport.c:610: warning: type defaults to 'int'
> in declaration of 'EXPORT_SYMBOL'
> sound/soc/blackfin/bf5xx-sport.c:621: warning: type defaults to 'int'
> in declaration of 'EXPORT_SYMBOL'
> sound/soc/blackfin/bf5xx-sport.c:775: warning: type defaults to 'int'
> in declaration of 'EXPORT_SYMBOL'
> sound/soc/blackfin/bf5xx-sport.c:786: warning: type defaults to 'int'
> in declaration of 'EXPORT_SYMBOL'
> sound/soc/blackfin/bf5xx-sport.c:797: warning: type defaults to 'int'
> in declaration of 'EXPORT_SYMBOL'
> sound/soc/blackfin/bf5xx-sport.c:90: warning: type defaults to 'int'
> in declaration of 'EXPORT_SYMBOL'
> sound/soc/blackfin/bf5xx-sport.c:968: warning: type defaults to 'int'
> in declaration of 'EXPORT_SYMBOL'
> -mike
