Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754596Ab1KUHrx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 02:47:53 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:42095 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753935Ab1KUHrw convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 02:47:52 -0500
MIME-Version: 1.0
In-Reply-To: <1321004406-15663-1-git-send-email-p-combes@ti.com>
References: <1321004406-15663-1-git-send-email-p-combes@ti.com>
Date: Mon, 21 Nov 2011 08:47:51 +0100
Message-ID: <CACRpkdbo0CRQTYYS2C3XdoP+43VX9TyVnXf4LwS6e1a+BMyAzw@mail.gmail.com>
Subject: Re: [RFC][PATCH] gpiolib: add irq_wake (power-management) sysfs file
From: Linus Walleij <linus.walleij@linaro.org>
To: Patrick Combes <p-combes@ti.com>
Cc: grant.likely@secretlab.ca, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Hugo Dupras <h-dupras@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 11, 2011 at 10:40 AM, Patrick Combes <p-combes@ti.com> wrote:

> This patch creates a new sysfs file /sys/class/gpio/gpioN/irq_wake to enable
> usermode application to set the wake properties of a gpio IRQ.
> This option can be set or not for each gpio to preserve power consumption (e.g
> embedded systems).
(...)
> +       if (!test_bit(FLAG_EXPORT, &desc->flags))
> +               status = -EIO;
> +       else if (sysfs_streq(buf, "enable") || sysfs_streq(buf, "1"))
> +               status = enable_irq_wake(gpio_to_irq(gpio));
> +       else if (sysfs_streq(buf, "disable") || sysfs_streq(buf, "0"))
> +               status = disable_irq_wake(gpio_to_irq(gpio));
> +       else
> +               status = -EINVAL;

As noted elsewhere, human-readable files go into debugfs.

sysfs rule is one file, one value.

Create a file ile named "irq_wakeup_enable" that works
like this:

cat wakeup_enable
0
echo 1 > wakeup_enable
cat wakeup_enable
1

Also document you new ABI in
Documentation/ABI/testing/*
and preferabley write some new words on it
in Documentation/gpio.txt too.

Thanks!
Linus Walleij
