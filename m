Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753740Ab2E1PEY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 11:04:24 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61127 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab2E1PEW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 11:04:22 -0400
MIME-Version: 1.0
In-Reply-To: <4FC38DBD.4070406@redhat.com>
References: <20120420020013.GA19964@windriver.com>
	<CAMuHMdUUgysVqz226jhK42nvYNaX7yvexpqRjOPx0QpvzUwVXg@mail.gmail.com>
	<4FC38DBD.4070406@redhat.com>
Date: Mon, 28 May 2012 17:04:21 +0200
X-Google-Sender-Auth: Fp7VcyCIfj-Syat9lDN9n-nksWE
Message-ID: <CAMuHMdXf6O249NttPgeQzWkGfLu_Ocod80ecXaaFy+SqZQNmcg@mail.gmail.com>
Subject: Re: linux-next: triage for April 19, 2012
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: Avi Kivity <avi@redhat.com>
Cc: Paul Gortmaker <paul.gortmaker@windriver.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Avi,

On Mon, May 28, 2012 at 4:37 PM, Avi Kivity <avi@redhat.com> wrote:
> On 05/25/2012 11:59 PM, Geert Uytterhoeven wrote:
>> On Fri, Apr 20, 2012 at 4:00 AM, Paul Gortmaker
>> <paul.gortmaker@windriver.com> wrote:
>>> The parisc got borked by some kvm header shuffle it seems?
>>> Now complaining about "file 'asm-generic/kvm_para.h' is not exported"
>>> [ http://kisskb.ellerman.id.au/kisskb/buildresult/6137786/ ]
>>
>> Not only parisc.
>>
>> This breakage has now entered mainline:
>>
>> parisc deconfig http://kisskb.ellerman.id.au/kisskb/buildresult/6365677/
>> m68k allmodconfig: http://kisskb.ellerman.id.au/kisskb/buildresult/6365681/
>
>
> Does the following patch help?

Thanks, that fixes it!

Tested-by: Geert Uytterhoeven <geert@linux-m68k.org>

> From: Avi Kivity <avi@redhat.com>
> Date: Mon, 28 May 2012 17:35:22 +0300
> Subject: [PATCH] KVM: Export asm-generic/kvm_para.h
>
> Prevents build failures on non-KVM archs.
>
> Signed-off-by: Avi Kivity <avi@redhat.com>
> ---
>  include/asm-generic/Kbuild |    1 +
>  1 file changed, 1 insertion(+)
>
> diff --git a/include/asm-generic/Kbuild b/include/asm-generic/Kbuild
> index 53f91b1..2c85a0f 100644
> --- a/include/asm-generic/Kbuild
> +++ b/include/asm-generic/Kbuild
> @@ -8,6 +8,7 @@ header-y += int-ll64.h
>  header-y += ioctl.h
>  header-y += ioctls.h
>  header-y += ipcbuf.h
> +header-y += kvm_para.h
>  header-y += mman-common.h
>  header-y += mman.h
>  header-y += msgbuf.h
>

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
