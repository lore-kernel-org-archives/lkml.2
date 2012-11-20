Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab2KTQrT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 11:47:19 -0500
Received: from mail-oa0-f46.google.com ([209.85.219.46]:62985 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751849Ab2KTQrS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 11:47:18 -0500
MIME-Version: 1.0
In-Reply-To: <1353356251.19434.22.camel@x61.thuisdomein>
References: <1353356251.19434.22.camel@x61.thuisdomein>
Date: Tue, 20 Nov 2012 11:47:17 -0500
Message-ID: <CADnq5_MEatoOUH5x6FYa1rB03p9goirDShOq=fOmoeZfWwsVnw@mail.gmail.com>
Subject: Re: [PATCH] radeon: add AGPMode 1 quirk for RV250
From: Alex Deucher <alexdeucher@gmail.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: David Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 19, 2012 at 3:17 PM, Paul Bolle <pebolle@tiscali.nl> wrote:
> The Intel 82855PM host bridge / Mobility FireGL 9000 RV250 combination
> in an (outdated) ThinkPad T41 needs AGPMode 1 for suspend/resume (under
> KMS, that is). So add a quirk for it.
>
> (Change R250 to RV250 in comment for preceding quirk too.)
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

Thanks, added to my -fixes queue.

Alex

> ---
> 0) Last tested on v3.6.7. The patch was cherry-picked on top of
> v3.7-rc6.
>
> 1) A similar patch was submitted twenty months ago via
> https://bugzilla.redhat.com/show_bug.cgi?id=531825 , but nothing
> happened after that.
>
>  drivers/gpu/drm/radeon/radeon_agp.c |    5 ++++-
>  1 files changed, 4 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_agp.c b/drivers/gpu/drm/radeon/radeon_agp.c
> index 10ea17a..4243334 100644
> --- a/drivers/gpu/drm/radeon/radeon_agp.c
> +++ b/drivers/gpu/drm/radeon/radeon_agp.c
> @@ -69,9 +69,12 @@ static struct radeon_agpmode_quirk radeon_agpmode_quirk_list[] = {
>         /* Intel 82830 830 Chipset Host Bridge / Mobility M6 LY Needs AGPMode 2 (fdo #17360)*/
>         { PCI_VENDOR_ID_INTEL, 0x3575, PCI_VENDOR_ID_ATI, 0x4c59,
>                 PCI_VENDOR_ID_DELL, 0x00e3, 2},
> -       /* Intel 82852/82855 host bridge / Mobility FireGL 9000 R250 Needs AGPMode 1 (lp #296617) */
> +       /* Intel 82852/82855 host bridge / Mobility FireGL 9000 RV250 Needs AGPMode 1 (lp #296617) */
>         { PCI_VENDOR_ID_INTEL, 0x3580, PCI_VENDOR_ID_ATI, 0x4c66,
>                 PCI_VENDOR_ID_DELL, 0x0149, 1},
> +       /* Intel 82855PM host bridge / Mobility FireGL 9000 RV250 Needs AGPMode 1 for suspend/resume */
> +       { PCI_VENDOR_ID_INTEL, 0x3340, PCI_VENDOR_ID_ATI, 0x4c66,
> +               PCI_VENDOR_ID_IBM, 0x0531, 1},
>         /* Intel 82852/82855 host bridge / Mobility 9600 M10 RV350 Needs AGPMode 1 (deb #467460) */
>         { PCI_VENDOR_ID_INTEL, 0x3580, PCI_VENDOR_ID_ATI, 0x4e50,
>                 0x1025, 0x0061, 1},
> --
> 1.7.7.6
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
