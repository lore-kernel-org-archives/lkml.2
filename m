Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758827Ab2KVXE5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 18:04:57 -0500
Received: from mail-pa0-f46.google.com ([209.85.220.46]:39452 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752271Ab2KVS26 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:28:58 -0500
Date: Thu, 22 Nov 2012 10:24:51 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: arnd@arndb.de,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] drivers/char: in hpet.c, check for hdp->hd_nirqs
Message-ID: <20121122182451.GD25392@kroah.com>
References: <50ADAF18.7090404@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50ADAF18.7090404@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 22, 2012 at 12:50:32PM +0800, Chen Gang wrote:
> Hello Arnd Bergmann, Greg Kroah-Hartman
> 
>   in drivers/char/hpet.c:1009
>     I suggest to add check for hdp->hd_nirqs whether equal or larger than 32 (HPET_MAX_TIMERS)
>       the type of irqp->interrupt_count is u8 (include/acpi/acrestyp.h:349)
>       the type of hdp->hd_irq is "unsigned int hd_irq[HPET_MAX_TIMERS]" (include/linux/hpet.h:99)
>       #define HPET_MAX_TIMERS (32) (include/linux/hpet.h:38)
> 
>   additional information:
>     acpi_register_gsi() not check the boundaries of how many irqs (at least, unlimited for u8).
>     maybe (only maybe) the irqp->interrupt_count is always less than 32 by hardware limitation.
>     I do not know whether it is a bug, so as a suggestion.

Care to send a patch that implements this?

thanks,

greg k-h
