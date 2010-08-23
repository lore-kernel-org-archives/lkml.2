Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754168Ab0HWPsn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 11:48:43 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:48375 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752836Ab0HWPsk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 11:48:40 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=QdWFWRBrc1S5NZguUIBqRiVLytDyR5nlGUy/DoEZQMOzDJjz7Kn8oVeSfiNFRFAhVuIY9F9Arn4zfdRp+A+51u786/bBw9EOneTkJgngbB0c8kgratLhzbhOJYIgFymj;
Date: Mon, 23 Aug 2010 08:48:37 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: "Carlos R. Mafra" <crmafra2@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.36-rc2 drm compilation failure
Message-ID: <20100823084837.2f181fdd@virtuousgeek.org>
In-Reply-To: <20100823113248.GA18594@Pilar.aei.mpg.de>
References: <20100823113248.GA18594@Pilar.aei.mpg.de>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 23 Aug 2010 13:32:48 +0200
"Carlos R. Mafra" <crmafra2@gmail.com> wrote:

> The compilation of 2.6.36-rc2 fails with the following error
> 
>   LD      .tmp_vmlinux1
> drivers/built-in.o: In function `vga_get_uninterruptible':
> /home/mafra/linux-2.6/include/linux/vgaarb.h:120: undefined reference to `vga_get'
> drivers/built-in.o: In function `i915_disable_vga':
> /home/mafra/linux-2.6/drivers/gpu/drm/i915/intel_display.c:5990: undefined reference to `vga_put'
> make[1]: *** [.tmp_vmlinux1] Fehler 1
> make: *** [sub-make] Fehler 2
> 
> but 2.6.36-rc1 compiled fine. 
> 
> The machine is a Vaio 64-bit laptop with
> 
> VGA compatible controller: Intel Corporation Mobile GM965/GL960 Integrated Graphics Controller
> 
> and my .config has
> 
> CONFIG_DRM_I915=y
> CONFIG_DRM_I915_KMS=y
> 
> but also
> 
> # CONFIG_VGA_ARB is not set
> 
> I guess the following commit introduced the error 9cce37f4855a30cc 
> ("drm/i915: fix VGA plane disable for Ironlake+").
> 
> If there's any other information I should provide, please let me know.

Ah so we need to select VGA arb or make sure stubs are provided
for !VGA_ARB configs.

-- 
Jesse Barnes, Intel Open Source Technology Center
