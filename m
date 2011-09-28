Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754911Ab1I1WUM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 18:20:12 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:50832 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752155Ab1I1WUL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 18:20:11 -0400
MIME-Version: 1.0
In-Reply-To: <20110928214227.GA17628@sepie.suse.cz>
References: <1315974254-17345-1-git-send-email-lacombar@gmail.com>
	<20110928214227.GA17628@sepie.suse.cz>
Date: Wed, 28 Sep 2011 18:20:09 -0400
Message-ID: <CACqU3MX2QJV51P67iUZ4EgDFSamXYgniFSHHQdG9J-BDgNz6Gg@mail.gmail.com>
Subject: Re: [PATCH] Kbuild: allow code re-use across different directories
From: Arnaud Lacombe <lacombar@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 28, 2011 at 5:42 PM, Michal Marek <mmarek@suse.cz> wrote:
> On Wed, Sep 14, 2011 at 12:24:14AM -0400, Arnaud Lacombe wrote:
>> Modify Kbuild to allow direct code re-use in multiple directory
>> without having to go through a copy. Technically, Kbuild would use by
>> default the VPATH feature
>
> I now found that the patch breaks headers_install and firmware_install
> when using O=
>
d'oh, I knew I forgot something! I'll have a look later on.

Thanks,
 - Arnaud

> $ mkdir build
> $ make O=build defconfig
> ...
> $ make O=build headers_install
>  CHK     include/linux/version.h
>  UPD     include/linux/version.h
>  HOSTCC  scripts/unifdef
> make[3]: *** No rule to make target `scripts/headers_install.pl', needed by `/labs/mmarek/linux-2.6/build/usr/include/asm-generic/.install'.  Stop.
> make[2]: *** [asm-generic] Error 2
> make[1]: *** [headers_install] Error 2
> make: *** [sub-make] Error 2
> $ make O=build firmware_install
>  GEN     /labs/mmarek/linux-2.6/build/Makefile
> scripts/kconfig/conf --silentoldconfig Kconfig
> make[2]: *** No rule to make target `firmware/e100/d101m_ucode.bin', needed by `/lib/firmware/e100/d101m_ucode.bin'.  Stop.
> make[1]: *** [firmware_install] Error 2
> make: *** [sub-make] Error 2
>
> Michal
>
