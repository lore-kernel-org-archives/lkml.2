Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754132Ab2IVJYi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 05:24:38 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:61431 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753285Ab2IVJYh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 05:24:37 -0400
MIME-Version: 1.0
X-Originating-IP: [85.250.96.155]
In-Reply-To: <1348158776-23858-1-git-send-email-sjur.brandeland@stericsson.com>
References: <1348158776-23858-1-git-send-email-sjur.brandeland@stericsson.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Sat, 22 Sep 2012 12:24:15 +0300
Message-ID: <CAK=WgbZbuf6PYkT4vcpP4VAejT8mN4CO3PFB9Ng-74Q=4iKTrQ@mail.gmail.com>
Subject: Re: [PATCHv4] remoteproc: Add STE modem driver for remoteproc
To: sjur.brandeland@stericsson.com
Cc: =?ISO-8859-1?Q?Sjur_Br=E6ndeland?= <sjurbren@gmail.com>,
        linux-kernel@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 20, 2012 at 7:32 PM,  <sjur.brandeland@stericsson.com> wrote:
> From: Sjur Brændeland <sjur.brandeland@stericsson.com>
>
> Add support for the STE modem shared memory driver.
> This driver hooks into the remoteproc framework
> in order to manage configuration and the virtio
> devices.
>
> This driver adds custom firmware handlers, because
> STE modem uses a custom firmware layout.
>
> Signed-off-by: Sjur Brændeland <sjur.brandeland@stericsson.com>
> cc: Linus Walleij <linus.walleij@linaro.org>
> cc: Alan Cox <alan@lxorguk.ukuu.org.uk>
> ---
> Changes from v3:
> Added function setup to struct ste_modem_dev_ops.

Thanks, it looks good.

It might be safer though to invoke ->setup() in probe/remove, instead
of in start/stop (just like you essentially did before).

This way we don't assume that stop is always called before remove (as
assumption that might be implicitly valid today, but may break in the
future).

If you want, I can just change that before applying.

Thanks,
Ohad.
