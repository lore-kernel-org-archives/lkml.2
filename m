Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751579Ab1GUO53 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jul 2011 10:57:29 -0400
Received: from ulysses.noc.ntua.gr ([147.102.222.230]:63626 "EHLO
	ulysses.noc.ntua.gr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751111Ab1GUO51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jul 2011 10:57:27 -0400
Message-ID: <4E283E36.6060904@ece.ntua.gr>
Date: Thu, 21 Jul 2011 17:56:54 +0300
From: Stratos Psomadakis <psomas@ece.ntua.gr>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jean Marc Olivieri <jmolivieri@algoria.fr>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33.16 Documentation/lguest breaks compile under debian x86
References: <1CCDCE528ADEE240A3F216D1B406A8F3472E91EF@PDCParis.algoria.local>
In-Reply-To: <1CCDCE528ADEE240A3F216D1B406A8F3472E91EF@PDCParis.algoria.local>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (ulysses.noc.ntua.gr [147.102.222.230]); Thu, 21 Jul 2011 17:57:24 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/21/2011 05:15 PM, Jean Marc Olivieri wrote:
> I'm currently using :
> Distributor ID:	Debian
> Description:	Debian GNU/Linux 6.0.2 (squeeze)
> Release:	6.0.2
> Codename:	squeeze
> On x86 PC.
>
> Kernel 2.6.33.16 fails to compile due to unfound include. Thus I got rid of it and it works.
> I successfully built kernels against :
> 	- x86
> 	- x64
>
> Here's the patch :
>
> diff -u -r a/linux-2.6.33.16/Documentation/lguest/lguest.c b/linux-2.6.33.16/Documentation/lguest/lguest.c
> --- a/linux-2.6.33.16/Documentation/lguest/lguest.c	2011-07-13 05:31:47.000000000 +0200
> +++ b/linux-2.6.33.16/Documentation/lguest/lguest.c	2011-07-21 15:16:03.331040033 +0200
> @@ -34,7 +34,6 @@
>  #include <sys/uio.h>
>  #include <termios.h>
>  #include <getopt.h>
> -#include <zlib.h>
>  #include <assert.h>
>  #include <sched.h>
>  #include <limits.h>
>
>
> Jean-Marc OLIVIERI
> Ingénieur développement
> +33 1 41 90 66 55
> jmolivieri@algoria.fr
>
>
>
> ALGORIA - Éditeur de TWS
> 31, rue Ernest Renan 92130 Issy-les-Moulineaux 
> +33 1 41 90 66 66 (std) / +33 1 41 90 66 56 (fax)
> www.algoria.fr
More recent kernels have removed the zlib.h include (upstream patch
28ff4ef7 [1]), but the patch wasn't included it in the older
-stable/-longterm kernels (obviously ;).

Anyway, you could also install the zlib headers (I think zlib1g-dev in
Debian) to make lguest launcher code compile.

[1]
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=commit;h=28ff4ef71795fe6f6c0cc06a04911c9ca09c2c11

-- 
Stratos Psomadakis
<psomas@ece.ntua.gr>

