Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753601Ab0HTTYY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Aug 2010 15:24:24 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62105 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751050Ab0HTTYV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Aug 2010 15:24:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=WpaK1uWel1tUQ1vKfboeItDuNQ72HmH8sbJJz8p8owZ/Uua+uC9O2NN+FgPjUiJnWL
         UX1Wx0DlnE6dg6ivMJgLriMQWCap6YsFpejuu0gSce7kUr7ysL92MxQ5a4uYF0gdn4x3
         tzcyUzSZMokLt2erxF5jay9rkPXw3eC9MifmM=
MIME-Version: 1.0
In-Reply-To: <tip-05e407603e527f9d808dd3866d3a17c2ce4dfcc5@git.kernel.org>
References: <20100819224616.GB9967@router-fw-old.local.net-space.pl>
	<tip-05e407603e527f9d808dd3866d3a17c2ce4dfcc5@git.kernel.org>
Date: Fri, 20 Aug 2010 12:24:20 -0700
X-Google-Sender-Auth: sngFZwhWa5bHm0W63we4PRxxhMc
Message-ID: <AANLkTim9kjBp68LqieU3MDLbkRDiWLNQjtUvjEbc9Hca@mail.gmail.com>
Subject: Re: [tip:x86/urgent] x86, apic: Fix apic=debug boot crash
From: Yinghai Lu <yinghai@kernel.org>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, dkiper@net-space.pl, mingo@elte.hu
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 20, 2010 at 5:41 AM, tip-bot for Daniel Kiper
<dkiper@net-space.pl> wrote:
> Commit-ID:  05e407603e527f9d808dd3866d3a17c2ce4dfcc5
> Gitweb:     http://git.kernel.org/tip/05e407603e527f9d808dd3866d3a17c2ce4dfcc5
> Author:     Daniel Kiper <dkiper@net-space.pl>
> AuthorDate: Fri, 20 Aug 2010 00:46:16 +0200
> Committer:  Ingo Molnar <mingo@elte.hu>
> CommitDate: Fri, 20 Aug 2010 10:18:28 +0200
>
> x86, apic: Fix apic=debug boot crash
>
> Fix a boot crash when apic=debug is used and the APIC is
> not properly initialized.
>
> This issue appears during Xen Dom0 kernel boot but the
> fix is generic and the crash could occur on real hardware
> as well.

Do you have any report on real hardware?

that could not happen on real hardware.

Yinghai

>
> Signed-off-by: Daniel Kiper <dkiper@net-space.pl>
> Cc: xen-devel@lists.xensource.com
> Cc: konrad.wilk@oracle.com
> Cc: jeremy@goop.org
> Cc: <stable@kernel.org> # .35.x, .34.x, .33.x, .32.x
> LKML-Reference: <20100819224616.GB9967@router-fw-old.local.net-space.pl>
> Signed-off-by: Ingo Molnar <mingo@elte.hu>
> ---
>  arch/x86/kernel/apic/io_apic.c |    2 ++
>  1 files changed, 2 insertions(+), 0 deletions(-)
>
> diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
> index 4dc0084..f1efeba 100644
> --- a/arch/x86/kernel/apic/io_apic.c
> +++ b/arch/x86/kernel/apic/io_apic.c
> @@ -1728,6 +1728,8 @@ __apicdebuginit(void) print_IO_APIC(void)
>                struct irq_pin_list *entry;
>
>                cfg = desc->chip_data;
> +               if (!cfg)
> +                       continue;
>                entry = cfg->irq_2_pin;
>                if (!entry)
>                        continue;
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
