Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab0LXDbw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Dec 2010 22:31:52 -0500
Received: from 124x34x33x190.ap124.ftth.ucom.ne.jp ([124.34.33.190]:56766 "EHLO
	master.linux-sh.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753200Ab0LXDbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Dec 2010 22:31:51 -0500
Date: Fri, 24 Dec 2010 12:30:15 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Dave Airlie <airlied@gmail.com>
Cc: linux-fbdev@vger.kernel.org, dri-devel@lists.sf.net,
        linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>
Subject: Re: [PATCH 3/3] fbcon: fix situation where fbcon gets deinitialised and can't reinit.
Message-ID: <20101224033015.GJ28151@linux-sh.org>
References: <1292895677-4242-1-git-send-email-airlied@gmail.com> <1292895677-4242-4-git-send-email-airlied@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1292895677-4242-4-git-send-email-airlied@gmail.com>
User-Agent: Mutt/1.5.13 (2006-08-11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 21, 2010 at 11:41:17AM +1000, Dave Airlie wrote:
> From: Dave Airlie <airlied@redhat.com>
> 
> Situation as follow:
> 2 GPUs + vesafb + kms.
> 
> GPU 1 is primary, vesafb binds to it as fb0
> radeon loads
> GPU 0 loads as fb1
> GPU 1 loads, vesafb gets kicked off which causes fb0 to unbind
> console, which causes the dummy console to rebind.
> 
> this means fbcon_deinit gets called, which calls fbcon_exit
> since the console isn't bound anymore and we set fbcon_has_exited.
> 
> GPU 1 creates a new fb0 which is primary and we want to be console.
> fbcon_fb_registered gets called sets the primary up and calls set_con2fb_map,
> however as fbcon_has_exited is set nothing further ever happens.
> 
> This patch bypasses the fbcon_has_exited and checks if the console is unbound,
> if its unbound it calls the fbcon_takeover which calls the vt layer to
> call the fbcon_startup method and everthing works.
> 
> Signed-off-by: Dave Airlie <airlied@redhat.com>

This one looks fine, too. This does presumably depend on the change in
behaviour introduced by your 2/3 patch though. I'll hold off on applying
this until that one gets acked, then we can do this either for the next
-rc or for .38.
