Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932425Ab1AKQmX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jan 2011 11:42:23 -0500
Received: from gretel.risen.be ([78.46.99.137]:52167 "EHLO gretel.risen.be"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932209Ab1AKQmU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jan 2011 11:42:20 -0500
Message-ID: <4D2C8864.8030909@aquazul.com>
Date: Tue, 11 Jan 2011 17:42:12 +0100
From: Mourad De Clerck <mourad@aquazul.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101213 Icedove/3.1.7
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: Richard Purdie <rpurdie@linux.intel.com>, linux-kernel@vger.kernel.org,
        Matthew Garrett <mjg@redhat.com>, Richard Hughes <richard@hughsie.com>
Subject: mbp_nvidia_bl: Remove DMI dependency (was: Re: [PATCH,RESEND] backlight:
 mbp_nvidia_bl - add support for MacBookPro7,1)
References: <4D145EB5.7090205@aquazul.com> <20110104143651.8f6d62e0.akpm@linux-foundation.org>
In-Reply-To: <20110104143651.8f6d62e0.akpm@linux-foundation.org>
X-Enigmail-Version: 1.1.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/11 23:36, Andrew Morton wrote:
> I applied this, and now I'll unapply it because Matthew's patch series
> "mbp_nvidia_bl: Remove DMI dependency" appears to make your change
> obsolete.
> 
> I'll cc you on those three patches - it will be great if you are able
> to find time to test them, thanks.

A bit late, but I tested this patch series and it works for me.

The only slight change is that gnome-power-manager needs to be updated
to use /sys/class/backlight/apple_backlight instead of mbp_backlight.

Thanks,

Mourad

PS: something like this, maybe?
--
diff --git a/src/gpm-backlight-helper.c b/src/gpm-backlight-helper.c
index 27aed09..a8ef608 100644
--- a/src/gpm-backlight-helper.c
+++ b/src/gpm-backlight-helper.c
@@ -58,6 +58,7 @@ gcm_backlight_helper_get_best_backlight ()
                "thinkpad_screen",
                "acpi_video1",
                "mbp_backlight",
+               "apple_backlight",
                "acpi_video0",
                "fujitsu-laptop",
                "sony",
