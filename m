Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759473Ab1D3AIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Apr 2011 20:08:15 -0400
Received: from kroah.org ([198.145.64.141]:54113 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759202Ab1D3AHr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Apr 2011 20:07:47 -0400
Date: Fri, 29 Apr 2011 16:40:28 -0700
From: Greg KH <greg@kroah.com>
To: Mike Waychison <mikew@google.com>
Cc: Matt Domsch <Matt_Domsch@dell.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Duncan Laurie <dlaurie@google.com>, Aaron Durbin <adurbin@google.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Tim Hockin <thockin@google.com>, San Mehat <san@google.com>
Subject: Re: [PATCH v4 1/3] driver: Google EFI SMI
Message-ID: <20110429234028.GA28476@kroah.com>
References: <20110429212328.GA19207@kroah.com>
 <20110429225551.22013.65012.stgit@mike.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20110429225551.22013.65012.stgit@mike.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 29, 2011 at 03:55:51PM -0700, Mike Waychison wrote:
> The "gsmi" driver bridges userland with firmware specific routines for
> accessing hardware.
> 
> Currently, this driver only supports NVRAM and eventlog information.
> Deprecated functions have been removed from the driver, though their
> op-codes are left in place so that they are not re-used.
> 
> This driver works by trampolining into the firmware via the smi_command
> outlined in the FADT table.  Three protocols are used due to various
> limitations over time, but all are included herein.
> 
> This driver should only ever load on Google boards, identified by either
> a "Google, Inc." board vendor string in DMI, or "GOOGLE" in the OEM
> strings of the FADT ACPI table.  This logic happens in
> gsmi_system_valid().
> 
> Signed-off-by: Duncan Laurie <dlaurie@google.com>
> Signed-off-by: Aaron Durbin <adurbin@google.com>
> Signed-off-by: Mike Waychison <mikew@google.com>

{sigh}

I now get this build error with this patch applied:

 CC [M]  drivers/firmware/google/gsmi.o
drivers/firmware/google/gsmi.c: In function ‘gsmi_die_callback’:
drivers/firmware/google/gsmi.c:660:16: error: ‘DIE_NMIWATCHDOG’ undeclared (first use in this function)
drivers/firmware/google/gsmi.c:660:16: note: each undeclared identifier is reported only once for each function it appears in
make[3]: *** [drivers/firmware/google/gsmi.o] Error 1


Also, I had to hand edit the drivers/firmware/Makefile and Kconfig parts
of this patch to get it to apply, care to respin it against the
linux-next tree so I don't have to do that next time around?

thanks,

greg k-h
