Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757186Ab0DARII (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 13:08:08 -0400
Received: from mail-ww0-f46.google.com ([74.125.82.46]:46860 "EHLO
	mail-ww0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754847Ab0DARIC convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 13:08:02 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=pJ6emsHz66vhHtaWkkAsM0vkqJjHNjJFEwob9ABPAXS5fQ48hW7B166wgBb3viFQOF
         Qu6YzihogUM3tqaY/ThE17+1CgkG8SZPO/S3GwcX8OeTB9fa/C25yvcHcWoYui4lDGkQ
         6bW9UGseg4LwuW+wC9VZ6la+9ZixGkobWtKKo=
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.00.1004010921550.3707@i5.linux-foundation.org>
References: <alpine.LFD.2.00.1003301029250.3707@i5.linux-foundation.org>
	 <201003302316.45651.rjw@sisk.pl> <201004010313.32920.rjw@sisk.pl>
	 <alpine.LFD.2.00.1004010921550.3707@i5.linux-foundation.org>
Date: Thu, 1 Apr 2010 13:07:59 -0400
Message-ID: <o2ma728f9f91004011007l4c3aee18p14daae06cda71e68@mail.gmail.com>
Subject: Re: [Regression, post-rc2] Commit a5ee4eb7541 breaks OpenGL on RS780 
	(was: Re: Linux 2.6.34-rc3)
From: Alex Deucher <alexdeucher@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Linux PCI <linux-pci@vger.kernel.org>,
       Greg KH <gregkh@suse.de>, Clemens Ladisch <clemens@ladisch.de>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Jesse Barnes <jbarnes@virtuousgeek.org>,
       Alex Deucher <alexdeucher@gamil.com>, dri-devel@lists.sourceforge.net,
       stable@kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 1, 2010 at 12:29 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
>
> On Thu, 1 Apr 2010, Rafael J. Wysocki wrote:
>>
>> OK, I've verified that partial revert (below) is sufficient.
>
> Hmm. Through the DRM merge I just did, this area actually conflicted, and
> the resolved version is now
>
>        if ((rdev->family >= CHIP_RV380) &&
>            (!(rdev->flags & RADEON_IS_IGP))) {
>
> which presumably also fixes your issue?
>
> [ Side note: somebody in the DRM tree seems to be way too used to LISP,
>  and thinks that adding parenthesis always improves the code ;-]
>

heh, that's me.  habit I guess, just to be sure.

> However, I do suspect that we should probably revert the quirk regardless
> as being useless (ie it probably was related to those IGP chips that
> apparently don't do MSI anyway).
>
> So the patch that reverts the quirk by Clemens (to replace it with
> disabling MSI entirely when the AMD NB doesn't accept them) seems to be a
> good idea regardless, since it's apparently not just about gfx. Jesse?

Clemems' "PCI quirk: RS780/RS880: disable MSI completely" patch is the
right approach I think.  Note that it's only devices hung off the int
gfx pci to pci bridge that have broken MSI (gfx and audio).  MSI works
fine on the PCIE slots.  I have a similar patch for rs400 chips on bug
15626:
https://bugzilla.kernel.org/show_bug.cgi?id=15626

Alex

>
>                        Linus
>
> ------------------------------------------------------------------------------
> Download Intel&#174; Parallel Studio Eval
> Try the new software tools for yourself. Speed compiling, find bugs
> proactively, and fine-tune applications for parallel performance.
> See why Intel Parallel Studio got high marks during beta.
> http://p.sf.net/sfu/intel-sw-dev
> --
> _______________________________________________
> Dri-devel mailing list
> Dri-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/dri-devel
>
