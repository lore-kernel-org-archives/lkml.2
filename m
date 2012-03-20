Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759402Ab2CTIhp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 04:37:45 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:39178 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759133Ab2CTIhl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 04:37:41 -0400
MIME-Version: 1.0
In-Reply-To: <1332228453.147584.181533989908.1.gpush@pecola>
References: <1332228453.147584.181533989908.1.gpush@pecola>
Date: Tue, 20 Mar 2012 10:37:39 +0200
Message-ID: <CAJL_dMsTD6P_Ff_4u9mWGJhRvVQr2Ph2zAp3Lwfmz6Z8kgptnQ@mail.gmail.com>
Subject: Re: [PATCH precise] powerpc/pmac: Fix SMP kernels on pre-core99 UP machines
From: Anca Emanuel <anca.emanuel@gmail.com>
To: Jeremy Kerr <jeremy.kerr@canonical.com>
Cc: kernel-team@lists.ubuntu.com, 959959@bugs.launchpad.net,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 20, 2012 at 9:27 AM, Jeremy Kerr <jeremy.kerr@canonical.com> wrote:
> From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>
> BugLink: https://bugs.launchpad.net/bugs/959959
>
> The code for "powersurge" SMP would kick in and cause a crash
> at boot due to the lack of a NULL test.
>
> Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
> Reported-By: Adam Conrad <adconrad@ubuntu.com>
> Tested-By: Adam Conrad <adconrad@ubuntu.com>
>
> Cherry-picked from upstream commit
> 78c5c68a4cf4329d17abfa469345ddf323d4fd62
>
> ---
>  arch/powerpc/platforms/powermac/smp.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/platforms/powermac/smp.c b/arch/powerpc/platforms/powermac/smp.c
> index 9b6a820..3394254 100644
> --- a/arch/powerpc/platforms/powermac/smp.c
> +++ b/arch/powerpc/platforms/powermac/smp.c
> @@ -414,7 +414,7 @@ static struct irqaction psurge_irqaction = {
>
>  static void __init smp_psurge_setup_cpu(int cpu_nr)
>  {
> -       if (cpu_nr != 0)
> +       if (cpu_nr != 0 || !psurge_start)
>                return;
>
>        /* reset the entry point so if we get another intr we won't
>
> --
> kernel-team mailing list
> kernel-team@lists.ubuntu.com
> https://lists.ubuntu.com/mailman/listinfo/kernel-team

Why not CC: lkml ?

It is on the stable channel ? Upstream link please ?
Now you understand Greg's concerns about maintaining a stable kernel ?
