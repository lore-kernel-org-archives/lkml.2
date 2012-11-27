Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755488Ab2K0Oxj (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Nov 2012 09:53:39 -0500
Received: from mx1.redhat.com ([209.132.183.28]:48083 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753280Ab2K0Oxi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Nov 2012 09:53:38 -0500
Date: Tue, 27 Nov 2012 09:55:05 -0500
From: Don Zickus <dzickus@redhat.com>
To: Prasad Koya <prasad.koya@gmail.com>
Cc: aarcange@redhat.com, LKML <linux-kernel@vger.kernel.org>
Subject: Re: vmalloc_sync_all(), 64bit kernel, patches
 9c48f1c629ecfa114850c03f875c6691003214de,
 a79e53d85683c6dd9f99c90511028adc2043031f
Message-ID: <20121127145505.GA14805@redhat.com>
References: <CAGXD9OfAMUmrdFBap3aOYXOhXE6=i8qL7=+SsJYnrdEr3kyMKw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGXD9OfAMUmrdFBap3aOYXOhXE6=i8qL7=+SsJYnrdEr3kyMKw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 26, 2012 at 03:06:53PM -0800, Prasad Koya wrote:
> Hi
> 
> Before going into crashkernel, nmi_shootdown_cpus() calls
> register_die_notifier(), which calls vmalloc_sync_all(). I'm seeing
> lockup in sync_global_pgds() (init_64.c). From 3.2 and up,
> register_die_notifier() is replaced with register_nmi_handler() (patch
> 9c48f1c629ecfa114850c03f875c6691003214de), which doesn't call
> vmalloc_sync_all(). Is it ok to skip vmalloc_sync_all() in this path?
> I see sync_global_pgds() was touched by this patch:
> a79e53d85683c6dd9f99c90511028adc2043031f. There are no virtual
> machines involved and I see lockups at times.

What problems are you seeing?  What are you trying to solve?

Cheers,
Don

> 
> thank you.
> Prasad
> 
> /* Halt all other CPUs, calling the specified function on each of them
>   *
>   * This function can be used to halt all other CPUs on crash
> @@ -794,7 +784,8 @@ void nmi_shootdown_cpus(nmi_shootdown_cb callback)
> 
>         atomic_set(&waiting_for_crash_ipi, num_online_cpus() - 1);
>         /* Would it be better to replace the trap vector here? */
> -       if (register_die_notifier(&crash_nmi_nb))
> +       if (register_nmi_handler(NMI_LOCAL, crash_nmi_callback,
> +                                NMI_FLAG_FIRST, "crash"))
>                 return;         /* return what? */
