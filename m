Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754525Ab1FTNpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 09:45:50 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63158 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753394Ab1FTNps convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 09:45:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=J+INZ6T00EW50AKWvib0iF/314bzjbTkMPRFiKJuxwQYYb5uAwu/Py8RGRevBdryIa
         ckyypuzGzW3dOy6PLg6w15arTbn6EAfMxWzaskLAJGP3eVme6m/vkcn5hl6qKu+blckH
         MjQhD6wcp2rH8No64/FaQP1cni5KNuTxw/ZsI=
MIME-Version: 1.0
In-Reply-To: <1307393012-32582-2-git-send-email-peterhuewe@gmx.de>
References: <1307393012-32582-1-git-send-email-peterhuewe@gmx.de>
	<1307393012-32582-2-git-send-email-peterhuewe@gmx.de>
Date: Mon, 20 Jun 2011 16:45:46 +0300
Message-ID: <BANLkTikKRVP4PW48YtR+mMMNsaxTDxoGtw@mail.gmail.com>
Subject: Re: [PATCH 2/2] mfd/ab8500: Use kstrtoul_from_user
From: Alexey Dobriyan <adobriyan@gmail.com>
To: Peter Huewe <peterhuewe@gmx.de>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Ian Lartey <ian@opensource.wolfsonmicro.com>,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

NAK
You should use kstrtou8_from_user() and drop 0xff check as well.

Do NOT blindly replace strict_strtoul with kstrtoul.

On Mon, Jun 6, 2011 at 11:43 PM, Peter Huewe <peterhuewe@gmx.de> wrote:
> -       err = strict_strtoul(buf, 0, &user_val);
> +       err = kstrtoul_from_user(user_buf, count, 0, &user_val);
>        if (err)
> -               return -EINVAL;
> +               return err;
> +
>        if (user_val > 0xff) {
>                dev_err(dev, "debugfs error input > 0xff\n");
>                return -EINVAL;
