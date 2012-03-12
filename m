Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab2CLPAU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Mar 2012 11:00:20 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63181 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753116Ab2CLPAS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Mar 2012 11:00:18 -0400
Message-ID: <4F5E0F78.3000308@redhat.com>
Date: Mon, 12 Mar 2012 12:00:08 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.1) Gecko/20120216 Thunderbird/10.0.1
MIME-Version: 1.0
To: Chris Metcalf <cmetcalf@tilera.com>
CC: torvalds@linux-foundation.org,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable@kernel.org
Subject: Re: [PATCH] tile: remove a non-existing header
References: <1331561930-14964-1-git-send-email-mchehab@redhat.com> <4F5E08C7.9070400@tilera.com>
In-Reply-To: <4F5E08C7.9070400@tilera.com>
X-Enigmail-Version: 1.3.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em 12-03-2012 11:31, Chris Metcalf escreveu:
> On 3/12/2012 10:18 AM, Mauro Carvalho Chehab wrote:
>> While testing some API changes at the EDAC core, I've tested the EDAC
>> drivers compilation on all supported architectures, including Tilera.
>>
>> I noticed that Tilera upstream code has issues: it doesn't compile with
>> kernel 3.2:
>>
>> In file included from include/linux/linkage.h:5,
>>                  from include/linux/kernel.h:13,
>>                  from include/linux/sched.h:55,
>>                  from arch/tile/kernel/asm-offsets.c:19:
>> /home/mchehab/redhat/trees/work/new_edac/arch/tile/include/asm/linkage.h:18:22: error: feedback.h: No such file or directory
>> make[1]: *** [arch/tile/kernel/asm-offsets.s] Error 1
>>
>> Without it, it is not possible to compile anything on this archictecture
>> using this default configuration:
>> 	./arch/tile/configs/tilegx_defconfig
>>
>> Cc: stable@kernel.org
>> Signed-of-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> Thank you, but nack.  The header is provided in the latest gcc tip code. 

Hmm... the gcc cross-compiler I've downloaded from Tilera site about one month
ago didn't have it (tilegx-unknown-linux-gnu-gcc (GCC) 4.4.6).

> Sorry for the API thrash!  It's certainly OK to comment it out for the time
> being; it just provides some assembly macros for specifying feedback-guided
> optimization.

It would be a good idea then to add some Makefile magic to check it,
maybe creating an empty linkage.h if the header is not found at the gcc
toolchain, in order to support all gcc variants that support tile arch.

>> Btw, the ./arch/tile/configs/tilepro_defconfig doesn't compile even
>> with this fix. It fails at arch/tile/include/asm/atomic_64.h because
>> atomic64_t is never defined, but it is used there and on other places.
> 
> I'll take a look at this; I've been focusing primarily on the tilegx
> architecture recently and something may have bitrotted in the tilepro
> support.  Thanks for the pointer.

Anytime.

>> Also, while the edac_tile driver seems to be for both Tile GX and Tilepro
>> sub-archs, it is not included on tilegx_defconfig. It would make sense
>> to add it there, in order to make easier for people to test/use the
>> EDAC drivers.
> 
> That's probably a good idea; we do enable it by default in our actual
> shipping configuration.  I've heard mixed things about the utility of
> including "config" files in the kernel, so I haven't been bothering to
> update them, but it's probably worth a refresh at this point.

Yeah, there are lots of discussion about keeping/removing the config 
files in kernel ;)

I wouldn't be using any of those, if a "make allyesconfig" would 
enable all EDAC drivers for the non-Intel archs, but it didn't work 
like that.

As it didn't enabled, the config files there helped me a lot to test 
compilation for the tile_edac driver, and for some other ppc EDAC 
drivers for embedded platforms. The dependency chain to enable 
those drivers is not trivial, so, trying to enable them by hand 
is a time-consuming task.

Regards,
Mauro
