Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755655Ab0DIWut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Apr 2010 18:50:49 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:45525 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751292Ab0DIWuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Apr 2010 18:50:46 -0400
Date: Fri, 9 Apr 2010 23:54:13 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: guenter.roeck@ericsson.com, linux-kernel@vger.kernel.org,
       Yinghai <yinghai.lu@oracle.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Bjorn Helgaas <bjorn.helgaas@hp.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
       "x86@kernel.org" <x86@kernel.org>, Andy Isaacson <adi@hexapodia.org>,
       Thomas Renninger <trenn@suse.de>
Subject: Re: [PATCH] x86: Reserve legacy VGA MMIO area for x86_64 as well as
 x86_32
Message-ID: <20100409235413.1167ff0c@lxorguk.ukuu.org.uk>
In-Reply-To: <4BBFAD49.3000208@zytor.com>
References: <20100407210628.28364.96982.stgit@bob.kio>
	<201004071705.07176.bjorn.helgaas@hp.com>
	<4BBD13C3.2060404@oracle.com>
	<201004091004.39857.bjorn.helgaas@hp.com>
	<4BBF5987.3010100@zytor.com>
	<4BBF626A.3060800@oracle.com>
	<4BBF70BC.3080809@zytor.com>
	<1270839357.1477.758.camel@groeck-laptop>
	<4BBF89FE.5040909@zytor.com>
	<1270845108.1477.784.camel@groeck-laptop>
	<4BBF91C6.9090701@zytor.com>
	<20100409234245.4081994a@lxorguk.ukuu.org.uk>
	<4BBFAD49.3000208@zytor.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> No they're not.  The 0xa0000...0xbffff range has been a legacy video
> area since the very first PC (although the first PC only used
> 0xb0000..0xbffff, 0xa0000..0xbffff was declared reserved at that time.)

Depending on your definition of "PC". Quite a few early MSDOS systems had
video elsewhere. Some embedded systems without video use the space for
other stuff. Lots of ISA 386/486 PCs had cards borrowing the unused bits
of video space.

> I'm wondering what those legitimate reasons are.  This is particularly
> so since it affects our ability to deal with very early errors, long
> before we have enumerated anything.  At this point we can at least lay
> down bytes in the video area and hope the user can see them.

Thats why you have the bios equipment byte and video queries.
