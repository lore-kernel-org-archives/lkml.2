Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2993472Ab2KOOh2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 09:37:28 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:34293 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993437Ab2KOOh0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 09:37:26 -0500
Date: Thu, 15 Nov 2012 14:37:18 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Andrew Murray <amurray@embedded-bits.co.uk>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, linus.walleij@stericsson.com,
        jonas.aberg@stericsson.com, will.deacon@arm.com, arnd@arndb.de,
        Mian Yousaf Kaukab <mian.yousaf.kaukab@stericsson.com>
Subject: Re: [PATCH 1/2] Boottime: A tool for automatic measurement of
 kernel/bootloader boot time
Message-ID: <20121115143718.GB14476@gmail.com>
References: <1352973847-21605-1-git-send-email-lee.jones@linaro.org>
 <1352973847-21605-2-git-send-email-lee.jones@linaro.org>
 <CAPcvp5ER_rMnyzbKR8r8NJf_naNs6y8gBi0jg5TtOwq88Xgh9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAPcvp5ER_rMnyzbKR8r8NJf_naNs6y8gBi0jg5TtOwq88Xgh9Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 15 Nov 2012, Andrew Murray wrote:

> On 15 November 2012 10:04, Lee Jones <lee.jones@linaro.org> wrote:
> > The overhead is very low and the results will be found under
> > sysfs/bootime, as well as detailed results in debugfs under
> > boottime/. The bootgraph* files are compatible with
> > scripts/bootgraph.pl. The reason for this patch is to provide
> > data (sysfs/boottime) suitable for automatic test-cases as
> > well as help for developers to reduce the boot time (debugfs).
> >
> > Based heavily on the original driver by Jonas Aaberg.
> >
> 
> > +
> > +static LIST_HEAD(boottime_list);
> > +static DEFINE_SPINLOCK(boottime_list_lock);
> > +static struct boottime_timer boottime_timer;
> > +static int num_const_boottime_list;
> > +static struct boottime_list const_boottime_list[NUM_STATIC_BOOTTIME_ENTRIES];
> > +static unsigned long time_kernel_done;
> > +static unsigned long time_bootloader_done;
> > +static bool system_up;
> > +static bool boottime_done;
> > +
> > +int __attribute__((weak)) boottime_arch_startup(void)
> > +{
> > +       return 0;
> > +}
> > +
> > +int __attribute__((weak)) boottime_bootloader_idle(void)
> > +{
> > +       return 0;
> > +}
> 
> You may wish to use the __weak macro (include/linux/compiler*) instead
> of directly using GCC attributes here.

Can do, thanks Andy.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
