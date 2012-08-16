Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756781Ab2HPS0k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Aug 2012 14:26:40 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:50195 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751298Ab2HPS0i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Aug 2012 14:26:38 -0400
MIME-Version: 1.0
In-Reply-To: <ec8635c36005ba5ea3784276214fb905720ee3ec.1345055639.git.dmitry.kasatkin@intel.com>
References: <cover.1345055638.git.dmitry.kasatkin@intel.com>
	<ec8635c36005ba5ea3784276214fb905720ee3ec.1345055639.git.dmitry.kasatkin@intel.com>
Date: Thu, 16 Aug 2012 14:26:37 -0400
Message-ID: <CA+5PVA71WegBSBbgZDBZopORkAMN9G8i2MXHmAGdpiSjWzo9RQ@mail.gmail.com>
Subject: Re: [RFC v2 2/7] keys: initialize root uid and session keyrings early
From: Josh Boyer <jwboyer@gmail.com>
To: Dmitry Kasatkin <dmitry.kasatkin@intel.com>
Cc: zohar@linux.vnet.ibm.com, jmorris@namei.org, rusty@rustcorp.com.au,
        dhowells@redhat.com, linux-security-module@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 15, 2012 at 2:43 PM, Dmitry Kasatkin
<dmitry.kasatkin@intel.com> wrote:
> From: Mimi Zohar <zohar@linux.vnet.ibm.com>
>
> In order to create the integrity keyrings (eg. _evm, _ima, _modules),
> root's uid and session keyrings need to be initialized early.
>
> Signed-off-by: Mimi Zohar <zohar@us.ibm.com>
> ---
>  security/keys/Makefile       |    1 +
>  security/keys/root_keyring.c |   18 ++++++++++++++++++
>  2 files changed, 19 insertions(+)
>  create mode 100644 security/keys/root_keyring.c
>
> diff --git a/security/keys/Makefile b/security/keys/Makefile
> index 504aaa0..c93ce8d 100644
> --- a/security/keys/Makefile
> +++ b/security/keys/Makefile
> @@ -18,6 +18,7 @@ obj-y := \
>  obj-$(CONFIG_KEYS_COMPAT) += compat.o
>  obj-$(CONFIG_PROC_FS) += proc.o
>  obj-$(CONFIG_SYSCTL) += sysctl.o
> +obj-$(CONFIG_INTEGRITY_SIGNATURE) += root_keyring.o
>
>  #
>  # Key types
> diff --git a/security/keys/root_keyring.c b/security/keys/root_keyring.c
> new file mode 100644
> index 0000000..f6662eb
> --- /dev/null
> +++ b/security/keys/root_keyring.c
> @@ -0,0 +1,18 @@
> +/*
> + * Copyright (C) 2012 IBM Corporation
> + *
> + * Author:
> + * Mimi Zohar <zohar@us.ibm.com>
> + *
> + * This program is free software; you can redistribute it and/or modify
> + * it under the terms of the GNU General Public License as published by
> + * the Free Software Foundation, version 2 of the License.
> + */
> +
> +#include "internal.h"
> +static int __init init_root_keyring(void)
> +{
> +       return install_user_keyrings();
> +}
> +
> +late_initcall(init_root_keyring);
> --

Why is this in an entirely new file instead of just being added to
process_keys.c ?

josh
