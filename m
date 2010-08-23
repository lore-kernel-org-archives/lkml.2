Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751976Ab0HWLdX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 07:33:23 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:39561 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541Ab0HWLdW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 07:33:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mime-version:content-type
         :content-disposition:user-agent;
        b=HjdVSkRRJXstC9KtDRncWvyUJ7D7ohSFnPdPKEKomGA/sRPlPvovA4jpg7zUKEBJ38
         E0TdLAoluAEWlHHkGktx+QbXc0CuqmyIBo7p7rlxk2GZDzKTwt6faXeyZzP1Qr1QVklH
         /Nbil/jUpSP4F3evQHe7zFy/O0Cli/QDtXO3E=
Date: Mon, 23 Aug 2010 13:32:48 +0200
From: "Carlos R. Mafra" <crmafra2@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: Jesse Barnes <jbarnes@virtuousgeek.org>
Subject: 2.6.36-rc2 drm compilation failure
Message-ID: <20100823113248.GA18594@Pilar.aei.mpg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The compilation of 2.6.36-rc2 fails with the following error

  LD      .tmp_vmlinux1
drivers/built-in.o: In function `vga_get_uninterruptible':
/home/mafra/linux-2.6/include/linux/vgaarb.h:120: undefined reference to `vga_get'
drivers/built-in.o: In function `i915_disable_vga':
/home/mafra/linux-2.6/drivers/gpu/drm/i915/intel_display.c:5990: undefined reference to `vga_put'
make[1]: *** [.tmp_vmlinux1] Fehler 1
make: *** [sub-make] Fehler 2

but 2.6.36-rc1 compiled fine. 

The machine is a Vaio 64-bit laptop with

VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller

and my .config has

CONFIG_DRM_I915=y
CONFIG_DRM_I915_KMS=y

but also

# CONFIG_VGA_ARB is not set

I guess the following commit introduced the error 9cce37f4855a30cc 
("drm/i915: fix VGA plane disable for Ironlake+").

If there's any other information I should provide, please let me know.
