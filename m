Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab2FKKHG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 06:07:06 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41540 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab2FKKHE convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 06:07:04 -0400
MIME-Version: 1.0
X-Originating-IP: [89.139.19.137]
In-Reply-To: <CAJK669a-O-Ee9ex4fiZ14Q18eJB_MM408yDnjNArtF_PN9aQ2A@mail.gmail.com>
References: <1338989907-25360-1-git-send-email-sjur.brandeland@stericsson.com>
 <1338989907-25360-8-git-send-email-sjur.brandeland@stericsson.com>
 <CAK=Wgba9_o+0f1X+wtj1CALhUBBA4-P+Disaf0i6UtNvCs_M=g@mail.gmail.com> <CAJK669a-O-Ee9ex4fiZ14Q18eJB_MM408yDnjNArtF_PN9aQ2A@mail.gmail.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Mon, 11 Jun 2012 13:06:43 +0300
Message-ID: <CAK=WgbbUYGmJFatc-UZ9jO_xziBkAsPn119PJHu-cE1iFiat3w@mail.gmail.com>
Subject: Re: [PATCH 7/7] remoteproc: Add custom STE-modem firmware loader.
To: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjur.brandeland@stericsson.com>
Cc: Loic PALLARDY <loic.pallardy@stericsson.com>,
        Ludovic BARRE <ludovic.barre@stericsson.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Sjur,

On Mon, Jun 11, 2012 at 12:55 PM, Sjur Brændeland
<sjur.brandeland@stericsson.com> wrote:
> How about this:
> In rproc_alloc, we set the rproc_elf_fw_ops as default
...
> Then the file remoteproc_elf_loader.c containing rproc_elf_fw_ops is
> default fw_ops
> and is contained remoteproc.ko.
>
> The ste_modem_fw_ops will be linked together with the ste_modem_rproc module,
> and none of the fw_ops needs to be exported as symbols globally.

All of the above sounds very good to me.

>, and we add a function:
>
> void rproc_set_fw_ops(struct rproc *rproc, const struct rproc_fw_ops *fw_ops)
> {
>        rproc->fw_ops = fw_ops;
> }
> EXPORT_SYMBOL(rproc_set_fw_ops);

I'm just not sure about this part.

If we're going to have the STE fw ops linked together with the STE
module (which sounds really good btw), can the STE module just
directly do

rproc->fw_ops = ste_modem_fw_ops;

before calling rproc_register() ?

This way we're not exposing any other symbol, and things look pretty
clean and simple.

Thanks,
Ohad.
