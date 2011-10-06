Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754996Ab1JFFHg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Oct 2011 01:07:36 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:63599 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780Ab1JFFHf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Oct 2011 01:07:35 -0400
Date: Wed, 5 Oct 2011 22:07:26 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Thomas Tuttle <ttuttle@chromium.org>
Cc: linux-kernel@vger.kernel.org, Johan Myreen <jem@iki.fi>
Subject: Re: [PATCH] misc/serio_raw: Avoid circular locking.
Message-ID: <20111006050725.GD20217@core.coreip.homeip.net>
References: <20111005170249.GA27129@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111005170249.GA27129@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Thomas,

On Wed, Oct 05, 2011 at 01:02:49PM -0400, Thomas Tuttle wrote:
> 
> This patch rearranges serio_raw_connect so that it takes the mutex once
> to allocate a device number and open the serio device, drops it to call
> misc_register, then takes it again to add the serio_raw device to the
> list.
> 
> BUG=chromium-os:21113
> TEST=Adhoc: PROVE_LOCKING no longer finds circular locking dependency
> 
> Change-Id: I414c5a3d606c28c81e42dcf989e5c55918eb4ea3
> Signed-off-by: Thomas Tuttle <ttuttle@chromium.org>
> ---
> I think this works, but I'm not familiar enough with the misc and serio
> subsystems to know if this is completely correct, nor if it is the best
> way to break the circular dependency.  Feedback would be appreciated.

Thank you for your report; I looked at the driver and (to my
embarrassment) is is quite broken and requires a bit more extensive
fixing. I'll be posting a few patches shortly and would appreciate if
you could look them over and/or test.

Thanks.

-- 
Dmitry
