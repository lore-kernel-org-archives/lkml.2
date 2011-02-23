Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753770Ab1BWXvI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 18:51:08 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:36565 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753563Ab1BWXvF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 18:51:05 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=GMF813dxZWAzTpF9oTVWRjtk9//bvd3XLZfVg0HVq6oPIOy4jSuACGsbfnF689kX8A
         LXWNpvhKFlkVFHzUgEQfOK1uI1IgHk8sX5RMgSZZ8116CFf9U8H/NvKaObFu6961z0sq
         C26SwR94In7qA+822D3pUy9QymSZRmiqEmWdA=
MIME-Version: 1.0
In-Reply-To: <20110222121704.19437.4650.stgit@localhost.localdomain>
References: <20110222121704.19437.4650.stgit@localhost.localdomain>
Date: Thu, 24 Feb 2011 09:51:04 +1000
Message-ID: <AANLkTimPpr+OugTiPpYxNyS78vqActuURw-tnxJVxi18@mail.gmail.com>
Subject: Re: [PATCH] gma500: Intel GMA500 staging driver
From: Dave Airlie <airlied@gmail.com>
To: Alan Cox <alan@linux.intel.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 22, 2011 at 10:17 PM, Alan Cox <alan@linux.intel.com> wrote:
> This is an initial staging driver for the GMA500. It's been stripped out
> of the PVR drivers and crunched together from various bits of code and
> different kernels.
>
> Currently it's unaccelerated but still pretty snappy even compositing with
> the frame buffer X server.
>
> Lots of work is needed to rework the ttm and bo interfaces from being
> ripped out and then 2D acceleration wants putting back for framebuffer and
> somehow eventually via DRM.
>
> There is no support for the parts without open source userspace (video
> accelerators, 3D) as per kernel policy.
>
> I'm not a DRM expert so if there is anyone with a GMA500 who actually knows
> something about DRI internals then help would be most welcome.
>


Okay I'm okay with this going into staging but we should work out a
plan for it going forward.

I don't have any poulsbo hw but if some were to appear I could
probably expend effort on this.

So where do we want to go my opinion is

a) remove all userspace interfaces and simplify ttm memory management usage.
b) add support to hook this up to the dumb ioctl so we can do trivial
generic front buffer allocation, so then a libkms + dumb kms
modesetting driver can work on it.
c) figure out how to add interface for acceleration users. Whether TTM
fence interfaces are required etc.

We could probably just add a GEM style buffer allocation interface but
we'd probably need to do a lot of RE first to figure out what best
suits the hardware, I'm pretty sure I've haven't heard any glowing
praise that the current interface suits the hw or is maintainable.

Dave.
