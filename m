Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760729Ab2EPWfb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 18:35:31 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:43299 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759748Ab2EPWfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 18:35:16 -0400
Date: Wed, 16 May 2012 15:33:46 -0700
From: Anton Vorontsov <anton.vorontsov@linaro.org>
To: Kees Cook <keescook@chromium.org>
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
Subject: Re: [PATCH 1/6] pstore: Add console log messages support
Message-ID: <20120516223345.GB22797@lizard>
References: <20120516125330.GA15460@lizard>
 <20120516125625.GA20475@lizard>
 <CAGXu5j+oZRqow-cfEq3FgGW-NLWvsxCzjwG=SkJpaT345MM7WA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGXu5j+oZRqow-cfEq3FgGW-NLWvsxCzjwG=SkJpaT345MM7WA@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 09:49:11AM -0700, Kees Cook wrote:
[...]
> > +#ifdef CONFIG_PSTORE_CONSOLE
> > +static void pstore_console_write(struct console *con, const char *s, unsigned c)
> > +{
> > +       strncpy(psinfo->buf, s, c);
> 
> The size of psinfo->buf needs to be the length argument to strncpy,
> not the size of "s". If "s" isn't NULL terminated, then the min of c
> and buf's size should be used. And if this should be NULL terminated
> in buf, that needs to be added manually since strncpy won't do it if
> it hits the max length argument.

Whoops. Will fix it, thanks!

-- 
Anton Vorontsov
Email: cbouatmailru@gmail.com
