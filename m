Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757145Ab1DGXNQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Apr 2011 19:13:16 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:57309 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757107Ab1DGXNP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Apr 2011 19:13:15 -0400
Date: Thu, 7 Apr 2011 16:12:39 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arthur Taylor <art@ified.ca>
Cc: linux-kernel@vger.kernel.org, gregkh@suse.de
Subject: Re: [PATCH] vt: Add K_OFF return value to vt_ioctl KDGKBMODE
Message-Id: <20110407161239.9e89a98c.akpm@linux-foundation.org>
In-Reply-To: <1300351652.10531.2.camel@art-x200>
References: <1300351652.10531.2.camel@art-x200>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Mar 2011 01:47:32 -0700
Arthur Taylor <art@ified.ca> wrote:

> 
> After adding support for K_OFF in KDSKBMODE, it was forgotten to
> add support for returning it in KDGKBMODE.
> 
> Signed-off-by: Arthur Taylor <art@ified.ca>
> ---
>  drivers/tty/vt/vt_ioctl.c |    1 +
>  1 files changed, 1 insertions(+), 0 deletions(-)
> 
> diff --git a/drivers/tty/vt/vt_ioctl.c b/drivers/tty/vt/vt_ioctl.c
> index 937d172..e71477a 100644
> --- a/drivers/tty/vt/vt_ioctl.c
> +++ b/drivers/tty/vt/vt_ioctl.c
> @@ -701,6 +701,7 @@ int vt_ioctl(struct tty_struct *tty,
>  		uival = ((kbd->kbdmode == VC_RAW) ? K_RAW :
>  				 (kbd->kbdmode == VC_MEDIUMRAW) ? K_MEDIUMRAW :
>  				 (kbd->kbdmode == VC_UNICODE) ? K_UNICODE :
> +				 (kbd->kbdmode == VC_OFF) ? K_OFF :
>  				 K_XLATE);

OK.  Thanks.  But.  If you come across such monstrosities, please do not
permit them to live.

--- a/drivers/tty/vt/vt_ioctl.c~vt-add-k_off-return-value-to-vt_ioctl-kdgkbmode-fix
+++ a/drivers/tty/vt/vt_ioctl.c
@@ -698,11 +698,23 @@ int vt_ioctl(struct tty_struct *tty,
 		break;
 
 	case KDGKBMODE:
-		uival = ((kbd->kbdmode == VC_RAW) ? K_RAW :
-				 (kbd->kbdmode == VC_MEDIUMRAW) ? K_MEDIUMRAW :
-				 (kbd->kbdmode == VC_UNICODE) ? K_UNICODE :
-				 (kbd->kbdmode == VC_OFF) ? K_OFF :
-				 K_XLATE);
+		switch (kbd->kbdmode) {
+		case VC_RAW:
+			uival = K_RAW;
+			break;
+		case VC_MEDIUMRAW:
+			uival = K_MEDIUMRAW;
+			break;
+		case VC_UNICODE:
+			uival = K_UNICODE;
+			break;
+		case VC_OFF:
+			uival = K_OFF;
+			break;
+		default:
+			uival = K_XLATE;
+			break;
+		}
 		goto setint;
 
 	/* this could be folded into KDSKBMODE, but for compatibility
_

