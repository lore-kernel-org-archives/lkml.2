Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757420Ab0DAWuZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 18:50:25 -0400
Received: from outbound-mail-313.bluehost.com ([67.222.54.6]:42928 "HELO
	outbound-mail-313.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755012Ab0DAWuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 18:50:21 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=XTYegc7fCyxr6lB9XM44Q+U4l+2zsGX3fjeGAS60nB9TC2TZkifrSWY+PmeP05P8bV02lob+Illu2d6a4bVG2HPWkll7eCeUntRQMVw9jG0kDCzhA9/aQJZD+rSalPhH;
Date: Thu, 1 Apr 2010 15:48:47 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Dave Airlie <airlied@gmail.com>, dri-devel@lists.sourceforge.net,
       Linux PCI <linux-pci@vger.kernel.org>,
       Clemens Ladisch <clemens@ladisch.de>,
       Alex Deucher <alexdeucher@gamil.com>, stable@kernel.org,
       Greg KH <gregkh@suse.de>
Subject: Re: [Regression, post-rc2] Commit a5ee4eb7541 breaks OpenGL on
 RS780 (was: Re: Linux 2.6.34-rc3)
Message-ID: <20100401154847.20e9c8b8@jbarnes-piketon>
In-Reply-To: <alpine.LFD.2.00.1004010921550.3707@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org>
	<201003302316.45651.rjw@sisk.pl>
	<201004010313.32920.rjw@sisk.pl>
	<alpine.LFD.2.00.1004010921550.3707@i5.linux-foundation.org>
X-Mailer: Claws Mail 3.7.2 (GTK+ 2.18.3; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 1 Apr 2010 09:29:23 -0700 (PDT)
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> 
> 
> On Thu, 1 Apr 2010, Rafael J. Wysocki wrote:
> > 
> > OK, I've verified that partial revert (below) is sufficient.
> 
> Hmm. Through the DRM merge I just did, this area actually conflicted, and 
> the resolved version is now
> 
>         if ((rdev->family >= CHIP_RV380) &&
>             (!(rdev->flags & RADEON_IS_IGP))) {
> 
> which presumably also fixes your issue?
> 
> [ Side note: somebody in the DRM tree seems to be way too used to LISP, 
>   and thinks that adding parenthesis always improves the code ;-]
> 
> However, I do suspect that we should probably revert the quirk regardless 
> as being useless (ie it probably was related to those IGP chips that 
> apparently don't do MSI anyway).
> 
> So the patch that reverts the quirk by Clemens (to replace it with 
> disabling MSI entirely when the AMD NB doesn't accept them) seems to be a 
> good idea regardless, since it's apparently not just about gfx. Jesse?

Yeah, that sounds fine.  I can include it in my next pull req or you
can just pick it up directly.

-- 
Jesse Barnes, Intel Open Source Technology Center
