Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932407Ab1LOHHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 02:07:21 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:62682 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932261Ab1LOHHR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 02:07:17 -0500
MIME-Version: 1.0
In-Reply-To: <1323244922-2673-1-git-send-email-kengyu@canonical.com>
References: <1323244922-2673-1-git-send-email-kengyu@canonical.com>
Date: Thu, 15 Dec 2011 08:07:15 +0100
Message-ID: <CAHR064iBtSTv79BhXt9_mMWugD4U_xLCM4i1wE7PLnZM8pL57g@mail.gmail.com>
Subject: Re: [PATCH] asus-wmi: explicitly set the wireless LED
From: Corentin Chary <corentin.chary@gmail.com>
To: Keng-Yu Lin <kengyu@canonical.com>
Cc: Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org, Richard Purdie <rpurdie@rpsys.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 7, 2011 at 9:02 AM, Keng-Yu Lin <kengyu@canonical.com> wrote:
> On Asus K54C, the wireless LED is always off without setting explicitly.
>
> Signed-off-by: Keng-Yu Lin <kengyu@canonical.com>
> ---
>  drivers/platform/x86/asus-wmi.c |    3 +++
>  1 files changed, 3 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/platform/x86/asus-wmi.c b/drivers/platform/x86/asus-wmi.c
> index d1049ee..db514c4 100644
> --- a/drivers/platform/x86/asus-wmi.c
> +++ b/drivers/platform/x86/asus-wmi.c
> @@ -726,6 +726,9 @@ static int asus_rfkill_set(void *data, bool blocked)
>        struct asus_rfkill *priv = data;
>        u32 ctrl_param = !blocked;
>
> +       if (priv->dev_id == ASUS_WMI_DEVID_WLAN)
> +               asus_wmi_set_devstate(ASUS_WMI_DEVID_WIRELESS_LED, ctrl_param, NULL);
> +
>        return asus_wmi_set_devstate(priv->dev_id, ctrl_param, NULL);
>  }
>
> --
> 1.7.5.4
>

NACK

If this is only for K54C (works fine on my G73 anyway) then you must
do some kind of DMI matching right ? Or at least check that this led
is present. Do you have any list of laptops that export this LED and
how it behave ?

Anyway, you should use a led trigger for that, ideally the rfkill%d
led trigger, but for that you need the rfkill idx, which is not
exported, so you may need a new rfkill_idx() function. CCing rfkill
and led guys, they may have a better advice on that.
-- 
Corentin Chary
http://xf.iksaif.net
