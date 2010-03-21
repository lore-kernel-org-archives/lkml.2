Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753829Ab0CUWgX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Mar 2010 18:36:23 -0400
Received: from mail-yw0-f198.google.com ([209.85.211.198]:56060 "EHLO
	mail-yw0-f198.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752298Ab0CUWgW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Mar 2010 18:36:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=lR+FPOA6U5Q8INQdbwm/s74KX1/S8whNVjZrmhTUwAHey1gDD9Uj+t67rD0aFkyIJZ
         frsUmldtoY2iJ2GQRvCBF+yl5yY/4tdgXlQjL8MYbQtGq8xF6ij2quouvp/gIwDHBwdb
         fNMoExPRkIb1+MK+hecJ65/O4dRX10Uwv1nGY=
MIME-Version: 1.0
In-Reply-To: <201003212228.13923.rjw@sisk.pl>
References: <201003212228.13923.rjw@sisk.pl>
Date: Mon, 22 Mar 2010 08:36:20 +1000
Message-ID: <21d7e9971003211536p78792320rf93f9ba5db6c54ff@mail.gmail.com>
Subject: Re: Resume problem with radeon+KMS (2.6.34-rc2 and before)
From: Dave Airlie <airlied@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: dri-devel@lists.sourceforge.net, LKML <linux-kernel@vger.kernel.org>,
       pm list <linux-pm@lists.linux-foundation.org>,
       =?ISO-8859-1?Q?J=E9r=F4me_Glisse?= <glisse@freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/3/22 Rafael J. Wysocki <rjw@sisk.pl>:
> Hi,
>
> Some time ago I reported a problem with resuming from suspend to RAM on
> HP nx6325 with radeon+KMS.

Can you post the X.org log file? if you are really using 6.12.4 and
not a backport
then the userspace driver has no KMS support and it is trashing the system.

Dave.

>
> The problem was that the first resume always failed if the suspend was started
> from under X.  Moreover, the resume went correctly until the last switch from
> the framebuffer console (which was now controlled by the radeon driver as
> well) to X that made the box hang hard.
>
> However, if the first resume was started from the (radeon-controlled)
> framebuffer console, the subsequent resume succeeded and all of the next
> attempts to suspend/resume succeeded, _regardless_ of the way the suspend was
> started.
>
> At that time Dave thought it might be a problem with the nx6325's graphics
> adapter that apparently was a crappy one, but today I found that _exactly_ the
> same behavior was observable on Acer Ferrari One, which was quite different,
> hardware-wise, from the old HP box.  For this reason I think the problem is
> related to the driver itself rather than to the hardware or firmware.
>
> The problem is reproducible on both machines with the latest git kernel
> and the user space radeon_drv.so from openSUSE 11.2 (it says
> module version = 6.12.4 in the X log).  The kernel and user space are 64-bit
> on both machines.  [For completness, the Acer box suspends and resumes
> correctly with radeon.modeset=0 and "s2ram -f -p -m".]
>
> Should I try a newer user space X driver?  Or may the problem be related to
> the 64-bitness somehow?
>
> Rafael
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
