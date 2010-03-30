Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755099Ab0C3O3G (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 10:29:06 -0400
Received: from are.twiddle.net ([75.149.56.221]:56356 "EHLO are.twiddle.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753069Ab0C3O3E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 10:29:04 -0400
Message-ID: <4BB20AAB.7000909@twiddle.net>
Date: Tue, 30 Mar 2010 07:28:59 -0700
From: Richard Henderson <rth@twiddle.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.8) Gecko/20100301 Fedora/3.0.3-1.fc12 Thunderbird/3.0.3
MIME-Version: 1.0
To: Matt Turner <mattst88@gmail.com>
CC: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
       Ivan Kokshaysky <ink@jurassic.park.msu.ru>, ang@brigante.org
Subject: Re: [RFC] alpha: hack objstrip.c to make it compile.
References: <1269913795-1852-1-git-send-email-mattst88@gmail.com>
In-Reply-To: <1269913795-1852-1-git-send-email-mattst88@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2010 06:49 PM, Matt Turner wrote:
> I don't think this is the appropriate fix. What should I do to fix this?
> ---
>  arch/alpha/boot/tools/objstrip.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
> 
> diff --git a/arch/alpha/boot/tools/objstrip.c b/arch/alpha/boot/tools/objstrip.c
> index 367d53d..54fa1ef 100644
> --- a/arch/alpha/boot/tools/objstrip.c
> +++ b/arch/alpha/boot/tools/objstrip.c
> @@ -27,6 +27,9 @@
>  #include <linux/param.h>
>  #ifdef __ELF__
>  # include <linux/elf.h>
> +# define elfhdr	elf64_hdr
> +# define elf_phdr	elf64_phdr
> +# define elf_check_arch(x) ((x)->e_machine == EM_ALPHA)
>  #endif
>  

Hum.  Is it so bad to just #define __KERNEL__ here before
that one include?  Similar games are played in tools/perf/,
and with a suitible comment I think that should be all right.


r~
