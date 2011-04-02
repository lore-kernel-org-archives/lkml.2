Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab1DBNvT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Apr 2011 09:51:19 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:51684 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751299Ab1DBNvS convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Apr 2011 09:51:18 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=vce43r3fHkyMy7IFTR4ZqKxz7ozXCbmBX/rLpdGdph6qRCDFxiFOi2rcfzizuKFmDP
         hp76luDZRaS/OiH2EEqfToypkzoGT+a+l6/LnU8lkCstNdtT8fcgRA+sdyUbonhexl4t
         tmwBXYoU1HdlnOeRgalrnq/Fo/Tt6A7/LUN2Y=
MIME-Version: 1.0
In-Reply-To: <1301634737-12956-1-git-send-email-tailai.ly@taobao.com>
References: <1301634737-12956-1-git-send-email-tailai.ly@taobao.com>
Date: Sat, 2 Apr 2011 09:51:17 -0400
Message-ID: <AANLkTiniutXFx3rtdSx+ZcicGDO_NXqUPv=63kPV-BNU@mail.gmail.com>
Subject: Re: [PATCH] drm/radeon: Fix an always-false-comparison
From: Alex Deucher <alexdeucher@gmail.com>
To: "'Liu Yuan" <namei.unix@gmail.com>, '@freedesktop.org
Cc: David Airlie <airlied@linux.ie>, Liu Yuan <tailai.ly@taobao.com>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:DRM DRIVERS" <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 1, 2011 at 1:12 AM, 'Liu Yuan <namei.unix@gmail.com> wrote:
> From: Liu Yuan <tailai.ly@taobao.com>
>
> In the function atom_op_delay() of drivers/gpu/drm/radeon/atom.c,
> the comparison performed in the udelay() is always false due to
> that the unsigned-char is compared to an integer 20000.
>

nack.  the delay count is only an 8 bit field.

Alex

> Signed-off-by: Liu Yuan <tailai.ly@taobao.com>
> ---
>  drivers/gpu/drm/radeon/atom.c |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>
> diff --git a/drivers/gpu/drm/radeon/atom.c b/drivers/gpu/drm/radeon/atom.c
> index 258fa5e..e248211 100644
> --- a/drivers/gpu/drm/radeon/atom.c
> +++ b/drivers/gpu/drm/radeon/atom.c
> @@ -648,7 +648,7 @@ static void atom_op_compare(atom_exec_context *ctx, int *ptr, int arg)
>
>  static void atom_op_delay(atom_exec_context *ctx, int *ptr, int arg)
>  {
> -       uint8_t count = U8((*ptr)++);
> +       uint32_t count = U32((*ptr)++);
>        SDEBUG("   count: %d\n", count);
>        if (arg == ATOM_UNIT_MICROSEC)
>                udelay(count);
> --
> 1.7.1
>
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel
>
