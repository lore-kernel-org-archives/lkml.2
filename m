Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754627Ab2K2NFh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 08:05:37 -0500
Received: from mail-ea0-f174.google.com ([209.85.215.174]:41245 "EHLO
	mail-ea0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754538Ab2K2NFg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 08:05:36 -0500
MIME-Version: 1.0
In-Reply-To: <20121128175140.46ce7547.akpm@linux-foundation.org>
References: <1353508271-30646-1-git-send-email-andriy.shevchenko@linux.intel.com>
	<20121128175140.46ce7547.akpm@linux-foundation.org>
Date: Thu, 29 Nov 2012 15:05:33 +0200
Message-ID: <CAHp75VcNiZiAJuDfCxjWo9TAz4ottS+30L6_d4UD59jpBsw9Vg@mail.gmail.com>
Subject: Re: [PATCH, resend] kfifo: initialize fifo accordingly to C99 standard
From: Andy Shevchenko <andy.shevchenko@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        linux-kernel@vger.kernel.org, Stefani Seibold <stefani@seibold.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 3:51 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Wed, 21 Nov 2012 16:31:11 +0200
> Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:
>
>> When build a kernel with "make W=1" we will get a warning about missing
>> initializer. It comes from kfifo usage style. The DEFINE_KFIFO macro doesn't
>> initialize the buf[] field of the fifo structure. So, using C99 style helps in
>> such case.
>
> This doesn't actually work:
>
> drivers/pci/pcie/aer/aerdrv_core.c:573: error: unknown field 'kfifo' specified in initializer
> drivers/pci/pcie/aer/aerdrv_core.c:573: error: unknown field 'in' specified in initializer
> drivers/pci/pcie/aer/aerdrv_core.c:573: warning: missing braces around initializer
> drivers/pci/pcie/aer/aerdrv_core.c:573: warning: (near initialization for '(anonymous).<anonymous>.kfifo')
> drivers/pci/pcie/aer/aerdrv_core.c:573: error: unknown field 'out' specified in initializer

It's strange. After I reverted the mentioned commit (about
Makefile.build) and applied my patch I got no warnings
  CC [M]  samples/kfifo/inttype-example.o
  CC [M]  samples/kfifo/record-example.o

> gcc-4.4.4.

gcc 4.7.2 might be the case.

-- 
With Best Regards,
Andy Shevchenko
