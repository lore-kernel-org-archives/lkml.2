Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752874Ab1F0Qyk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 12:54:40 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:39989 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab1F0Qyi convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 12:54:38 -0400
MIME-Version: 1.0
In-Reply-To: <1309192426.17574.47.camel@vivanov>
References: <1309192426.17574.47.camel@vivanov>
From: Grant Likely <grant.likely@secretlab.ca>
Date: Mon, 27 Jun 2011 10:54:17 -0600
X-Google-Sender-Auth: IPDxzkGhZC8d4rK8G4IzD2LnADI
Message-ID: <BANLkTik3fNOqsiDaDt=HhDw1DVsBBJFX1Q@mail.gmail.com>
Subject: Re: [PATCH] treewide: fix kernel-doc warnings
To: Vitaliy Ivanov <vitalivanov@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jiri Kosina <jkosina@suse.cz>, "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 27, 2011 at 10:33 AM, Vitaliy Ivanov <vitalivanov@gmail.com> wrote:
> Fixing 'make htmldocs' warnings:
>
> Warning(/include/linux/hrtimer.h:153): No description found for parameter 'clockid'
> Warning(/include/linux/device.h:604): Excess struct/union/enum/typedef member 'of_match' description in 'device'
> Warning(/include/net/sock.h:349): Excess struct/union/enum/typedef member 'sk_rmem_alloc' description in 'sock'
>
> Issue with:
> Warning(/include/net/wimax.h:432): No description found for parameter 'rfkill_input'
> is already solved in net-next tree -
> commit #c6af9c406ceb3434281cf230938453931dcbab75 - net: wimax: Remove of unused 'rfkill_input' pointer.
>
> Patch is against latest Linus' tree.
>
> ---
> >From 55fe3701d1ed1f1302a73cd5bfdfc7972e89f5b7 Mon Sep 17 00:00:00 2001
> From: Vitaliy Ivanov <vitalivanov@gmail.com>
> Date: Mon, 27 Jun 2011 19:07:08 +0300
> Subject: [PATCH] treewide: fix kernel-doc warnings
>
> Fix 'make htmldocs' warnings:
>
> Warning(/include/linux/hrtimer.h:153): No description found for
> parameter 'clockid'
> Warning(/include/linux/device.h:604): Excess struct/union/enum/typedef
> member 'of_match' description in 'device'
> Warning(/include/net/sock.h:349): Excess struct/union/enum/typedef
> member 'sk_rmem_alloc' description in 'sock'
>
> Signed-off-by: Vitaliy Ivanov <vitalivanov@gmail.com>
> ---
>  include/linux/device.h  |    1 -
>  include/linux/hrtimer.h |    1 +
>  include/net/sock.h      |    1 -
>  3 files changed, 1 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/device.h b/include/linux/device.h
> index 553fd37..e4f62d8 100644
> --- a/include/linux/device.h
> +++ b/include/linux/device.h
> @@ -530,7 +530,6 @@ struct device_dma_parameters {
>  * @dma_mem:   Internal for coherent mem override.
>  * @archdata:  For arch-specific additions.
>  * @of_node:   Associated device tree node.
> - * @of_match:  Matching of_device_id from driver.
>  * @devt:      For creating the sysfs "dev".
>  * @devres_lock: Spinlock to protect the resource of the device.
>  * @devres_head: The resources list of the device.

Acked-by: Grant Likely <grant.likely@secretlab.ca>

> diff --git a/include/linux/hrtimer.h b/include/linux/hrtimer.h
> index 51932e5..fd0dc30 100644
> --- a/include/linux/hrtimer.h
> +++ b/include/linux/hrtimer.h
> @@ -135,6 +135,7 @@ struct hrtimer_sleeper {
>  * @cpu_base:          per cpu clock base
>  * @index:             clock type index for per_cpu support when moving a
>  *                     timer to a base on another cpu.
> + * @clockid:           clock id for per_cpu support
>  * @active:            red black tree root node for the active timers
>  * @resolution:                the resolution of the clock, in nanoseconds
>  * @get_time:          function to retrieve the current time of the clock
> diff --git a/include/net/sock.h b/include/net/sock.h
> index f2046e4..c0b938c 100644
> --- a/include/net/sock.h
> +++ b/include/net/sock.h
> @@ -178,7 +178,6 @@ struct sock_common {
>   *    @sk_dst_cache: destination cache
>   *    @sk_dst_lock: destination cache lock
>   *    @sk_policy: flow policy
> -  *    @sk_rmem_alloc: receive queue bytes committed
>   *    @sk_receive_queue: incoming packets
>   *    @sk_wmem_alloc: transmit queue bytes committed
>   *    @sk_write_queue: Packet sending queue
> --
> 1.7.0.4
>
>
>
>



-- 
Grant Likely, B.Sc., P.Eng.
Secret Lab Technologies Ltd.
