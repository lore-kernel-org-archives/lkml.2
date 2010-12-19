Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932488Ab0LSWKF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Dec 2010 17:10:05 -0500
Received: from smtp-out002.kontent.com ([81.88.40.216]:35063 "EHLO
	smtp-out002.kontent.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932078Ab0LSWKD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Dec 2010 17:10:03 -0500
X-Greylist: delayed 812 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Dec 2010 17:10:03 EST
From: Oliver Neukum <oliver@neukum.org>
To: Robert Morell <rmorell@nvidia.com>
Subject: Re: [PATCH 2/2] USB: ehci: tegra: Align DMA transfers to 32 bytes
Date: Sun, 19 Dec 2010 22:57:48 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc7neuxhcipm-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: David Brownell <dbrownell@users.sourceforge.net>,
        "Greg Kroah-Hartman" <gregkh@suse.de>,
        Benoit Goby <benoit@android.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Matthew Wilcox <willy@linux.intel.com>,
        Ming Lei <tom.leiming@gmail.com>, Jacob Pan <jacob.jun.pan@intel.com>,
        Olof Johansson <olof@lixom.net>, Erik Gilling <konkers@android.com>,
        Colin Cross <ccross@android.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
References: <1292636971-17701-1-git-send-email-rmorell@nvidia.com> <1292794698-19534-3-git-send-email-rmorell@nvidia.com>
In-Reply-To: <1292794698-19534-3-git-send-email-rmorell@nvidia.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201012192257.48704.oliver@neukum.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag, 19. Dezember 2010, 22:38:18 schrieb Robert Morell:
> +static int tegra_ehci_map_urb_for_dma(struct usb_hcd *hcd, struct urb *urb,
> +                                     gfp_t mem_flags)
> +{
> +       int ret;
> +
> +       ret = alloc_temp_buffer(urb, mem_flags);
> +       if (ret)
> +               return ret;
> +
> +       ret = usb_hcd_map_urb_for_dma(hcd, urb, mem_flags);
> +       if (ret)
> +               free_temp_buffer(urb);

Using free_temp_buffer() in the error case looks like a bad
idea, as you'd execute the memcpy if the direction tells you to.

	Regards
		Oliver
