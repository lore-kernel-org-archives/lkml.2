Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752412Ab0DKRJJ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Apr 2010 13:09:09 -0400
Received: from mail-bw0-f219.google.com ([209.85.218.219]:51141 "EHLO
	mail-bw0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab0DKRJH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Apr 2010 13:09:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=MWjbTqy/hNutp8C/gonJNOdUXREwLn+53BWKImkJedvzhZuwummwmNLrG1RIgg+/Lc
         Fmg6op2HywXkkEHBQ/TSXpW6criDSmvnhc568WUPlMqLDFPLMBeNpBg4S4Tdzdmi9NI9
         Fw/HtFP+n8+OhDyduPY3Y5vmaC9rwcKPVTa3k=
Date: Sun, 11 Apr 2010 19:09:00 +0200
From: Marcin Slusarz <marcin.slusarz@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>
Cc: nouveau@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
       Ben Skeggs <bskeggs@redhat.com>, Dave Airlie <airlied@redhat.com>,
       Peter Jones <pjones@redhat.com>,
       Andrew Morton <akpm@linux-foundation.org>,
       Didier Spaier <didier.spaier@epsm.fr>
Subject: Re: [PATCH 3/3] fbmem, drm/nouveau: kick firmware framebuffers as
 soon as possible
Message-ID: <20100411170900.GB4016@joi.lan>
References: <1270929334-3742-1-git-send-email-marcin.slusarz@gmail.com>
 <1270929334-3742-3-git-send-email-marcin.slusarz@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270929334-3742-3-git-send-email-marcin.slusarz@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 10, 2010 at 09:55:34PM +0200, marcin.slusarz@gmail.com wrote:
> Currently vesafb/efifb/... is kicked when hardware driver is registering
> framebuffer. To do it hardware must be fully functional, so there's a short
> window between start of initialisation and framebuffer registration when
> two drivers touch the hardware. Unfortunately sometimes it breaks nouveau
> initialisation.
> 
> Fix it by kicking firmware driver(s) before we start touching the hardware.
> 
> Reported-by: Didier Spaier <didier.spaier@epsm.fr>
> Signed-off-by: Marcin Slusarz <marcin.slusarz@gmail.com>
> Cc: Ben Skeggs <bskeggs@redhat.com>
> Cc: Dave Airlie <airlied@redhat.com>
> Cc: Peter Jones <pjones@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> ---

With this little patch below:
Tested-by: Didier Spaier <didier.spaier@epsm.fr>

---
diff --git a/drivers/video/fbmem.c b/drivers/video/fbmem.c
index f5297a0..42ae782 100644
--- a/drivers/video/fbmem.c
+++ b/drivers/video/fbmem.c
@@ -1524,6 +1524,7 @@ void remove_conflicting_framebuffers(struct apertures_struct *a, const char *nam
 		}
 	}
 }
+EXPORT_SYMBOL(remove_conflicting_framebuffers);
 
 /**
  *	register_framebuffer - registers a frame buffer device

