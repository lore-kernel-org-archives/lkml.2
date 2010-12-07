Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753865Ab0LGACy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Dec 2010 19:02:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:22660 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753015Ab0LGACx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Dec 2010 19:02:53 -0500
Subject: Re: [RFC PATCH] Utilize the PCI API in the AGP framework.
From: Dave Airlie <airlied@redhat.com>
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: airlied@linux.ie, tglx@linutronix.de, hpa@zytor.com,
        linux-kernel@vger.kernel.org, konrad@kernel.org,
        Jeremy Fitzhardinge <jeremy@goop.org>
In-Reply-To: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
References: <1291677875-30493-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 07 Dec 2010 10:02:06 +1000
Message-ID: <1291680126.8232.5.camel@clockmaker-el6>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-12-06 at 18:24 -0500, Konrad Rzeszutek Wilk wrote:
> Attached is a set of RFC patches that make it possible for AGP graphic drivers to
> work under Xen. The major problem that Linux kernel has when running under Xen
> is that the usage of "virt_to_phys(x) >> PAGE_SIZE" to get the DMA address is not
> applicable. That is due to the fact that the PFN value is not the real Machine
> Frame Number (MFN), hence virt_to_phys(x) >> PAGE_SIZE ends up pointing to a
> random physical address. But if you use the PCI API, then the DMA (bus) address
> returned is a valid MFN.

Can I ask you to go back a step and address what the use case for all of
this is, the patch description doesn't address why anyone cares about
AGP in 2010, esp with Xen. Virtualising hw  drivers for the sake of it
is all well and good, but since most of these drivers are for really
legacy systems I can't imagine we are going to see a lot of regression
testing before they hit distros like Debian two years from now, though
maybe Gentoo might pick up some, (is anyone even running IA64?).

I can maybe imagine the Intel GTT being cared about but we've already
addressed the issues in it from what I can see.

Also the X server use case is still possibly valid for a lot of the
systems here, its userspace ABI so it can't just end up broken. The move
to TTM/DRM being the main user didn't suddenly remove the use of the X
server case on older systems which don't have a TTM/DRM layer.

Other than that the idea seems sane, I just hate having to upgrade large
parts of the subsystem without some reasonable justification that
someone out there is going to use it. If it allows some major cleanup
else where that would also be a possibly good justification.

Dave.



