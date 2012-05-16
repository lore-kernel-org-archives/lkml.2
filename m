Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933214Ab2EPXqb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 19:46:31 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:46149 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760721Ab2EPXqa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 19:46:30 -0400
MIME-Version: 1.0
In-Reply-To: <20120516124338.GD18345@lizard>
References: <20120516124109.GA14658@lizard>
	<20120516124338.GD18345@lizard>
Date: Wed, 16 May 2012 16:46:29 -0700
Message-ID: <CAMP5XgerV-WYCSTcW12Sog1axb-+szbOPL+SyE2OvfHu+U5xhw@mail.gmail.com>
Subject: Re: [PATCH 4/6] persistent_ram: Move to fs/pstore/ram_core.c
From: =?ISO-8859-1?Q?Arve_Hj=F8nnev=E5g?= <arve@android.com>
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Arnd Bergmann <arnd@arndb.de>, John Stultz <john.stultz@linaro.org>,
        Shuah Khan <shuahkhan@gmail.com>,
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
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 16, 2012 at 5:43 AM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> This is a first step for adding ECC support for pstore RAM backend: we
> will use the persistent_ram routines, kindly provided by Google.
>
> Basically, persistent_ram is a set of helper routines to deal with the
> [optionally] ECC-protected persistent ram regions.
>
...
> +static int persistent_ram_init_ecc(struct persistent_ram_zone *prz,
> +       size_t buffer_size)
> +{
> +       int numerr;
> +       struct persistent_ram_buffer *buffer = prz->buffer;
> +       int ecc_blocks;
> +
> +       if (!prz->ecc)
> +               return 0;
> +
> +       prz->ecc_block_size = 128;
> +       prz->ecc_size = 16;

I realize you are just moving code here, but 16 ecc bytes for per 128
bytes of data can only correct 8 bad bytes, which is not always
sufficient. At some point this will need to be made configurable
again.

-- 
Arve Hjønnevåg
