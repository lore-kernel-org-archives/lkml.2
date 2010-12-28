Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab0L1Gdw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Dec 2010 01:33:52 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46892 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752344Ab0L1Gdv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Dec 2010 01:33:51 -0500
MIME-Version: 1.0
X-Originating-IP: [93.172.188.89]
In-Reply-To: <1293452486-notmuch-felipe.contreras@nokia.com>
References: <1292870624-25450-1-git-send-email-felipe.contreras@nokia.com>
 <AANLkTikisHaAMZphRJVYdcokVbaZXVF9COrwkdGTDg__@mail.gmail.com>
 <AANLkTi=9AL3aWUsMeih+Gb-sMov=MgBZ1eTp8wb=q1hZ@mail.gmail.com>
 <AANLkTinX8t=3b48e2sxPU-V_G-nGm_1DyEg6B-CeqXDa@mail.gmail.com> <1293452486-notmuch-felipe.contreras@nokia.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Tue, 28 Dec 2010 08:33:30 +0200
Message-ID: <AANLkTinz0HuhGB_WzTQbK8XkfkGALjtg928WdOUYsySf@mail.gmail.com>
Subject: Re: [PATCH v2] staging: tidspbridge: protect dmm_map properly
To: Felipe Contreras <felipe.contreras@nokia.com>
Cc: linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org, greg@kroah.com,
        omar.ramirez@ti.com, fernando.lugo@ti.com, nm@ti.com,
        ameya.palande@nokia.com, h-kanigeri2@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 27, 2010 at 3:55 PM, Felipe Contreras
<felipe.contreras@nokia.com> wrote:
> So, effectively, serializing the proc_begin_dma() and proc_end_dma()
> would not affect anyone negatively for the time being.

You can never really tell who is using the kernel (or will be using
this kernel version), how and under which workload.

> For the long-term goal I agree with that approach, however, first, I
> think my patch should be applied, since it's fixing a problem using an
> already existing and actively excersised mechanism. In fact, I think
> this should be pushed to 2.6.37 as:
>
>  1) prevents a kernel panic
>  2) the issue is reproducible and clearly identified
>  3) the patch is small and obvious

Both patches are (IMHO). But frankly I don't mind your patch will be
applied now as long as it doesn't stay. I can rebase my patch against
it after it is applied, and send separately.

> This approach looks cleaner, however, we need a flag in
> remove_mapping_information() in order to force the removal, otherwise
> there will be memory leaks. Imagine a process crashes, and
> remove_mapping_information() returns -EBUSY.

Can't happen; both proc_*_dma() operations decrease the reference
count before exiting, so it's not up to the application.

> Sure, but I see this as a broader effort to have finer locking, part of
> this should be to remove the already existing proc_lock.

Having bad locking is not an excuse for adding more.

Anyway, as I said, I don't really mind your patch will be applied as
long as it is a temporary workaround.

Thanks,
Ohad.
