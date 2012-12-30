Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754420Ab2L3EJn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Dec 2012 23:09:43 -0500
Received: from mail-ie0-f177.google.com ([209.85.223.177]:52649 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754249Ab2L3EJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Dec 2012 23:09:41 -0500
MIME-Version: 1.0
X-Originating-IP: [72.80.83.148]
In-Reply-To: <50D02C89.9030307@huawei.com>
References: <50B47C31.2040709@huawei.com>
	<50D02C89.9030307@huawei.com>
Date: Sat, 29 Dec 2012 23:09:38 -0500
Message-ID: <CANM98qK4VighSAw5eZUuR20qCzbynR4rnR0ZTicp1VdUkRRjqg@mail.gmail.com>
Subject: Re: [PATCH RESEND 4] ARM: plat-versatile: move secondary CPU startup
 into cpuinit
From: Christoffer Dall <c.dall@virtualopensystems.com>
To: Claudio Fontana <Claudio.Fontana@huawei.com>
Cc: Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 3:42 AM, Claudio Fontana
<Claudio.Fontana@huawei.com> wrote:
>
> Using __CPUINIT instead of __INIT puts the secondary CPU startup code
> into the "right" section: it will not be freed in hotplug configurations,
> allowing hot-add of cpus, while still getting freed in non-hotplug configs.
>
> Tested successfully on Fast-Models and on Arndale for VCPU hotplug.

not quite sure how testing on Arndale verifies this change?

>
> Signed-off-by: Claudio Fontana <claudio.fontana@huawei.com>
> Tested-by: Claudio Fontana <claudio.fontana@huawei.com>
>
> diff --git a/arch/arm/plat-versatile/headsmp.S b/arch/arm/plat-versatile/headsmp.S
> index dd703ef..19fe180 100644
> --- a/arch/arm/plat-versatile/headsmp.S
> +++ b/arch/arm/plat-versatile/headsmp.S
> @@ -11,7 +11,7 @@
>  #include <linux/linkage.h>
>  #include <linux/init.h>
>
> -       __INIT
> +       __CPUINIT
>
>  /*
>   * Realview/Versatile Express specific entry point for secondary CPUs.
> --
> 1.7.12.1
>

Otherwise looks ok to me (not guaranteeing that cpu hotplug will
magically work for KVM using this change though).

-Christoffer
