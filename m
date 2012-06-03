Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab2FCNmc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jun 2012 09:42:32 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:53772 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887Ab2FCNmb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jun 2012 09:42:31 -0400
MIME-Version: 1.0
X-Originating-IP: [85.250.83.253]
In-Reply-To: <1337693217-15466-4-git-send-email-sjur.brandeland@stericsson.com>
References: <1337693217-15466-1-git-send-email-sjur.brandeland@stericsson.com> <1337693217-15466-4-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sun, 3 Jun 2012 16:42:10 +0300
Message-ID: <CAK=Wgbbdjf_SnbxQJd04nPSFBbHQQwO5zP_gW_jTiJyj_rn63g@mail.gmail.com>
Subject: Re: [RFC 3/6] remoteproc: Move fw sanity check to find_rsc_table.
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
> Prepare for pluggable firmware handling by calling firmware
> sanity check from function find_rsc_table.

Can we keep the present location of rproc_fw_sanity_check(), and later
just invoke the relevant ops handler instead?

> @@ -1041,8 +1041,10 @@ static int rproc_fw_boot(struct rproc *rproc, const struct firmware *fw)
>
>        /* look for the resource table */
>        table = rproc_find_rsc_table(rproc, fw, &tablesz);
> -       if (!table)
> +       if (!table) {
> +               ret = -EINVAL;

This looks like an unrelated error-path fix which we might want to
merge regardless of this work.

Thanks,
Ohad.
