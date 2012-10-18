Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757196Ab2JRSS5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 14:18:57 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:60407 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753613Ab2JRSSz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 14:18:55 -0400
MIME-Version: 1.0
In-Reply-To: <1343340000-7587-1-git-send-email-mjg@redhat.com>
References: <1343340000-7587-1-git-send-email-mjg@redhat.com>
Date: Thu, 18 Oct 2012 20:18:51 +0200
Message-ID: <CAA7rmPGL827cgT6hM8h_xhokEbTbTnrptoRekVByM7AcMdRUdw@mail.gmail.com>
Subject: Re: [PATCH] efi: Build EFI stub with EFI-appropriate options
From: Daniel Vacek <neelx.g@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: matt.fleming@intel.com, linux-efi@vger.kernel.org,
        linux-kernel@vger.kernel.org, x86@kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 27, 2012 at 12:00 AM, Matthew Garrett <mjg@redhat.com> wrote:
> We can't assume the presence of the red zone while we're still in a boot
> services environment, so we should build with -fno-red-zone to avoid
> problems. Change the size of wchar at the same time to make string handling
> simpler.
>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> ---
>  arch/x86/boot/compressed/Makefile |    3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
> index e398bb5..8a84501 100644
> --- a/arch/x86/boot/compressed/Makefile
> +++ b/arch/x86/boot/compressed/Makefile
> @@ -28,6 +28,9 @@ VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
>         $(obj)/string.o $(obj)/cmdline.o $(obj)/early_serial_console.o \
>         $(obj)/piggy.o
>
> +$(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
> +$(obj)/efi_stub_$(BITS).o: KBUILD_CLFAGS += -fshort-wchar -mno-red-zone
> +
>  ifeq ($(CONFIG_EFI_STUB), y)
>         VMLINUX_OBJS += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o
>  endif

s/CLFAGS/CFLAGS/

should go to stable too?

--nX
