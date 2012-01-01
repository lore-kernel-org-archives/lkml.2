Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751251Ab2AACVu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 21:21:50 -0500
Received: from netrider.rowland.org ([192.131.102.5]:60767 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750883Ab2AACVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 21:21:46 -0500
Date: Sat, 31 Dec 2011 21:21:45 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Oliver Neukum <oliver@neukum.org>
cc: Matthew Garrett <mjg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Jones <davej@redhat.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Chaoming Li <chaoming_li@realsil.com.cn>,
        "John W. Linville" <linville@tuxdriver.com>,
        Greg Kroah-Hartman <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>
Subject: Re: loading firmware while usermodehelper disabled.
In-Reply-To: <201112311659.48427.oliver@neukum.org>
Message-ID: <Pine.LNX.4.44L0.1112312033240.28510-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 31 Dec 2011, Oliver Neukum wrote:

> Am Samstag, 31. Dezember 2011, 16:33:12 schrieb Alan Stern:
> 
> > Nothing has changed in the USB layer -- it has always been true that
> > devices could be reset during a suspend/resume cycle.  This isn't a
> > matter of how the stack is written or anything like that; some
> > motherboards simply do not provide suspend power to their USB
> > controllers.  Or the firmware reinitializes the controllers and
> > attached devices during resume, forcing Linux's USB core to reset
> > every device on the affected buses.
> > 
> > When it comes to suspend/resume, there are almost no guarantees.  :-(
> 
> We are definitely going through do_unbind_rebind(). But I don't think
> it matters why we got there. We seem to be calling probe() too early.
> And we need to guarantee that a driver can request firmware in probe()
> 
> So something has changed in the resume code path further up.

For at least a year and a half, it has been true that rebinding takes
place during the complete phase of system resume.  Clearly that is too 
early to load firmware.  When do you think we should do it instead?  
And how should we keep track of which interfaces need rebinding?

Alan Stern

P.S.: Oliver, it looks like there's a bunch of dead code in
usb_suspend_interface() and usb_resume_interface().  I don't see how
either one can be executed with a driver that doesn't have both suspend
and resume methods.  Such cases should be filtered out when
usb_suspend() calls do_unbind_rebind().  The only odd thing that can
happen is when a driver doesn't support reset-resume.  Do you agree?

