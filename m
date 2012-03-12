Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755469Ab2CLObo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 10:31:44 -0400
Received: from usmamail.tilera.com ([206.83.70.75]:44223 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754067Ab2CLObh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 10:31:37 -0400
Message-ID: <4F5E08C7.9070400@tilera.com>
Date: Mon, 12 Mar 2012 10:31:35 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: <torvalds@linux-foundation.org>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        <stable@kernel.org>
Subject: Re: [PATCH] tile: remove a non-existing header
References: <1331561930-14964-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1331561930-14964-1-git-send-email-mchehab@redhat.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 3/12/2012 10:18 AM, Mauro Carvalho Chehab wrote:
> While testing some API changes at the EDAC core, I've tested the EDAC
> drivers compilation on all supported architectures, including Tilera.
>
> I noticed that Tilera upstream code has issues: it doesn't compile with
> kernel 3.2:
>
> In file included from include/linux/linkage.h:5,
>                  from include/linux/kernel.h:13,
>                  from include/linux/sched.h:55,
>                  from arch/tile/kernel/asm-offsets.c:19:
> /home/mchehab/redhat/trees/work/new_edac/arch/tile/include/asm/linkage.h:18:22: error: feedback.h: No such file or directory
> make[1]: *** [arch/tile/kernel/asm-offsets.s] Error 1
>
> Without it, it is not possible to compile anything on this archictecture
> using this default configuration:
> 	./arch/tile/configs/tilegx_defconfig
>
> Cc: stable@kernel.org
> Signed-of-by: Mauro Carvalho Chehab <mchehab@redhat.com>

Thank you, but nack.  The header is provided in the latest gcc tip code. 
Sorry for the API thrash!  It's certainly OK to comment it out for the time
being; it just provides some assembly macros for specifying feedback-guided
optimization.

> Btw, the ./arch/tile/configs/tilepro_defconfig doesn't compile even
> with this fix. It fails at arch/tile/include/asm/atomic_64.h because
> atomic64_t is never defined, but it is used there and on other places.

I'll take a look at this; I've been focusing primarily on the tilegx
architecture recently and something may have bitrotted in the tilepro
support.  Thanks for the pointer.

> Also, while the edac_tile driver seems to be for both Tile GX and Tilepro
> sub-archs, it is not included on tilegx_defconfig. It would make sense
> to add it there, in order to make easier for people to test/use the
> EDAC drivers.

That's probably a good idea; we do enable it by default in our actual
shipping configuration.  I've heard mixed things about the utility of
including "config" files in the kernel, so I haven't been bothering to
update them, but it's probably worth a refresh at this point.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

