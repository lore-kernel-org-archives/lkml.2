Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755292Ab1HFQeR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Aug 2011 12:34:17 -0400
Received: from mail-pz0-f42.google.com ([209.85.210.42]:51927 "EHLO
	mail-pz0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754682Ab1HFQeQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Aug 2011 12:34:16 -0400
MIME-Version: 1.0
In-Reply-To: <1312348621-20172-1-git-send-email-amwang@redhat.com>
References: <1312348621-20172-1-git-send-email-amwang@redhat.com>
Date: Sat, 6 Aug 2011 12:34:16 -0400
Message-ID: <CACqU3MW2xaMYQ_PNo_nTTOKhiH6Sge5gBS_ju5ZXiDx_rhQxxA@mail.gmail.com>
Subject: Re: [Patch] cpupower: avoid using symlinks
From: Arnaud Lacombe <lacombar@gmail.com>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Dominik Brodowski <linux@dominikbrodowski.net>,
        Thomas Renninger <trenn@suse.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Wed, Aug 3, 2011 at 1:17 AM, Amerigo Wang <amwang@redhat.com> wrote:
> Reference the source directly, don't create symlinks.
>
> Signed-off-by: WANG Cong <amwang@redhat.com>
>
> ---
> diff --git a/tools/power/cpupower/debug/x86_64/Makefile b/tools/power/cpupower/debug/x86_64/Makefile
> index dbf1399..3326217 100644
> --- a/tools/power/cpupower/debug/x86_64/Makefile
> +++ b/tools/power/cpupower/debug/x86_64/Makefile
> @@ -1,10 +1,10 @@
>  default: all
>
> -centrino-decode: centrino-decode.c
> -       $(CC) $(CFLAGS) -o centrino-decode centrino-decode.c
> +centrino-decode: ../i386/centrino-decode.c
> +       $(CC) $(CFLAGS) -o $@ $<
>
> -powernow-k8-decode: powernow-k8-decode.c
> -       $(CC) $(CFLAGS) -o powernow-k8-decode powernow-k8-decode.c
> +powernow-k8-decode: ../i386/powernow-k8-decode.c
> +       $(CC) $(CFLAGS) -o $@ $<
>
>  all: centrino-decode powernow-k8-decode
>
Is there any reason for this stuff not to use kbuild ?

Thanks,
 - Arnaud

> diff --git a/tools/power/cpupower/debug/x86_64/centrino-decode.c b/tools/power/cpupower/debug/x86_64/centrino-decode.c
> deleted file mode 120000
> index 26fb3f1..0000000
> --- a/tools/power/cpupower/debug/x86_64/centrino-decode.c
> +++ /dev/null
> @@ -1 +0,0 @@
> -../i386/centrino-decode.c
> \ No newline at end of file
> diff --git a/tools/power/cpupower/debug/x86_64/powernow-k8-decode.c b/tools/power/cpupower/debug/x86_64/powernow-k8-decode.c
> deleted file mode 120000
> index eb30c79..0000000
> --- a/tools/power/cpupower/debug/x86_64/powernow-k8-decode.c
> +++ /dev/null
> @@ -1 +0,0 @@
> -../i386/powernow-k8-decode.c
> \ No newline at end of file
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
