Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933503Ab0GAWKr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Jul 2010 18:10:47 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:52348 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932700Ab0GAWKm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Jul 2010 18:10:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:date:message-id:subject:from:to:content-type;
        b=JIS2aG2FfmIKwC1Uqcjg9cCq+PXaq0f4f2gJPavuHnqEP7o9RuRPVURCw3Sw7do9iV
         4YpuWG07JzBMQoYzDskZE3Cn67CYy2kDJpKIMWIbxYWnPe7mCOuBt3nD9+Gl8qfnjFT7
         mZzKzxndrFjZFkh8oRZKfu1GCe4irzn3BtVEY=
MIME-Version: 1.0
Date: Fri, 2 Jul 2010 08:10:40 +1000
Message-ID: <AANLkTikfYwkxF5CXgt-fGMIYTlcmt99lOz_VyA3Kr-4R@mail.gmail.com>
Subject: Closed source userspace graphics drivers with an open source kernel 
	component
From: Dave Airlie <airlied@gmail.com>
To: LKML <linux-kernel@vger.kernel.org>,
       dri-devel <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now this is just my opinion as maintainer of the drm, and doesn't
reflect anyone or any official policy, I've also no idea if Linus
agrees or not.

We are going to start to see a number of companies in the embedded
space submitting 3D drivers for mobile devices to the kernel. I'd like
to clarify my position once so they don't all come asking the same
questions.

If you aren't going to create an open userspace driver (either MIT or
LGPL) then don't waste time submitting a kernel driver to me.

My reasons are as follows, the thing is you can probably excuse some
of these on a point by point basis, but you need to justify why closed
userspace on all points.

a) licensing, Alan Cox pointed this out before, if you wrote a GPL
kernel driver, then wrote a closed userspace on top, you open up a
while world of derived work issues. Can the userspace operate on a
non-GPL kernel without major modifications etc. This is a can of worms
I'd rather not enter into, and there are a few workarounds.

b) verifying the sanity of the userspace API.
1. Security: GPUs can do a lot of damage if left at home alone, since
mostly you are submitting command streams unverified into the GPU and
won't tell us what they mean, there is little way we can work out if
the GPU is going to over-write my passwd file to get 5 fps more in
quake. Now newer GPUs have at least started having MMUs, but again
we've no idea if that is the only way they work without docs or a lot
of trust.

2. General API suitability and versioning. How do we check that API is
sane wrt to userspace, if we can't verify the userspace. What happens
if the API has lots of 32/64 compat issues or things like that, and
when we fix them the binary userspace breaks? How do we know, how do
we test etc. What happens if a security issue forces us to break the
userspace API? how do we fix the userspace driver and test to confirm?

c) supplying docs in lieu of an open userspace
If you were to fully document the GPU so we could verify the
security/api aspects it leaves us in the position of writing our own
driver. Now writing that driver on top of the current kernel driver
would probably limit any innovation, and most people would want to
write a new kernel driver from scratch. Now we end up with two drivers
fighting, how do we pick which one to load at boot? can we ever do a
generic distro kernel for that device (assuming ARM ever solves that
issue).

I've also noticed a trend to just reinvent the whole wheel instead of
writing a drm/kms driver and having that as the API, again maintainer
nightmares are made of this.

Dave.
