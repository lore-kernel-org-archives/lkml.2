Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756728Ab0ENSdb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 May 2010 14:33:31 -0400
Received: from mail-yx0-f191.google.com ([209.85.210.191]:33157 "EHLO
	mail-yx0-f191.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754452Ab0ENSd3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 May 2010 14:33:29 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=kXDvzUhs4S3CayHXkKdz/BhcalSUJWWySTcbj0FIj4d8bJSQQthjzIyq0U8AcGZpUg
         etzS/x+IEly09ldaWaueWU5jj9l1rNDJv6NibXm/vAFTciSSR0f+qFfNufpoF0bD/EPN
         lYq+t4hYY+gRKuCg0GqSUbLurhExazu2kine8=
MIME-Version: 1.0
In-Reply-To: <20100514180148.GE13509@lenovo>
References: <AANLkTinPcjUyPyUP4L7opELEbLZy-tXxkbm-nqe8Co0f@mail.gmail.com>
	 <20100514115655.GA18069@elte.hu> <20100514135240.GA4952@lenovo>
	 <20100514145213.GA13509@lenovo>
	 <AANLkTik6rwpU665xKUWfaOhV-h3Xgm_xeSiXH0Ax-n2u@mail.gmail.com>
	 <20100514162813.GB13509@lenovo>
	 <AANLkTinSAEATJbnj5MwhuKlBtXEGzpdeoktkzktrESvw@mail.gmail.com>
	 <20100514164057.GC13509@lenovo>
	 <AANLkTinQL16caUSZnFFr4gs_vfT93mwkNTK7I_eShZvA@mail.gmail.com>
	 <20100514180148.GE13509@lenovo>
Date: Sat, 15 May 2010 00:03:28 +0530
Message-ID: <AANLkTimJV-rocIoSzzwuR9sqytM12xH-KZHsihgHss4l@mail.gmail.com>
Subject: Re: Performance Events hangs with Intel P4 system
From: Jaswinder Singh Rajput <jaswinderlinux@gmail.com>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>, Lin Ming <ming.m.lin@intel.com>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Frederic Weisbecker <fweisbec@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Cyrill,

On Fri, May 14, 2010 at 11:31 PM, Cyrill Gorcunov <gorcunov@gmail.com> wrote:
>
>
> Jaswinder, could you give this patch a shot so that I will be
> able to put your tested-by tag and send it upstream? (it's slightly
> tuned from previous but should be same on bin level). This GP
> issue need to be fixed before any other things.
>
>        -- Cyrill
> ---
>  arch/x86/kernel/cpu/perf_event_p4.c |    8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
>
> Index: linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> =====================================================================
> --- linux-2.6.git.orig/arch/x86/kernel/cpu/perf_event_p4.c
> +++ linux-2.6.git/arch/x86/kernel/cpu/perf_event_p4.c
> @@ -18,7 +18,7 @@
>  struct p4_event_bind {
>        unsigned int opcode;                    /* Event code and ESCR selector */
>        unsigned int escr_msr[2];               /* ESCR MSR for this event */
> -       unsigned char cntr[2][P4_CNTR_LIMIT];   /* counter index (offset), -1 on abscence */
> +       char cntr[2][P4_CNTR_LIMIT];            /* counter index (offset), -1 on abscence */
>  };
>
>  struct p4_cache_event_bind {
> @@ -747,11 +747,11 @@ static int p4_get_escr_idx(unsigned int
>  static int p4_next_cntr(int thread, unsigned long *used_mask,
>                        struct p4_event_bind *bind)
>  {
> -       int i = 0, j;
> +       int i, j;
>
>        for (i = 0; i < P4_CNTR_LIMIT; i++) {
> -               j = bind->cntr[thread][i++];
> -               if (j == -1 || !test_bit(j, used_mask))
> +               j = bind->cntr[thread][i];
> +               if (j != -1 && !test_bit(j, used_mask))
>                        return j;
>        }
>
>

Yes, this patch fixes the GP issue.

Thanks,
--
Jaswinder Singh.
