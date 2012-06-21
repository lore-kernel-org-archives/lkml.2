Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757707Ab2FUGss (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Jun 2012 02:48:48 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:53861 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754578Ab2FUGsr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Jun 2012 02:48:47 -0400
MIME-Version: 1.0
X-Originating-IP: [2001:470:8656:0:884f:68b4:b6cf:a825]
In-Reply-To: <1339531019-17040-1-git-send-email-bfreed@chromium.org>
References: <1339531019-17040-1-git-send-email-bfreed@chromium.org>
Date: Wed, 20 Jun 2012 23:48:46 -0700
Message-ID: <CAOesGMi+FOdf53_fYVv2x2ZwuJYYL-x+jdY_0_-STx07QQ+GSw@mail.gmail.com>
Subject: Re: [PATCH v4] pstore/ram: Add ramoops support for the Flattened
 Device Tree.
From: Olof Johansson <olof@lixom.net>
To: Bryan Freed <bfreed@chromium.org>
Cc: linux-kernel@vger.kernel.org, keescook@chromium.org,
        marco.stornelli@gmail.com, grant.likely@secretlab.ca,
        anton.vorontsov@linaro.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Jun 12, 2012 at 12:56 PM, Bryan Freed <bfreed@chromium.org> wrote:

[...]

> +static const struct of_device_id ramoops_of_match[] = {
> +       { .compatible = "ramoops", },
> +       { },
> +};
> +MODULE_DEVICE_TABLE(of, ramoops_of_match);
> +
>  static struct platform_driver ramoops_driver = {
>        .remove         = __exit_p(ramoops_remove),
>        .driver         = {
>                .name   = "ramoops",
>                .owner  = THIS_MODULE,
> +               .of_match_table = ramoops_of_match,

I think you need some of the above to be #ifdef CONFIG_OF + empty
stubs in the else case, and the above assignment should use
of_match_ptr() to wrap the assignment. Take a look at how some of the
other drivers in the kernel handle the OF bindings on platform drivers
for reference.

The bindings look reasonable to me; what they don't cover is where in
the device tree the node should reside. To be honest, I think it's
probably better to leave it fairly vague since different platforms
might prefer different locations -- it's really software configuration
data more than a description of the system hardware.

Besides that, this looks good as far as I am concerned.


-Olof
