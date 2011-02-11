Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757573Ab1BKBWL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Feb 2011 20:22:11 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:41698 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756899Ab1BKBWI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Feb 2011 20:22:08 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=sbhoh1tUFicNKB4m+Z9ggOm4YY1eEY1s78h4ElPabDLXVKT+nDX6Xn/5OYOuiMtNyC
         W255KrbTbVEaz6r7ORkPPF15k5NJ8Ltj94KWZ/PMj4JFT/R1PmID/uoAyjejOQkt6qxt
         lzuL7D72GFx163UOBo6y3RkePjhFjjX8p2aFk=
Date: Thu, 10 Feb 2011 17:21:57 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Terry Lambert <tlambert@chromium.org>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Input: fixed EVIOCGRAB iterative grab/release.
Message-ID: <20110211012156.GB12313@core.coreip.homeip.net>
References: <1297381370-16388-1-git-send-email-tlambert@chromium.org>
 <20110210235447.GA12313@core.coreip.homeip.net>
 <AANLkTinjPG-KY-ee3ya7bca8F5QechRhE88+uO6odgjE@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinjPG-KY-ee3ya7bca8F5QechRhE88+uO6odgjE@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 10, 2011 at 04:41:52PM -0800, Terry Lambert wrote:
> Sure.  First patch to linux in 16 years and all, I didn't want to be
> too noisy...
> 
> Problem:
> 
> If you use EVIOCGRAB, such as when you are using a Cr-48 with the
> Synaptics trackpad driver, the grab on the input device has to be
> dropped before you zero out the grab on the evdev, or you can't grab
> it again without rebooting.  The X Server does this; it's usually not
> an issue for Chromium OS because it tends to just reboot, but everyone
> else gets a locked up pointer.

Older versions of X evdev and X synaptics drivers used to grab event
device and release the grab when switching to another VT, then reqacuire
the grab when switching back to X's VT. This works (-ed?) just fine with
the current code.

Could you please explain how exactly current order of operations
prevents subsequent grabs and why changing it resolves the issue?

FWIW the current pattern is old and true "release resources in the order
opposite to which they were acquired".

> This is pretty easy to reproduce with a modified evtest program that
> does an EVIOCGRAB, if you don't have a Synaptics touchpad to use for
> testing (but you won't get whatever you grab back unless you use the
> same fd or reboot).

Could you probably share this modified version?

> 
> I have some patches to a number of bugs in the Synaptics driver, and
> some additional code cleanup vs. checkpatch.pl for
> drivers/input/evdev.c too, but I thought I'd start small.
> 

Send them on, please.

Thanks.

-- 
Dmitry
