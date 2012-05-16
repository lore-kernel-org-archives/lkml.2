Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755172Ab2EPP2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 May 2012 11:28:36 -0400
Received: from g5t0006.atlanta.hp.com ([15.192.0.43]:1039 "EHLO
	g5t0006.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753950Ab2EPP2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 May 2012 11:28:34 -0400
Message-ID: <1337182110.2424.15.camel@lorien2>
Subject: Re: [PATCH 4/6] pstore/ram: Add some more documentation and examples
From: Shuah Khan <shuahkhan@gmail.com>
Reply-To: shuahkhan@gmail.com
To: Anton Vorontsov <anton.vorontsov@linaro.org>
Cc: shuahkhan@gmail.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>, Colin Cross <ccross@android.com>,
        Tony Luck <tony.luck@intel.com>, Arnd Bergmann <arnd@arndb.de>,
        John Stultz <john.stultz@linaro.org>, arve@android.com,
        Rebecca Schultz Zavin <rebecca@android.com>,
        Jesper Juhl <jj@chaosbits.net>, Randy Dunlap <rdunlap@xenotime.net>,
        Stephen Boyd <sboyd@codeaurora.org>, Thomas Meyer <thomas@m3y3r.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Stornelli <marco.stornelli@gmail.com>,
        WANG Cong <xiyou.wangcong@gmail.com>, linux-kernel@vger.kernel.org,
        devel@driverdev.osuosl.org, linaro-kernel@lists.linaro.org,
        patches@linaro.org, kernel-team@android.com
Date: Wed, 16 May 2012 09:28:30 -0600
In-Reply-To: <20120516125658.GD20475@lizard>
References: <20120516125330.GA15460@lizard> <20120516125658.GD20475@lizard>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Anton,

Ignore my previous email. I am still getting caught up with your
patches.

On Wed, 2012-05-16 at 05:56 -0700, Anton Vorontsov wrote:
> Suggested-by: Shuah Khan <shuahkhan@gmail.com>
> Signed-off-by: Anton Vorontsov <anton.vorontsov@linaro.org>
> ---
>  Documentation/ramoops.txt |   15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/Documentation/ramoops.txt b/Documentation/ramoops.txt
> index 4ba7db2..138823b 100644
> --- a/Documentation/ramoops.txt
> +++ b/Documentation/ramoops.txt
> @@ -40,6 +40,12 @@ corrupt, but usually it is restorable.
>  Setting the ramoops parameters can be done in 2 different manners:
>   1. Use the module parameters (which have the names of the variables described
>   as before).
> + For quick debugging, you can also reserve parts of memory during boot
> + and then use the reserved memory for ramoops. For example, assuming a machine
> + with > 128 MB of memory, the following kernel command line will tell the
> + kernel to use only the first 128 MB of memory, and place ECC-protected ramoops
> + region at 128 MB boundary:
> + "mem=128M ramoops.mem_address=0x8000000 ramoops.ecc=1"
>   2. Use a platform device and set the platform data. The parameters can then
>   be set through that platform data. An example of doing that is:

Thanks much. This is great information to have. Exactly the detail I was
asking for.

>  
> @@ -70,6 +76,15 @@ if (ret) {
>  	return ret;
>  }
>  
> +You can specify either RAM memory or peripheral devices' memory. However, when
> +specifying RAM, be sure to reserve the memory by issuing memblock_reserve()
> +very early in the architecture code, just before platform device registration,
> +e.g.:
> +
> +#include <linux/memblock.h>
> +
> +memblock_reserve(ramoops_data.mem_address, ramoops_data.mem_size);

Same here. :)

-- Shuah
> +
>  3. Dump format
>  
>  The data dump begins with a header, currently defined as "====" followed by a


