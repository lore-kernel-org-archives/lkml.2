Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759625Ab2ESOEK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 May 2012 10:04:10 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:40475 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753969Ab2ESOEI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 May 2012 10:04:08 -0400
Message-ID: <4FB7A856.4090803@tilera.com>
Date: Sat, 19 May 2012 10:04:06 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Paul Gortmaker <paul.gortmaker@windriver.com>
CC: <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tile: set KBUILD_DEFCONFIG to point at a real config
 file
References: <1337381165-7376-1-git-send-email-paul.gortmaker@windriver.com> <4FB6F28F.3090404@tilera.com> <20120519031806.GA24697@windriver.com>
In-Reply-To: <20120519031806.GA24697@windriver.com>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/18/2012 11:18 PM, Paul Gortmaker wrote:
> [Re: [PATCH] tile: set KBUILD_DEFCONFIG to point at a real config file] On 18/05/2012 (Fri 21:08) Chris Metcalf wrote:
>
>> On 5/18/2012 6:46 PM, Paul Gortmaker wrote:
>>> To fix this:
>>>
>>> ~/git/linux-head$ make defconfig
>>> *** Default configuration is based on 'tile_defconfig'
>>> ***
>>> *** Can't find default configuration "arch/tile/configs/tile_defconfig"!
>>> ***
>>> make[1]: *** [defconfig] Error 1
>>> make: *** [defconfig] Error 2
>>>
>>> There is no need to use $ARCH in the tile/Makefile, since if we are
>>> in there, we know ARCH must be tile.  Use the GX as the defconfig,
>>> as that is what is used in linux-next.
>> No, the odd thing about arch/tile is that you must build it either as
>> ARCH=tilepro or ARCH=tilegx.  There is no ARCH=tile.  So the $ARCH piece is
>> actually correct.
> That is interesting, since this is what I've been doing on any of my
> tile builds right from the beginning.
>
> PATH=/home/paul/tc/tilegx-x86_64/bin:$PATH
> export CROSS_COMPILE=tilegx-unknown-linux-gnu-
> export ARCH=tile
>
> ...and it works.  Aside from the defconfig thing I just reported.
> It is the same boilerplate type of env. settings I use for arm, mips
> and whatever other random thing I'm building.  I'm pretty sure I'm
> not the only one who would make this assumption.  Actually I *know*
> I am not the only one.  Here is a snippet from linux-next build:
>
> /scratch/kisskb/prod/kisskb/kisskb3/backend/makewrap.py ARCH=tile
> O=/scratch/kisskb/prod/kisskb/kisskb3/backend/build/linux-next_tilegx_defconfig_tilegx
> CROSS_COMPILE=/opt/cross/gcc-4.6.2-nolibc/tilegx-linux/bin/tilegx-linux-
> tilegx_defconfig
>
> So maybe some validation on the ARCH value is in order if you really
> don't want people doing this?

Yes.  I think what I will do is "promote" ARCH=tile to ARCH=tilegx in
arch/tile/Makefile as the "default" Tilera architecture.  Thanks for the
suggestion - I've been too close to this issue to actually notice it :-)

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

