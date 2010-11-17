Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759387Ab0KQAQh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Nov 2010 19:16:37 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:62134 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757418Ab0KQAQf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Nov 2010 19:16:35 -0500
MIME-Version: 1.0
In-Reply-To: <348d48851a244bbd60bbfc4d60bee330e5c91eae.1289943240.git.dirk.brandewie@gmail.com>
References: <cover.1289943240.git.dirk.brandewie@gmail.com> <348d48851a244bbd60bbfc4d60bee330e5c91eae.1289943240.git.dirk.brandewie@gmail.com>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Tue, 16 Nov 2010 17:16:14 -0700
X-Google-Sender-Auth: FzU7X2inNbEMkR0p9G_9IbY36TM
Message-ID: <AANLkTik2TP_DUWstn_qmq1oz4HaPHqkoGkN5f1oUiHQa@mail.gmail.com>
Subject: Re: [PATCH 2/5] of/fdt: add kernel command line option for dtb_compat string
To: dirk.brandewie@gmail.com
Cc: devicetree-discuss@lists.ozlabs.org, linux-arch@vger.kernel.org,
        linux-kbuild@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, sodaville@linutronix.de,
        microblaze-uclinux@itee.uq.edu.au, arjan@linux.intel.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 16, 2010 at 3:41 PM,  <dirk.brandewie@gmail.com> wrote:
> From: Dirk Brandewie <dirk.brandewie@gmail.com>
>
> Adds a kernel command line option "dtb_compat=<string>" and functions
> for architecture/platform specific code to retrieve the command line
> string and locate the compatible DTB linked into the kernel
>
> of_flat_dt_get_dtb_compatible_string() returns a pointer string passed
> from the command line or a pointer to an empty string.
>
> of_flat_dt_find_compatible_dtb() returns a pointer to a DTB that is
> compatible with the "compatible" string or a NULL pointer if no
> matching DTB is present.
>
> Signed-off-by: Dirk Brandewie <dirk.brandewie@gmail.com>
> ---
[...]
> +void __init *of_flat_dt_find_compatible_dtb(char *name)
> +{
> +       void *rc = NULL;
> +       unsigned long root, size;
> +       struct boot_param_header  *orig_initial_boot_params;
> +       uint8_t *blob;
> +
> +       orig_initial_boot_params = initial_boot_params;
> +       blob = __dtb_start;
> +       initial_boot_params = (struct boot_param_header *)blob;
> +
> +       while (blob < __dtb_end &&
> +               (be32_to_cpu(initial_boot_params->magic) == OF_DT_HEADER)) {

The kernel needs to complain *loudly* if this occurs because it
represents a bug.  I'm tempted to say use BUG, but that would halt the
kernel and prevent any possibility of kernel log output.  WARN_ON() is
probably best.

g.
