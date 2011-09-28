Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab1I1Vma (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Sep 2011 17:42:30 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51761 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751165Ab1I1Vm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Sep 2011 17:42:29 -0400
Date: Wed, 28 Sep 2011 23:42:27 +0200
From: Michal Marek <mmarek@suse.cz>
To: Arnaud Lacombe <lacombar@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Kbuild: allow code re-use across different directories
Message-ID: <20110928214227.GA17628@sepie.suse.cz>
References: <1315974254-17345-1-git-send-email-lacombar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315974254-17345-1-git-send-email-lacombar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 14, 2011 at 12:24:14AM -0400, Arnaud Lacombe wrote:
> Modify Kbuild to allow direct code re-use in multiple directory
> without having to go through a copy. Technically, Kbuild would use by
> default the VPATH feature

I now found that the patch breaks headers_install and firmware_install
when using O=

$ mkdir build
$ make O=build defconfig
...
$ make O=build headers_install
  CHK     include/linux/version.h
  UPD     include/linux/version.h
  HOSTCC  scripts/unifdef
make[3]: *** No rule to make target `scripts/headers_install.pl', needed by `/labs/mmarek/linux-2.6/build/usr/include/asm-generic/.install'.  Stop.
make[2]: *** [asm-generic] Error 2
make[1]: *** [headers_install] Error 2
make: *** [sub-make] Error 2
$ make O=build firmware_install
  GEN     /labs/mmarek/linux-2.6/build/Makefile
scripts/kconfig/conf --silentoldconfig Kconfig
make[2]: *** No rule to make target `firmware/e100/d101m_ucode.bin', needed by `/lib/firmware/e100/d101m_ucode.bin'.  Stop.
make[1]: *** [firmware_install] Error 2
make: *** [sub-make] Error 2

Michal
