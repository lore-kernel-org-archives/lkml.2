Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752000Ab2FCMzC (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 08:55:02 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:62709 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750952Ab2FCMzA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 08:55:00 -0400
MIME-Version: 1.0
X-Originating-IP: [85.250.83.253]
In-Reply-To: <1337693217-15466-3-git-send-email-sjur.brandeland@stericsson.com>
References: <1337693217-15466-1-git-send-email-sjur.brandeland@stericsson.com> <1337693217-15466-3-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 3 Jun 2012 15:54:39 +0300
Message-ID: <CAK=WgbafpAC+DZ71Oon_PyiWGAryAxzZvttpeiFY+A_agYcMFw@mail.gmail.com>
Subject: Re: [RFC 2/6] remoteproc: Pass struct fw to load_segments and find_rsc_table.
To: sjur.brandeland@stericsson.com
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 4:26 PM,  <sjur.brandeland@stericsson.com> wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> Use struct firmware as arguments to functions rproc_find_rcs_table()
> and rproc_load_segments().

I'll keep reading through the patches to get the big picture, but in
general, it's best just to provide the incentive behind every change
in the commit log.

> +rproc_find_rsc_table(struct rproc *rproc, const struct firmware *fw,
>                                                        int *tablesz)
>  {
...
> +       /*
> +        * The ELF entry point is the rproc's boot addr (though this is not
> +        * a configurable property of all remote processors: some will always
> +        * boot at a specific hardcoded address).
> +        */
> +       rproc->bootaddr = ehdr->e_entry;
> +
...
> @@ -1032,15 +1039,8 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
> -       /*
> -        * The ELF entry point is the rproc's boot addr (though this is not
> -        * a configurable property of all remote processors: some will always
> -        * boot at a specific hardcoded address).
> -        */
> -       rproc->bootaddr = ehdr->e_entry;

Is this change related?

Thanks,
Ohad.
