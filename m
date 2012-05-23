Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964986Ab2EWCux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 22:50:53 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:42161 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964909Ab2EWCuv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 22:50:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120523023513.GA22235@lizard>
References: <20120522141717.GA31574@lizard> <1337696279-8994-3-git-send-email-anton.vorontsov@linaro.org>
 <CAMbhsRQPYzXregvvgQZD1dV_m4tgx0hQqnYPyaO3mV0hRpc5JQ@mail.gmail.com> <20120523023513.GA22235@lizard>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 22 May 2012 19:50:29 -0700
X-Google-Sender-Auth: udnzQ5gkmBMaFoZRa0dXSygUlU0
Message-ID: <CA+55aFz8Xxx=5pcfpJSewkSTRft1x4UY5cJMcR64Fo_x98=JKg@mail.gmail.com>
Subject: Re: [PATCH/RFC] Make sure linux_banner is the first message in log_buf
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Colin Cross <ccross@android.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
        patches@linaro.org, kernel-team@android.com,
        Ingo Molnar <mingo@elte.hu>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rusty Russell <rusty@rustcorp.com.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 7:35 PM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> @@ -749,6 +749,9 @@ asmlinkage int printk(const char *fmt, ...)
>        va_list args;
>        int r;
>
> +       /* Make sure linux_banner is kernel's first message. */
> +       printk_once(KERN_NOTICE "%s", linux_banner);
> +

Ugh. No. That is too disgusting for words.

                  Linus
