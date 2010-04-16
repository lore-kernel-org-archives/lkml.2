Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758518Ab0DPOl5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 10:41:57 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57498 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758506Ab0DPOlz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 10:41:55 -0400
Date: Fri, 16 Apr 2010 10:41:53 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Martin Mokrejs <mmokrejs@ribosome.natur.cuni.cz>
cc: Maciej Rutecki <maciej.rutecki@gmail.com>,
       USB list <linux-usb@vger.kernel.org>,
       USB Storage list <usb-storage@lists.one-eyed-alien.net>,
       LKML <linux-kernel@vger.kernel.org>
Subject: Re: 2.6.33.1: USB camera hung_task_timeout_secs >120 seconds
In-Reply-To: <4BC81859.2080706@ribosome.natur.cuni.cz>
Message-ID: <Pine.LNX.4.44L0.1004161036390.1923-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 16 Apr 2010, Martin Mokrejs wrote:

> > If 2.6.34-rc doesn't work, please post a usbmon trace showing what
> > happens when the device is plugged in.  Instructions are in
> > Documentation/usb/usbmon.txt.
> 
> I am unable to reproduce this with any version 2.6.30.10., 2.6.31.12,
> 2.6.33.1, 2.6.34-rc4-git2. I turned off the camera many times, removed the
> PCMCIA card while the USB media was recognized through kernel (not mounted),
> no luck. I do use it say once a week and the crash I swa for the first time,
> so I am not much optimistic on reproducibility. :(

That's good then -- you're running with no problems.  :-)

> Could it be related tot he fact that because the laptop has USB1.1 onboard
> it loads uhci_hcd first. Eventually when I plugin the PCMCIA card it loads
> ehci_hcd and the kernel complains it should have been loaded before?
> Is there a way to tell this in /etc/modules.d/somefile ? I fear I have to
> compile them into the kernel statically, on this particular setup.

Don't worry about that.  That warning doesn't indicate any errors; it's
just there to let people know what they _should_ do.  The system will
work okay even when the drivers are loaded in the wrong order.  Bad
effects are possible only if the UHCI and EHCI controllers share some
ports, and on your system they don't.

Alan Stern

