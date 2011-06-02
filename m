Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933289Ab1FBJn3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 05:43:29 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:40881 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932843Ab1FBJn1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 05:43:27 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=PpcsDab62A6XPJNkg9M/Xv/iqii/NWozdmV99/tCIlAMmtf6jSqA/Lvitvhwtk/pk8
         4W8pPP0e/uIG/mPjcvL3UQcfKOtNkWbYCGUoIC//6YC9qmQ5bPbpOzgq3BrGfu7/EstV
         A88+MexuAdXp4AEr5jSoOvrsOnk3H5XpzZ4uE=
MIME-Version: 1.0
In-Reply-To: <1307006687-12736-1-git-send-email-ike.pan@canonical.com>
References: <1307006553-12667-1-git-send-email-ike.pan@canonical.com>
	<1307006687-12736-1-git-send-email-ike.pan@canonical.com>
Date: Thu, 2 Jun 2011 11:43:25 +0200
Message-ID: <BANLkTimfu3pWedHJXtuV-q5risHTyQzNKOaR8P471jmsPfzODg@mail.gmail.com>
Subject: Re: [PATCH 3/3] ideapad: Show negative when no camera
From: Corentin Chary <corentin.chary@gmail.com>
To: Ike Panhc <ike.pan@canonical.com>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 2, 2011 at 11:24 AM, Ike Panhc <ike.pan@canonical.com> wrote:
> Signed-off-by: Ike Panhc <ike.pan@canonical.com>
> ---
>  drivers/platform/x86/ideapad-laptop.c |    5 +++++
>  1 files changed, 5 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
> index 9c09891..4a54ed1 100644
> --- a/drivers/platform/x86/ideapad-laptop.c
> +++ b/drivers/platform/x86/ideapad-laptop.c
> @@ -38,6 +38,7 @@
>  #define CFG_BT_BIT     (16)
>  #define CFG_3G_BIT     (17)
>  #define CFG_WIFI_BIT   (18)
> +#define CFG_CAMERA_BIT (19)
>
>  struct ideapad_private {
>        struct rfkill *rfk[IDEAPAD_RFKILL_DEV_NUM];
> @@ -199,6 +200,10 @@ static ssize_t show_ideapad_cam(struct device *dev,
>                                struct device_attribute *attr,
>                                char *buf)
>  {
> +       struct ideapad_private *priv = dev_get_drvdata(dev);
> +
> +       if (!test_bit(CFG_CAMERA_BIT, &(priv->cfg)))
> +               return sprintf(buf, "-1\n");
>        return show_ideapad_helper(dev, attr, buf, 0x1D);
>  }
>
> --
> 1.7.4.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe platform-driver-x86" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

I think it would be better to not add the file when the camera is not
available. Another option is to return -ENODEV. But printing -1
doesn't seems right.

-- 
Corentin Chary
http://xf.iksaif.net
