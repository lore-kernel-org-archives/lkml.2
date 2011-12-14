Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757938Ab1LNXP5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Dec 2011 18:15:57 -0500
Received: from mail-pw0-f46.google.com ([209.85.160.46]:44503 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526Ab1LNXPx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Dec 2011 18:15:53 -0500
MIME-Version: 1.0
Date: Thu, 15 Dec 2011 01:15:52 +0200
Message-ID: <CAMP44s2M8cFM5AhjMwbFJZpQtbYe13w9bswTRhap97nOCyZVfQ@mail.gmail.com>
Subject: Issue with isp1704 loaded too soon
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Jarkko Nikula <jarkko.nikula@bitmer.com>
Cc: Felipe Contreras <felipe.contreras@nokia.com>,
        linux-main <linux-kernel@vger.kernel.org>,
        Kalle Jokiniemi <kalle.jokiniemi@nokia.com>,
        Heikki Krogerus <heikki.krogerus@nokia.com>,
        Anton Vorontsov <cbouatmailru@gmail.com>,
        Tony Lindgren <tony@atomide.com>, linux-omap@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 13, 2011 at 11:19 PM, Felipe Contreras
<felipe.contreras@gmail.com> wrote:
> On Mon, Dec 12, 2011 at 9:09 AM, Jarkko Nikula <jarkko.nikula@bitmer.com> wrote:
>> Indeed yes. I checked that in 3.0 it still works but not in 3.1 so some
>> non isp1704_charger change has broke it as there hasn't been changes on it.
>
> Actually it's broken in 3.0 as well, try this configuration:
>
>        # CONFIG_USB_MUSB_HOST is not set
>        # CONFIG_USB_MUSB_PERIPHERAL is not set
>        CONFIG_USB_MUSB_OTG=y
>        CONFIG_USB_GADGET_MUSB_HDRC=y
>        CONFIG_USB_MUSB_HDRC_HCD=y
>
>        CONFIG_USB_GADGET_SELECTED=y
>        # CONFIG_USB_GADGET_FUSB300 is not set
>        # CONFIG_USB_GADGET_OMAP is not set
>        # CONFIG_USB_GADGET_R8A66597 is not set
>        # CONFIG_USB_GADGET_PXA_U2O is not set
>        # CONFIG_USB_GADGET_M66592 is not set
>        # CONFIG_USB_GADGET_DUMMY_HCD is not set
>
> I will try to find where the issues started to happen, but it's a bit
> difficult because all this USB Kconfig stuff is completely messed up.
>
> *Sigh*

Ok, I made some progress.

The issue appeared on 2.6.39, specifically, on commit 0df0914, which
is a merge from Linus. The issue doesn't appear in any of the two
parents of that merge.

I manually merged various commits, and the first one that triggered
the problem is 18a2689, but the commit itself is not the problem but
something that was already merged to Linus' tree, specifically at
point 6899608.

IOW, it's a mixture of two changes that appear together at point,
0df0914, one of them is 18a2689, the other one I still don't know.

Unless you can find what's wrong with this commit:
http://git.kernel.org/?p=linux/kernel/git/torvalds/linux.git;a=blobdiff;f=arch/arm/mach-omap2/usb-musb.c;h=a9d4d143086d73463b97c093cc9f022de8e1d679;hp=9788b4941857f40d50d48fa6470ee14e179bc373;hb=18a2689;hpb=273ff8c3bc04cf358c131f49ee7a11efa7ec73d7

I guess the safest route is to continue with the manual merges to find
the second relevant commit =/

-- 
Felipe Contreras
