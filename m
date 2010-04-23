Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758255Ab0DWQuZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 12:50:25 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:45896 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754180Ab0DWQuW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 12:50:22 -0400
Date: Fri, 23 Apr 2010 12:50:21 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Eric Lescouet <Eric.Lescouet@VirtualLogix.com>
cc: Greg KH <greg@kroah.com>,
       "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
       "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>
Subject: Re: USBIP (staging) driver's dependency on drivers/usb/core internal
 headers
In-Reply-To: <4BD1CB60.20209@VirtualLogix.com>
Message-ID: <Pine.LNX.4.44L0.1004231246440.1777-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010, Eric Lescouet wrote:

> If I understand correctly, splitting hub.h into hub.h + ch11.h is 
> independent of the move. At the end the 2 (or 3 files) would end up
> into include/linux/usb/.
> correct?

Two files.  The first would be ch11.h (or maybe keep the name hub.h; 
I'm not sure which is best), and the second would be hcd.h (including 
the leftover parts from the original hub.h).

> I've tried to move hub.h and hcd.h and to compile the kernel, already.
> Changing the path of the #include directives in ~40 files did the trick.
> 
> Would you like 2 patches (move and then split) or only 1?

If it weren't for the rename, I'd say do it in two patches.  But if the 
name is changed to ch11.h then those 40 files would have to be altered 
twice.

Alan Stern

