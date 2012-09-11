Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755779Ab2IKGRn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 02:17:43 -0400
Received: from mail-ie0-f174.google.com ([209.85.223.174]:35311 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752971Ab2IKGRl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 02:17:41 -0400
Message-ID: <504ED77D.90008@gmail.com>
Date: Tue, 11 Sep 2012 16:17:33 +1000
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: linus.walleij@linaro.org, grant.likely@secretlab.ca,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] allow gpiolib to be a module
References: <504DF63A020000780009A30B@nat28.tlf.novell.com>
In-Reply-To: <504DF63A020000780009A30B@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/12 22:16, Jan Beulich wrote:
> Without ARCH_REQUIRE_GPIOLIB there's no reason to force this code, when
> enabled, to always be built into the kernel, which requires only minor
> Makefile and source code adjustments.
> 
> Signed-off-by: Jan Beulich <jbeulich@suse.com>
> 
> ---

<snip>

> +#ifdef MODULE
> +int __init gpiolib_init(void)

Should be static.

> +{
> +	return gpiolib_sysfs_init() ?: gpiolib_debugfs_init();

I thought this was going to call gpiolib_sysfs_init() twice until I
looked at gcc's documentation. Maybe the less obtuse, and far more common:

  int err;

  err = gpiolib_sysfs_init();
  if (err)
          return err;

  return gpiolib_debugfs_init();

?

> +}
> +module_init(gpiolib_init);

~Ryan


