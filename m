Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756138Ab2FJO4u (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 10:56:50 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:63952 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751780Ab2FJO4t convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 10:56:49 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.19.137]
In-Reply-To: <1338989907-25360-5-git-send-email-sjur.brandeland@stericsson.com>
References: <1338989907-25360-1-git-send-email-sjur.brandeland@stericsson.com> <1338989907-25360-5-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 10 Jun 2012 17:56:28 +0300
Message-ID: <CAK=Wgbb1-uNutj5ZExVpx7u1M6bKvfGokoOg2UQJQi4h9ODJRw@mail.gmail.com>
Subject: Re: [PATCH 4/7] remoteproc: Assign boot_addr in a separate function
To: sjur.brandeland@stericsson.com
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 4:38 PM,  <sjur.brandeland@stericsson.com> wrote:
> +/**
> + * rproc_set_boot_addr() - Set rproc's boot address.
> + * @rproc: remote processor which needs boot address set.
> + * @fw: the  the ELF firmware image

typo: s/the the/the/

> -       rproc->bootaddr = ehdr->e_entry;
> +       rproc_set_boot_addr(rproc, fw);

We might want to do this a little bit differently, something like:

rproc->bootaddr = rproc_get_boot_addr(rproc, fw);

This way the binary-format-specific handler really only retrieves the
boot address, without manipulating the framework's rproc structure.

If such handler doesn't exist, a default zero can be returned.

Thanks,
Ohad.
