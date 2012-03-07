Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031721Ab2CGAw0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 19:52:26 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:48151 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932701Ab2CGAwY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 19:52:24 -0500
MIME-Version: 1.0
In-Reply-To: <1331080238-1524-2-git-send-email-swarren@wwwdotorg.org>
References: <1331080238-1524-1-git-send-email-swarren@wwwdotorg.org> <1331080238-1524-2-git-send-email-swarren@wwwdotorg.org>
From: Julian Calaby <julian.calaby@gmail.com>
Date: Wed, 7 Mar 2012 11:52:03 +1100
Message-ID: <CAGRGNgWHXrQgVobz+54sFBzj=bTHCKwg+H4_CY5JoGtmETw2yA@mail.gmail.com>
Subject: Re: [PATCH 2/3] Kbuild: Implement CONFIG_UIMAGE_KERNEL_NOLOAD
To: Stephen Warren <swarren@wwwdotorg.org>
Cc: Michal Marek <mmarek@suse.cz>, Russell King <linux@arm.linux.org.uk>,
        nico@fluxnic.net, Haavard Skinnemoen <hskinnemoen@gmail.com>,
        Hans-Christian Egtvedt <egtvedt@samfundet.no>,
        Mike Frysinger <vapier@gentoo.org>, Michal Simek <monstr@monstr.eu>,
        Paul Mundt <lethal@linux-sh.org>,
        "David S. Miller" <davem@davemloft.net>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-kernel@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        uclinux-dist-devel@blackfin.uclinux.org,
        microblaze-uclinux@itee.uq.edu.au, linux-sh@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-arch@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Stephen,

On Wed, Mar 7, 2012 at 11:30, Stephen Warren <swarren@wwwdotorg.org> wrote:
> This allows the user to use U-Boot's mkimage's -T kernel_noload option
> if their arch Kconfig allows it, and they desire.
>
> Signed-off-by: Stephen Warren <swarren@wwwdotorg.org>
> ---
> diff --git a/init/Kconfig b/init/Kconfig
> index 6cfd71d..2035562 100644
> --- a/init/Kconfig
> +++ b/init/Kconfig
> @@ -203,6 +203,21 @@ config KERNEL_LZO
>
>  endchoice
>
> +config ALLOW_UIMAGE_KERNEL_NOLOAD
> +       bool
> +
> +config UIMAGE_KERNEL_NOLOAD
> +       bool "Use mkimage's -T kernel_noload instead of -T kernel"
> +       depends on ALLOW_UIMAGE_KERNEL_NOLOAD
> +       help
> +         uImage files of type "kernel" embed an absolute load and entry point
> +         address. If the uImage is loaded to a different address, then the
> +         image must be copied the uImage file to the specified load address.

You seem to have an excess "the uImage file" in here.

> +         This copy is a waste of time if the uImage is in fact completely
> +         relocatable. If your kernel and bootloader support it, you can build
> +         a "kernel_noload" uImage rather than a "kernel" uImage, which
> +         prevents any such copying. If unsure say N.
> +
>  config DEFAULT_HOSTNAME
>        string "Default hostname"
>        default "(none)"

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
.Plan: http://sites.google.com/site/juliancalaby/
