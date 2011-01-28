Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753512Ab1A1XDa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Jan 2011 18:03:30 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:33102 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752763Ab1A1XD3 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Jan 2011 18:03:29 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=jZ3RpZgGQnNkAh+OkV1CIBRpMb8FHRM1SmTsehrwXJjYQMzu04KpmgxkQsfn/m37+A
         5kBJWboHngYlddRtAkJwW2kFnzOlt7a9bg5AUnpogv/LIUYn18eqhDxVCG/qSg+LRSme
         a3firMwVuOwYHO7OaGuO59ihzPxeTR0z/XTdo=
MIME-Version: 1.0
In-Reply-To: <1296254118-7845-1-git-send-email-weil@mail.berlios.de>
References: <1296254118-7845-1-git-send-email-weil@mail.berlios.de>
Date: Fri, 28 Jan 2011 18:03:27 -0500
Message-ID: <AANLkTikVDKwqpNXZnLARA+-20-Gx7McZL6O=fro0RZiw@mail.gmail.com>
Subject: Re: [PATCH] radeon: Fix wrong boolean operator
From: Alex Deucher <alexdeucher@gmail.com>
To: Stefan Weil <weil@mail.berlios.de>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 28, 2011 at 5:35 PM, Stefan Weil <weil@mail.berlios.de> wrote:
> This error is reported by cppcheck:
> drivers/gpu/drm/radeon/radeon_encoders.c:1066: warning: Mutual exclusion over || always evaluates to true. Did you intend to use && instead?

Yes, should be &&.

Thanks,

Reviewed-by: Alex Deucher <alexdeucher@gmail.com>

>
> It looks like cppcheck is correct, so fix this. No test was run.
>
> Cc: David Airlie <airlied@linux.ie>
> Cc: Alex Deucher <alexdeucher@gmail.com>
> Cc: dri-devel@lists.freedesktop.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Stefan Weil <weil@mail.berlios.de>
> ---
>  drivers/gpu/drm/radeon/radeon_encoders.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/radeon_encoders.c b/drivers/gpu/drm/radeon/radeon_encoders.c
> index 5e90984..d4a5422 100644
> --- a/drivers/gpu/drm/radeon/radeon_encoders.c
> +++ b/drivers/gpu/drm/radeon/radeon_encoders.c
> @@ -1063,7 +1063,7 @@ atombios_set_edp_panel_power(struct drm_connector *connector, int action)
>        if (!ASIC_IS_DCE4(rdev))
>                return;
>
> -       if ((action != ATOM_TRANSMITTER_ACTION_POWER_ON) ||
> +       if ((action != ATOM_TRANSMITTER_ACTION_POWER_ON) &&
>            (action != ATOM_TRANSMITTER_ACTION_POWER_OFF))
>                return;
>
> --
> 1.7.2.3
>
>
