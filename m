Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755630Ab0IHRDl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 13:03:41 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:36870 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927Ab0IHRD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 13:03:28 -0400
Date: Wed, 8 Sep 2010 18:03:20 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Alex Deucher <alexdeucher@gmail.com>
Cc: linux-kernel@vger.kernel.org,
        Michel =?iso-8859-1?Q?D=E4nzer?= <michel@daenzer.net>,
        dri-devel@lists.freedesktop.org,
        Michel =?iso-8859-1?Q?D=E4nzer?= <daenzer@vmware.com>
Subject: Re: [PATCH] radeon: Expose backlight class device for legacy LVDS
	encoder
Message-ID: <20100908170320.GA4888@srcf.ucam.org>
References: <1283963539-4039-1-git-send-email-mjg@redhat.com> <1283963539-4039-3-git-send-email-mjg@redhat.com> <AANLkTi=kDXwRPxfbLv=EGEqARfTkhuhRBrXUL9DOQ_zw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTi=kDXwRPxfbLv=EGEqARfTkhuhRBrXUL9DOQ_zw@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 08, 2010 at 12:58:32PM -0400, Alex Deucher wrote:

> The only problem with this is that not all oems use the internal
> backlight controller; systems that don't need to use the acpi methods.

That's why we expose the backlight type. Userspace should use the acpi 
or platform mechanism when available, with this being a last-ditch 
fallback.

>  On atombios systems there is a bit in the
> ATOM_FIRMWARE_CAPABILITY_ACCESS struct in the FirmwareInfo data table
> to determine whether the backlight is controlled by the GPU or some
> external mechanism.  Combios may have something similar.  If the
> backlight is controlled via the GPU, it can be adjusting using the
> atom OutputControl and TransmitterControl control tables depending on
> the GPU family.  However, if the driver chooses to control the
> backlight itself, it needs to set the appropriate bit in the bios
> scratch regs to tell the firmware not to attempt to change the
> backlight itself.

If there's support for probing this more reliably then I'm all for that, 
but I'm not keen on taking over control if the BIOS has previous 
asserted it.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
