Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967588Ab2EQSmd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 May 2012 14:42:33 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:65231 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967533Ab2EQSmb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 May 2012 14:42:31 -0400
MIME-Version: 1.0
In-Reply-To: <20120517083740.GA25627@lizard>
References: <20120517083740.GA25627@lizard>
Date: Thu, 17 May 2012 11:42:29 -0700
X-Google-Sender-Auth: KvxfmlNLITisRI_k5AmRKzKEyEk
Message-ID: <CAMbhsRTGOnjB2M7L4n38=on1dB5unF=WNCScsX9n3fWZjdGEfA@mail.gmail.com>
Subject: Re: [PATCH v2 0/6] Merge ram_console into pstore
From: Colin Cross <ccross@android.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Tony Luck <tony.luck@intel.com>,
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
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 1:37 AM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> Hi all,
>
> In v2:
>
> - Updated documentation per Colin Cross' comments;
> - Corrected return value in ramoops_pstore_write() (noticed by Kees Cook);
> - Fixed large writes handling in pstore_console_write(), i.e. when
>  log_buf write is larger than pstore bufsize. Also Noticed by Kees Cook.
>
> These patches depend on the the following series:
> http://thread.gmane.org/gmane.linux.kernel/1298642
> "[PATCH v3 0/3] Merge ramoops and persistent_ram, generic pstore RAM backend"
>
> And a rationale for the series:
>
> Currently pstore doesn't support logging kernel messages in run-time,
> it only dumps dmesg when kernel oopses/panics. This makes pstore
> useless for debugging hangs caused by HW issues or improper use of HW
> (e.g. weird device inserted -> driver tried to write reserved bits ->
> SoC hanged. In that case we don't get any messages in the pstore.
>
> This series add a new message type for pstore, i.e. PSTORE_TYPE_CONSOLE,
> plus make pstore/ram.c handle the new messages.
>
> The old ram_console driver is removed. This might probably cause
> some pain for out-of-tree code, as it would need to be adjusted...
> but "no pain, no gain"? :-) Though, if there's some serious resistance,
> we can probably postpone the last two patches.
>
> Thanks!
>
> --
> Anton Vorontsov
> Email: cbouatmailru@gmail.com

Other than my comment on logging console into a single record,
Acked-by: Colin Cross <ccross@android.com>

There is one feature that ram_console had but lost when I added
persistent_ram, which would be nice to get back:  registering the
platform driver before module_init, to allow it to log oopses that
happen during device probing.  This requires changing module_init to
postcore_initcall, and switching from platform_driver_probe to
platform_driver_register because the platform device is not registered
when the platform driver is registered.  Depending on what functions
are __init, it may cause a cascading change from __init to __devinit
as well.
