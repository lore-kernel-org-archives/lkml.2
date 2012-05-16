Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759676Ab2EPR4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 13:56:12 -0400
Received: from mail-gg0-f174.google.com ([209.85.161.174]:52218 "EHLO
	mail-gg0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754628Ab2EPR4K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 13:56:10 -0400
MIME-Version: 1.0
In-Reply-To: <20120516125658.GD20475@lizard>
References: <20120516125330.GA15460@lizard>
	<20120516125658.GD20475@lizard>
Date: Wed, 16 May 2012 10:56:09 -0700
X-Google-Sender-Auth: CumIYMcxQ2FQZA_U43YCM7WtTIk
Message-ID: <CAMbhsRRmcaS7W-eY2eiiBa6xeAeeG+t5Bj4yVmKqkiFbs1bV3Q@mail.gmail.com>
Subject: Re: [PATCH 4/6] pstore/ram: Add some more documentation and examples
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

On Wed, May 16, 2012 at 5:56 AM, Anton Vorontsov
<anton.vorontsov@linaro.org> wrote:
> Suggested-by: Shuah Khan <shuahkhan@gmail.com>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> ---
>  Documentation/ramoops.txt |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
>
> diff --git a/Documentation/ramoops.txt b/Documentation/ramoops.txt
> index 4ba7db2..138823b 100644
> --- a/Documentation/ramoops.txt
> +++ b/Documentation/ramoops.txt
> @@ -40,6 +40,12 @@ corrupt, but usually it is restorable.
>  Setting the ramoops parameters can be done in 2 different manners:
>  1. Use the module parameters (which have the names of the variables described
>  as before).
> + For quick debugging, you can also reserve parts of memory during boot
> + and then use the reserved memory for ramoops. For example, assuming a machine
> + with > 128 MB of memory, the following kernel command line will tell the
> + kernel to use only the first 128 MB of memory, and place ECC-protected ramoops
> + region at 128 MB boundary:
> + "mem=128M ramoops.mem_address=0x8000000 ramoops.ecc=1"
>  2. Use a platform device and set the platform data. The parameters can then
>  be set through that platform data. An example of doing that is:
>
> @@ -70,6 +76,15 @@ if (ret) {
>        return ret;
>  }
>
> +You can specify either RAM memory or peripheral devices' memory. However, when
> +specifying RAM, be sure to reserve the memory by issuing memblock_reserve()
> +very early in the architecture code, just before platform device registration,

Just before platform device registration is way too late.  ARM
provides a machine reserve callback to allow board files to call
memblock_reserve inside arm_memblock_init() and before mm_init().

> +e.g.:
> +
> +#include <linux/memblock.h>
> +
> +memblock_reserve(ramoops_data.mem_address, ramoops_data.mem_size);
> +
>  3. Dump format
>
>  The data dump begins with a header, currently defined as "====" followed by a
> --
> 1.7.9.2
>
