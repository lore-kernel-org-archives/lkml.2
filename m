Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751962Ab1LHH6L (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Dec 2011 02:58:11 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:53766 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751829Ab1LHH6I convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Dec 2011 02:58:08 -0500
MIME-Version: 1.0
X-Originating-IP: [109.186.57.177]
In-Reply-To: <1319536106-25802-5-git-send-email-ohad@wizery.com>
References: <1319536106-25802-1-git-send-email-ohad@wizery.com> <1319536106-25802-5-git-send-email-ohad@wizery.com>
From: Ohad Ben-Cohen <ohad@wizery.com>
Date: Thu, 8 Dec 2011 09:57:43 +0200
Message-ID: <CAK=WgbZvH3eiouryKDenC_x0LdDcHFuumhfoeY4ueiwT5r0cxA@mail.gmail.com>
Subject: Re: [PATCH 4/7] amp/omap: add a remoteproc driver
To: linux-omap@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Tony Lindgren <tony@atomide.com>
Cc: akpm@linux-foundation.org, Brian Swetland <swetland@google.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rusty Russell <rusty@rustcorp.com.au>,
        Russell King <linux@arm.linux.org.uk>, Greg KH <greg@kroah.com>,
        Stephen Boyd <sboyd@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tony,

On Tue, Oct 25, 2011 at 11:48 AM, Ohad Ben-Cohen <ohad@wizery.com> wrote:
> Add a remoteproc driver for OMAP4, so we can boot the dual-M3 "Ducati"
> and DSP subsystems.
>
> Use the omap_device_* API to control the hardware state, and utilize
> the OMAP mailbox to interrupt the remote processor when a new message
> is pending (the mailbox payload is used to tell it which virtqueue was
> the message placed in).
>
> Conversely, when an inbound mailbox message arrives, tell the remoteproc
> core which virtqueue is triggered.
>
> Later we will also use the mailbox payload to signal omap-specific
> events like remote crashes (which will be used to trigger remoteproc
> recovery) and power management transitions. At that point we will also
> extend the remoteproc core to support this.
>
> Based on (but now quite far from) work done by Fernando Guzman Lugo
> <fernando.lugo@ti.com> and Hari Kanigeri <h-kanigeri2@ti.com>.
>
> Designed with Brian Swetland <swetland@google.com>.
>
> Signed-off-by: Ohad Ben-Cohen <ohad@wizery.com>
> Cc: Brian Swetland <swetland@google.com>
> Cc: Arnd Bergmann <arnd@arndb.de>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Tony Lindgren <tony@atomide.com>
> Cc: Russell King <linux@arm.linux.org.uk>
> Cc: Rusty Russell <rusty@rustcorp.com.au>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Greg KH <greg@kroah.com>
> Cc: Stephen Boyd <sboyd@codeaurora.org>
> ---
>  arch/arm/plat-omap/include/plat/remoteproc.h |   56 ++++++
>  drivers/amp/remoteproc/Kconfig               |   21 +++
>  drivers/amp/remoteproc/Makefile              |    4 +-
>  drivers/amp/remoteproc/omap_remoteproc.c     |  248 ++++++++++++++++++++++++++
>  drivers/amp/remoteproc/omap_remoteproc.h     |   69 +++++++
>  5 files changed, 397 insertions(+), 1 deletions(-)
>  create mode 100644 arch/arm/plat-omap/include/plat/remoteproc.h
>  create mode 100644 drivers/amp/remoteproc/omap_remoteproc.c
>  create mode 100644 drivers/amp/remoteproc/omap_remoteproc.h

I'm about to add this to linux-next (minus the 'amp' wording); can I
please have your Acked-by for this (at least for the plat-omap change) ?

Thanks,
Ohad.
