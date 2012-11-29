Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab2K2Bvn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 20:51:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33324 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab2K2Bvm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 20:51:42 -0500
Date: Wed, 28 Nov 2012 17:51:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: linux-kernel@vger.kernel.org, Stefani Seibold <stefani@seibold.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH, resend] kfifo: initialize fifo accordingly to C99
 standard
Message-Id: <20121128175140.46ce7547.akpm@linux-foundation.org>
In-Reply-To: <1353508271-30646-1-git-send-email-andriy.shevchenko@linux.intel.com>
References: <1353508271-30646-1-git-send-email-andriy.shevchenko@linux.intel.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 21 Nov 2012 16:31:11 +0200
Andy Shevchenko <andriy.shevchenko@linux.intel.com> wrote:

> When build a kernel with "make W=1" we will get a warning about missing
> initializer. It comes from kfifo usage style. The DEFINE_KFIFO macro doesn't
> initialize the buf[] field of the fifo structure. So, using C99 style helps in
> such case.

This doesn't actually work:

drivers/pci/pcie/aer/aerdrv_core.c:573: error: unknown field 'kfifo' specified in initializer
drivers/pci/pcie/aer/aerdrv_core.c:573: error: unknown field 'in' specified in initializer
drivers/pci/pcie/aer/aerdrv_core.c:573: warning: missing braces around initializer
drivers/pci/pcie/aer/aerdrv_core.c:573: warning: (near initialization for '(anonymous).<anonymous>.kfifo')
drivers/pci/pcie/aer/aerdrv_core.c:573: error: unknown field 'out' specified in initializer

gcc-4.4.4.
