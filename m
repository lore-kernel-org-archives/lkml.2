Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab2LIQfm (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 11:35:42 -0500
Received: from cantor2.suse.de ([195.135.220.15]:44324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751265Ab2LIQfl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 11:35:41 -0500
Message-ID: <50C4BDD9.6030806@suse.cz>
Date: Sun, 09 Dec 2012 17:35:37 +0100
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: pefoley2@verizon.net, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 3/5] add eboot.o and efi_stub_$(BITS).o to $(targets)
References: <1353269117-39917-1-git-send-email-pefoley2@verizon.net> <1353269117-39917-3-git-send-email-pefoley2@verizon.net>
In-Reply-To: <1353269117-39917-3-git-send-email-pefoley2@verizon.net>
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Added x86@kernel.org.

On 18.11.2012 21:05, pefoley2@verizon.net wrote:
> From: Peter Foley <pefoley2@verizon.net>
> 
> eboot.o and efi_stub_$(BITS).o are not in $(targets) so they are rebuilt
> every time make is invoked. Add them to $(targets) to prevent unnecessary
> rebuilding of bzImage.
> 
> Signed-off-by: Peter Foley <pefoley2@verizon.net>

Acked-by: Michal Marek <mmarek@suse.cz>

BTW, it might be a good idea to split the $(targets) assignment into
multiple lines.

Michal

> ---
>  arch/x86/boot/compressed/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
> index 8a84501..9d7a898 100644
> --- a/arch/x86/boot/compressed/Makefile
> +++ b/arch/x86/boot/compressed/Makefile
> @@ -4,7 +4,7 @@
>  # create a compressed vmlinux image from the original vmlinux
>  #
>  
> -targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.xz vmlinux.bin.lzo head_$(BITS).o misc.o string.o cmdline.o early_serial_console.o piggy.o
> +targets := vmlinux.lds vmlinux vmlinux.bin vmlinux.bin.gz vmlinux.bin.bz2 vmlinux.bin.lzma vmlinux.bin.xz vmlinux.bin.lzo head_$(BITS).o misc.o string.o cmdline.o early_serial_console.o piggy.o eboot.o efi_stub_$(BITS).o
>  
>  KBUILD_CFLAGS := -m$(BITS) -D__KERNEL__ $(LINUX_INCLUDE) -O2
>  KBUILD_CFLAGS += -fno-strict-aliasing -fPIC
> 

