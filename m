Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755629Ab0FKWiX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 18:38:23 -0400
Received: from mail-px0-f174.google.com ([209.85.212.174]:64437 "EHLO
	mail-px0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752596Ab0FKWiW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 18:38:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=dSv7w0b9GsYLddXjxDI0tswKCmZkvS4LMcO+DuBIdlqjciIWiM44xMr9lPmPZKInAp
         Q2KaqHPzyVguOXClnWSoApKrM0bkXU1B2FFwwdBjEMvm9qgA2GxKL3PSRfAyNtCLyGLy
         ya1WhcZPnUsOAGLNGjU4wRgY23GvOJkE+K3s8=
MIME-Version: 1.0
In-Reply-To: <1275394887-26445-1-git-send-email-linus.walleij@stericsson.com>
References: <1275394887-26445-1-git-send-email-linus.walleij@stericsson.com>
Date: Fri, 11 Jun 2010 15:38:20 -0700
X-Google-Sender-Auth: LYCbG7L_Rl70kg23ID8QteL7H8I
Message-ID: <AANLkTil_NK2tuk4m6o8r4LIG0DsToC2O7jJ605nZMMtT@mail.gmail.com>
Subject: Re: [PATCH 08/18] DMAENGINE: ste_dma40: lock fix
From: Dan Williams <dan.j.williams@intel.com>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-kernel@vger.kernel.org, Jonas Aaberg <jonas.aberg@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 1, 2010 at 5:21 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:
> From: Jonas Aaberg <jonas.aberg@stericsson.com>
>
> Fix up some locking issues found by enabling lock debugging.
>
> Signed-off-by: Jonas Aaberg <jonas.aberg@stericsson.com>
> Signed-off-by: Linus Walleij <linus.walleij@stericsson.com>
> ---
>  drivers/dma/ste_dma40.c |   14 +++++++-------
>  1 files changed, 7 insertions(+), 7 deletions(-)
>
> diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
> index aba86bb..c4b0d37 100644
> --- a/drivers/dma/ste_dma40.c
> +++ b/drivers/dma/ste_dma40.c
[..]
>  static int d40_channel_execute_command(struct d40_chan *d40c,
> @@ -1990,8 +1992,6 @@ static struct dma_async_tx_descriptor *d40_prep_slave_sg(struct dma_chan *chan,
>        if (d40d == NULL)
>                return NULL;
>
> -       memset(d40d, 0, sizeof(struct d40_desc));
> -

This one isn't a locking bug fix.

--
Dan
