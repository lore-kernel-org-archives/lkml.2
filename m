Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757775Ab2IDTux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 15:50:53 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:48676 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757695Ab2IDTuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 15:50:51 -0400
MIME-Version: 1.0
In-Reply-To: <20120904.142059.559850562286758578.davem@davemloft.net>
References: <20120904165853.bc2f7b6524a3b03a09c4180d@canb.auug.org.au>
	<20120904.142059.559850562286758578.davem@davemloft.net>
Date: Tue, 4 Sep 2012 12:50:49 -0700
Message-ID: <CAPshTChcayG2ryKQ4N9FLHbHnC28mJh97598qQK05nV8WM9OQw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the final tree (net-next
 tree related)
From: Jerry Chu <hkchu@google.com>
To: David Miller <davem@davemloft.net>
Cc: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 4, 2012 at 11:20 AM, David Miller <davem@davemloft.net> wrote:
> From: Stephen Rothwell <sfr@canb.auug.org.au>
> Date: Tue, 4 Sep 2012 16:58:53 +1000
>
>> net/built-in.o: In function `tcp_fastopen_ctx_free':
>> tcp_fastopen.c:(.text+0x5cc5c): undefined reference to `crypto_destroy_tfm'
>> net/built-in.o: In function `tcp_fastopen_reset_cipher':
>> (.text+0x5cccc): undefined reference to `crypto_alloc_base'
>> net/built-in.o: In function `tcp_fastopen_reset_cipher':
>> (.text+0x5cd6c): undefined reference to `crypto_destroy_tfm'
>>
>> Presumably caused by commit 104671636897 ("tcp: TCP Fast Open Server -
>> header & support functions") from the net-next tree.  I assume that some
>> dependency on the CRYPTO infrastructure is missing.
>
> Thanks for the report, I've pushed the following change to net-next
> which should address this:
>
> --------------------
> [PATCH] net: Add INET dependency on aes crypto for the sake of TCP fastopen.
>
> Stephen Rothwell says:
>
> ====================
> After merging the final tree, today's linux-next build (powerpc
> ppc44x_defconfig) failed like this:
>
> net/built-in.o: In function `tcp_fastopen_ctx_free':
> tcp_fastopen.c:(.text+0x5cc5c): undefined reference to `crypto_destroy_tfm'
> net/built-in.o: In function `tcp_fastopen_reset_cipher':
> (.text+0x5cccc): undefined reference to `crypto_alloc_base'
> net/built-in.o: In function `tcp_fastopen_reset_cipher':
> (.text+0x5cd6c): undefined reference to `crypto_destroy_tfm'
>
> Presumably caused by commit 104671636897 ("tcp: TCP Fast Open Server -
> header & support functions") from the net-next tree.  I assume that some
> dependency on the CRYPTO infrastructure is missing.
>
> I have reverted commit 1bed966cc3bd ("Merge branch
> 'tcp_fastopen_server'") for today.
> ====================
>
> Reported-by: Stephen Rothwell <sfr@canb.auug.org.au>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> ---
>  net/Kconfig |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/net/Kconfig b/net/Kconfig
> index 245831b..30b48f5 100644
> --- a/net/Kconfig
> +++ b/net/Kconfig
> @@ -52,6 +52,8 @@ source "net/iucv/Kconfig"
>
>  config INET
>         bool "TCP/IP networking"
> +       select CRYPTO
> +       select CRYPTO_AES
>         ---help---
>           These are the protocols used on the Internet and on most local
>           Ethernets. It is highly recommended to say Y here (this will enlarge
> --
> 1.7.7.6
>

Thanks for fixing this, David. (Sorry for missing the dependency.)

Jerry
