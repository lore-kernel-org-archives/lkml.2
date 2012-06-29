Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753156Ab2F2JBt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jun 2012 05:01:49 -0400
Received: from mail-yw0-f42.google.com ([209.85.213.42]:38982 "EHLO
	mail-yw0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751652Ab2F2JBq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jun 2012 05:01:46 -0400
MIME-Version: 1.0
X-Originating-IP: [178.83.130.250]
In-Reply-To: <20120629133046.f6c65d4d6017d2ae486cfd2b@canb.auug.org.au>
References: <20120629133046.f6c65d4d6017d2ae486cfd2b@canb.auug.org.au>
Date: Fri, 29 Jun 2012 11:01:45 +0200
Message-ID: <CAKMK7uE=Jh8Sh_knC7L2=nmCiwPrt0Q5f4Cv4djpgsncOxFfpQ@mail.gmail.com>
Subject: Re: linux-next: manual merge of the drm tree with Linus' tree
From: Daniel Vetter <daniel.vetter@ffwll.ch>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Dave Airlie <airlied@linux.ie>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 29, 2012 at 5:30 AM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> Hi Dave,
>
> Today's linux-next merge of the drm tree got a conflict in
> drivers/gpu/drm/i915/intel_display.c between commit 7aa1e7f06d6e ("Revert
> "drm/i915: allow PCH PWM override on IVB"") from Linus' tree and commit
> 7cf416014813 ("drm/i915: clear up backlight #define confusion on gen4+")
> from the drm tree.
>
> The former removed the function ivb_pch_pwm_override() that is modified
> by the latter, so I did that - or should I have just ignored the revert
> patch?

Nope, the revert should take precedence because that code is bogus -
the change in -next is just replacing a magic value with a proper
#define.

Cheers, Daniel
-- 
Daniel Vetter
daniel.vetter@ffwll.ch - +41 (0) 79 365 57 48 - http://blog.ffwll.ch
