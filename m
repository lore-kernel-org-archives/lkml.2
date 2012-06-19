Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753351Ab2FSSkH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Jun 2012 14:40:07 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:57684 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955Ab2FSSkF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Jun 2012 14:40:05 -0400
MIME-Version: 1.0
In-Reply-To: <1340072156-6225-1-git-send-email-anton.vorontsov@linaro.org>
References: <20120619021050.GA19387@lizard>
	<1340072156-6225-1-git-send-email-anton.vorontsov@linaro.org>
Date: Tue, 19 Jun 2012 11:40:04 -0700
X-Google-Sender-Auth: U7GhJsK8Vo2DPUC9TIXPWQxpHYw
Message-ID: <CAGXu5j+jszfX=6Ah07Dx5Q4QDS+gxzEraMeZ+28xQhAKXJjafA@mail.gmail.com>
Subject: Re: [PATCH 1/7] pstore/ram: Probe as early as possible
From: Kees Cook <keescook@chromium.org>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Colin Cross <ccross@android.com>, Tony Luck <tony.luck@intel.com>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 18, 2012 at 7:15 PM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> Registering the platform driver before module_init allows us to log oopses
> that happen during device probing.
>
> This requires changing module_init to postcore_initcall, and switching
> from platform_driver_probe to platform_driver_register because the
> platform device is not registered when the platform driver is registered;
> and because we use driver_register, now can't use create_bundle() (since
> it will try to register the same driver once again), so we have to switch
> to platform_device_register_data().
>
> Also, some __init -> __devinit changes were needed.
>
> Overall, the registration logic is now much clearer, since we have only
> one driver registration point, and just an optional dummy device, which
> is created from the module parameters.
>
> Suggested-by: Colin Cross <ccross@android.com>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>

Acked-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
Chrome OS Security
