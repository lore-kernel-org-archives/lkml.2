Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752213Ab1BWJng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 04:43:36 -0500
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46845 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751107Ab1BWJne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 04:43:34 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=R0PBKJpW41DqXfork7Nw9fREJXc3dqcQh2YYI1QIsTpNeS5MVg5l2U2ZbUT7Sy+Cxj
         8NQ5j5zns5VDKX0vL1WaSAA8IlOuK/F8vlMDvPDA9xA1bDwXq8Nltwz2gF4KTL4VEbYI
         y8DmNwH8fsIhSKsJ3eROXFEmJr7A42HNCiIc4=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=TTZ57d1wUz1uH3R6igN8O77iDvSLMW=t86g9V@mail.gmail.com>
References: <AANLkTi=TTZ57d1wUz1uH3R6igN8O77iDvSLMW=t86g9V@mail.gmail.com>
Date: Wed, 23 Feb 2011 17:43:33 +0800
Message-ID: <AANLkTinxfP5jGWy+E2ymedgFPEwnHhmb6n86PCPik1M5@mail.gmail.com>
Subject: Re: Linux 2.6.38-rc6
From: Jeff Chua <jeff.chua.linux@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/2/22 Linus Torvalds <torvalds@linux-foundation.org>:
> And for the people who actually reported the regressions (or didn't,
> but have found new ones) - please do update the status of the
> regression. Some of them I'm really feel a lot more happy about if
> they had a note that "yes, I tested with -rc6, and the problem is
> still there". We've fixed a fair number of problems, so it's always
> good to have regression reporters ping us with something like "hey,
> I'm still here, and you may have fixed all those other things, but you
> didn't fix my issue".

I just encountered this reported bug using Bluetooth Intermec scanners
and discovered that the recent kernel has the same problem as reported
below.

https://bugzilla.kernel.org/show_bug.cgi?id=26182  ... the bluetooth
devices would just stop responding after a while.

[ 4533.361959] btusb 8-1:1.0: no reset_resume for driver btusb?
[ 4533.361964] btusb 8-1:1.1: no reset_resume for driver btusb?

It seems to that Fedora doesn't feel this is a big problem, but for
production systems, it's a big deal as the scanners can't connect to
the server.

Seems to relate to this commit. The workabout is to set
usbcore.autosuspend=-1 as command line options, but as this is not
working as intended, then it should be either be fixed or reverted.

Thanks,
Jeff.



commit 556ea928f78a390fe16ae584e6433dff304d3014
Author: Matthew Garrett <mjg@redhat.com>
Date:   Thu Sep 16 13:58:15 2010 -0400

    Bluetooth: Enable USB autosuspend by default on btusb

    We've done this for a while in Fedora without any obvious problems other
    than some interaction with input devices. Those should be fixed now, so
    let's try this in mainline.

    Signed-off-by: Matthew Garrett <mjg@redhat.com>
    Acked-by: Marcel Holtmann <marcel@holtmann.org>
    Signed-off-by: Gustavo F. Padovan <padovan@profusion.mobi>
