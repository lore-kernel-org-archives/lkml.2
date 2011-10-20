Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab1JTHym (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Oct 2011 03:54:42 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:56556 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab1JTHyl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Oct 2011 03:54:41 -0400
MIME-Version: 1.0
In-Reply-To: <1319096606-11568-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1319096606-11568-1-git-send-email-ricardo.ribalda@gmail.com>
Date: Thu, 20 Oct 2011 10:54:40 +0300
X-Google-Sender-Auth: gwIankaip86xWSZhzDm4ukexXCk
Message-ID: <CAOJsxLGZLx-Wybi=BM41pN5X5Xw=qw4dEC_q=Qy903GpKj6Nzw@mail.gmail.com>
Subject: Re: [PATCH] tools/perf: Increase symbol KSYM_NAME_LEN size
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@elte.hu,
        acme@ghostprotocols.net, anton@samba.org, daahern@cisco.com,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 20, 2011 at 10:43 AM, Ricardo Ribalda Delgado
<ricardo.ribalda@gmail.com> wrote:
> Fglrx propietary driver has symbol names over 128 chars (:S). This
> breaks the function kallsyms__parse.
>
> This fix increases the size of KSYM_NAME_LEN, so kallsyms__parse can
> work on such kernels.
>
> The only counterparty, is that such function requires 128 more bytes to
> work.
>
> Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
> ---
>  tools/perf/util/symbol.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
> index 40eeaf0..d4f8750 100644
> --- a/tools/perf/util/symbol.c
> +++ b/tools/perf/util/symbol.c
> @@ -24,7 +24,7 @@
>  #include <sys/utsname.h>
>
>  #ifndef KSYM_NAME_LEN
> -#define KSYM_NAME_LEN 128
> +#define KSYM_NAME_LEN 256
>  #endif
>
>  #ifndef NT_GNU_BUILD_ID
> --
> 1.7.7

Is there some specified maximum length for symbols (e.g. in ELF spec)?
I'm OK with the patch but I'd prefer we didn't bump up the number
blindly there's something "official" number we can use.

                        Pekka
