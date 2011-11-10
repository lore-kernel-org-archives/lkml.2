Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934056Ab1KJJrB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 04:47:01 -0500
Received: from mail-fx0-f46.google.com ([209.85.161.46]:58603 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755464Ab1KJJq7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 04:46:59 -0500
Subject: Re: [PATCH v3] drm/i915: Honor SSC quirk table over the default,
 unless set by user
From: Michel Alexandre Salim <salimma@fedoraproject.org>
To: Keith Packard <keithp@keithp.com>
Cc: intel-gfx@lists.freedesktop.org, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        linux-kernel <linux-kernel@vger.kernel.org>
Date: Thu, 10 Nov 2011 10:46:55 +0100
In-Reply-To: <yunvcqtxj8c.fsf@aiko.keithp.com>
References: <1320855178.5081.9.camel@fauix11.informatik.uni-erlangen.de>
	 <4EBAAAA5.7030807@fedoraproject.org> <yunvcqtxj8c.fsf@aiko.keithp.com>
Organization: Fedora Project
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15)
Content-Transfer-Encoding: 7bit
Message-ID: <1320918416.28110.4.camel@fauix11.informatik.uni-erlangen.de>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-11-09 at 10:07 -0800, Keith Packard wrote:
> On Wed, 09 Nov 2011 17:30:29 +0100, Michel Alexandre Salim <salimma@fedoraproject.org> wrote:
> > Additional note: while I've not touched the line since it does not
> > affect me, it seems that i915_panel_use_ssc *cannot* be less than 0
> > since that variable is declared as unsigned.
> 
> Oops. That's the bug here -- we're supposed to make it so that the
> command line can override the quirks, but there's no way to use a quirk
> given the mis-declared parameter.
Ah, now everything makes sense.
> 
> This is untested...
> 
Tested and it works fine:
- without extra parameter, the blacklist is used
- with i915.lvds_use_ssc=1, SSC use is enforced and the display turns
black on my unsupported hardware
- with i915.lvds_use_ssc=0, SSC is disabled

(ps the PGP/MIME signature made it hard to just extract the
git-formatted email; I ended up just editing the message by hand before
'git am')

> From e64ecadef40e3c2035cd4e9b967ffd83489bdea0 Mon Sep 17 00:00:00 2001
> From: Keith Packard <keithp@keithp.com>
> Date: Wed, 9 Nov 2011 09:57:50 -0800
> Subject: [PATCH] drm/i915: Module parameters using '-1' as default must be
>  signed type
> 
> Testing i915_panel_use_ssc for the default value was broken, so the
> driver would never autodetect the correct value.
> 
> Signed-off-by: Keith Packard <keithp@keithp.com>
Reviewed-by:   Michel Alexandre Salim <salimma@fedoraproject.org>
Tested-by:     Michel Alexandre Salim <salimma@fedoraproject.org>

Should I send the patch that I applied with those added lines? Probably
not necessary.

Thanks,

-- 
Michel

