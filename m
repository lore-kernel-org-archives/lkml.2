Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755411Ab2DTLNU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Apr 2012 07:13:20 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45795 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755118Ab2DTLNT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Apr 2012 07:13:19 -0400
MIME-Version: 1.0
In-Reply-To: <1334607965-9582-4-git-send-email-mjg@redhat.com>
References: <1334607965-9582-1-git-send-email-mjg@redhat.com>
	<1334607965-9582-4-git-send-email-mjg@redhat.com>
Date: Fri, 20 Apr 2012 12:13:19 +0100
Message-ID: <CAPM=9tz2Nxm8s-oDeCME2F1PmgLOAGFp7Y-8+oyMUoEn0eAeVQ@mail.gmail.com>
Subject: Re: [PATCH V2 4/4] efifb: Implement vga_default_device()
From: Dave Airlie <airlied@gmail.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, matt.fleming@intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 16, 2012 at 9:26 PM, Matthew Garrett <mjg@redhat.com> wrote:
> EFI doesn't typically make use of the legacy VGA ROM, but it may still be
> configured to pass that through to a given video device. This may lead to
> an inaccurate choice of default video device. Add support to efifb to pick
> out the correct active video device.
>
> Signed-off-by: Matthew Garrett <mjg@redhat.com>
> Cc: hpa@zytor.com
> Cc: matt.fleming@intel.com
> ---
>  arch/x86/include/asm/vga.h |    6 ++++
>  drivers/video/efifb.c      |   77 ++++++++++++++++++++++++++++++++------------
>  2 files changed, 63 insertions(+), 20 deletions(-)
>
> diff --git a/arch/x86/include/asm/vga.h b/arch/x86/include/asm/vga.h
> index c4b9dc2..2723c07 100644
> --- a/arch/x86/include/asm/vga.h
> +++ b/arch/x86/include/asm/vga.h
> @@ -17,4 +17,10 @@
>  #define vga_readb(x) (*(x))
>  #define vga_writeb(x, y) (*(y) = (x))
>
> +#if CONFIG_FB_EFI

^ #ifdef?

Dave.
