Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753752Ab1JYVvS (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 17:51:18 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:44637 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753653Ab1JYVvR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 17:51:17 -0400
MIME-Version: 1.0
In-Reply-To: <4EA6A24D.1000400@scalemp.com>
References: <4EA6695C.1000904@scalemp.com>
	<9B14D1490DDECA4E974F6B9FC9EBAB3140CD274366@VMBX108.ihostexchange.net>
	<4EA699B5.4030008@scalemp.com>
	<9B14D1490DDECA4E974F6B9FC9EBAB3140CD27436C@VMBX108.ihostexchange.net>
	<4EA6A24D.1000400@scalemp.com>
Date: Tue, 25 Oct 2011 14:51:16 -0700
X-Google-Sender-Auth: pocpTm3jaRbUy2GgJAh9jtoXay4
Message-ID: <CAE9FiQUrq-3GDhaZS8gOL5NBHF-ZcWjHiWWUYP4AdM2+q_12Ow@mail.gmail.com>
Subject: Re: [PATCH] AMD: modify cpu probe from APICID to initial APICID
From: Yinghai Lu <yinghai@kernel.org>
To: Eial Czerwacki <eial@scalemp.com>
Cc: linux-kernel@vger.kernel.org,
        "Shai Fultheim (Shai@ScaleMP.com)" <Shai@scalemp.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 25, 2011 at 4:49 AM, Eial Czerwacki <eial@scalemp.com> wrote:
> Make AMD probe processors using APICID rather than the initial APICID.
>
>
> Signed-off-by: Eial Czerwacki<eial@scalemp.com>
> Signed-off-by: Shai Fultheim<shai@scalemp.com>
> ---
>
> --- a/arch/x86/kernel/cpu/amd.c 2011-09-14 05:58:19.542910736 -0700
> +++ b/arch/x86/kernel/cpu/amd.c 2011-09-14 06:01:41.493209624 -0700
> @@ -299,9 +299,9 @@ static void __cpuinit amd_detect_cmp(str
>
>        bits = c->x86_coreid_bits;
>        /* Low order bits define the core id (index of core in socket) */
> -       c->cpu_core_id = c->initial_apicid&    ((1<<    bits)-1);
> +       c->cpu_core_id = c->apicid&    ((1<<    bits)-1);
>        /* Convert the initial APIC ID into the socket ID */
> -       c->phys_proc_id = c->initial_apicid>>    bits;
> +       c->phys_proc_id = c->apicid>>    bits;
>        /* use socket ID also for last level cache */
>        per_cpu(cpu_llc_id, cpu) = c->phys_proc_id;
>        /* fixup topology information on multi-node processors */
>

No, that is not right.

We have to initial apicid to get socket/core mapping.

BTW, your mail client has some problem with formatting.

Thanks

Yinghai
