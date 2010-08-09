Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178Ab0HITwk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Aug 2010 15:52:40 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:45165 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755269Ab0HITwh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Aug 2010 15:52:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=prEjiUJhGXONVNXyiZuRE171V9QoQzQ1S1YDyWH4GOTfaqcT2EWyryfDNDX4rEQI8J
         EnDfJEJUIzWU87OZ12Dw2AJVvOrWbPdtA6q5eaE3hsCoZArWbRvXK/O2TcaAcWDrS93B
         s+1gOquRLHhCLAoNIUE+qSpdn1AWuTCa7JR8Y=
MIME-Version: 1.0
In-Reply-To: <201008042011.o74KBSlB026488@hera.kernel.org>
References: <201008042011.o74KBSlB026488@hera.kernel.org>
Date: Mon, 9 Aug 2010 21:52:36 +0200
X-Google-Sender-Auth: xFC29aSTFIz4VomOSlOD6Q3CyFE
Message-ID: <AANLkTi=ffogSPifiTg7tofEvbpFcpAsfM_bm2DCASvs1@mail.gmail.com>
Subject: Re: netfilter: add xt_cpu match
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Eric Dumazet <eric.dumazet@gmail.com>, Patrick McHardy <kaber@trash.net>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        netfilter@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 4, 2010 at 22:11, Linux Kernel Mailing List
<linux-kernel@vger.kernel.org> wrote:
> Gitweb:     http://git.kernel.org/linus/e8648a1fdb54da1f683784b36a17aa65ea56e931
> Commit:     e8648a1fdb54da1f683784b36a17aa65ea56e931
> Parent:     7f1c407579519e71a0dcadc05614fd98acec585e
> Author:     Eric Dumazet <eric.dumazet@gmail.com>
> AuthorDate: Fri Jul 23 12:59:36 2010 +0200
> Committer:  Patrick McHardy <kaber@trash.net>
> CommitDate: Fri Jul 23 12:59:36 2010 +0200
>
>    netfilter: add xt_cpu match
>
>    In some situations a CPU match permits a better spreading of
>    connections, or select targets only for a given cpu.

> --- a/net/netfilter/Kconfig
> +++ b/net/netfilter/Kconfig
> @@ -663,6 +663,15 @@ config NETFILTER_XT_MATCH_CONNTRACK
>
>          To compile it as a module, choose M here.  If unsure, say N.
>
> +config NETFILTER_XT_MATCH_CPU
> +       tristate '"cpu" match support'
> +       depends on NETFILTER_ADVANCED
> +       help
> +         CPU matching allows you to match packets based on the CPU
> +         currently handling the packet.

Shouldn't this depend on SMP? Or does it make sense to have it on UP, too?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
