Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756521Ab0I3Tti (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 15:49:38 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:51537 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756410Ab0I3Tth convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 15:49:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=vWbw6OU0JOO5diB1mrzuTlCt2nV6/S8hTWDD4SEIMHD2d8yyCJkKmgv4MG2DlrAEif
         1SR5LYCMA3qGzZDvyvXXMYNmo8UfPwr9Drexo8tx9469u3Qrfc7+ASEg7pT5irCgKDDX
         kjnKpuT4H7tAipz2w4OOrJrO3MM9Q6gFdVCbk=
MIME-Version: 1.0
In-Reply-To: <1285875794.2180.0.camel@cowboy>
References: <1285875794.2180.0.camel@cowboy>
Date: Thu, 30 Sep 2010 22:49:36 +0300
X-Google-Sender-Auth: YLUoQjz4Y5LWTXh1icNsxkZEUEk
Message-ID: <AANLkTinQ05Hrn8oLtMBLKrs5NOXqzg1CfK+aESTUnJTx@mail.gmail.com>
Subject: Re: [RESEND PATCH] x86: return proper error code
From: Pekka Enberg <penberg@kernel.org>
To: dave@gnu.org
Cc: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        LKML <linux-kernel@vger.kernel.org>, x86@kernel.org, pq@iki.fi
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 30, 2010 at 10:43 PM, Davidlohr Bueso <dave@gnu.org> wrote:
> x86: return -ENOMEM instead of -1 when returning on memory allocation errors in add_kmmio_fault_page()
>
> Signed-off-by: Davidlohr Bueso <dave@gnu.org>
> ---
>  arch/x86/mm/kmmio.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/mm/kmmio.c b/arch/x86/mm/kmmio.c
> index e5d5e2c..36a4347 100644
> --- a/arch/x86/mm/kmmio.c
> +++ b/arch/x86/mm/kmmio.c
> @@ -370,7 +370,7 @@ static int add_kmmio_fault_page(unsigned long page)
>
>        f = kzalloc(sizeof(*f), GFP_ATOMIC);
>        if (!f)
> -               return -1;
> +               return -ENOMEM;
>
>        f->count = 1;
>        f->page = page;

This doesn't matter much as register_kmmio_probe() doesn't do anything
sane with the error code and ioremap_trace_core() ignores what
register_mmio_probe() does completely. I'd either keep the code as-is
or try to fix up the fishy error handling properly.
