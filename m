Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753252Ab1LHWGZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 17:06:25 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:58156 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845Ab1LHWGX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 17:06:23 -0500
MIME-Version: 1.0
In-Reply-To: <1323133549-13590-2-git-send-email-hpa@linux.intel.com>
References: <1323133549-13590-1-git-send-email-hpa@linux.intel.com>
	<1323133549-13590-2-git-send-email-hpa@linux.intel.com>
Date: Thu, 8 Dec 2011 23:06:22 +0100
Message-ID: <CAFLxGvxuP64FzhKcL5bL2vv=sfQ0ZB2U_xXd4MkAF006RJfZrA@mail.gmail.com>
Subject: Re: [PATCH 1/3] um: Run host archheaders, allow use of host generated headers
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: "H. Peter Anvin" <hpa@linux.intel.com>
Cc: Jeff Dike <jdike@addtoit.com>, Richard Weinberger <richard@nod.at>,
        Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        user-mode-linux-devel@lists.sourceforge.net,
        linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 6, 2011 at 2:05 AM, H. Peter Anvin <hpa@linux.intel.com> wrote:
> From: "H. Peter Anvin" <hpa@linux.intel.com>
>
> Run the "archheaders" target for the host architecture, for
> architectures (like x86, now) that want to generate some of the
> necessary header files.
>
> Add $(HOST_DIR)/include/generated to the include path so we then pick
> them up.
>
> Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
> ---
>  arch/um/Makefile |    7 ++++++-
>  1 files changed, 6 insertions(+), 1 deletions(-)
>
> diff --git a/arch/um/Makefile b/arch/um/Makefile
> index 7730af6..00210e9 100644
> --- a/arch/um/Makefile
> +++ b/arch/um/Makefile
> @@ -64,7 +64,8 @@ USER_CFLAGS = $(patsubst $(KERNEL_DEFINES),,$(patsubst -D__KERNEL__,,\
>  #This will adjust *FLAGS accordingly to the platform.
>  include $(srctree)/$(ARCH_DIR)/Makefile-os-$(OS)
>
> -KBUILD_CPPFLAGS += -I$(srctree)/$(HOST_DIR)/include
> +KBUILD_CPPFLAGS += -I$(srctree)/$(HOST_DIR)/include \
> +                  -I$(HOST_DIR)/include/generated
>
>  # -Derrno=kernel_errno - This turns all kernel references to errno into
>  # kernel_errno to separate them from the libc errno.  This allows -fno-common
> @@ -96,6 +97,10 @@ endef
>
>  KBUILD_KCONFIG := $(HOST_DIR)/um/Kconfig
>
> +archheaders:
> +       $(Q)$(MAKE) -C '$(KBUILD_SRC)' KBUILD_SRC= \
> +               ARCH=$(SUBARCH) O='$(objtree)' archheaders
> +

This does not work, KBUILD_SRC is empty.
I'm not a kbuild expert, but I think the usage of KBUILD_SRC is in general
not allowed.

-- 
Thanks,
//richard
