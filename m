Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751386Ab3AJJml (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 04:42:41 -0500
Received: from cantor2.suse.de ([195.135.220.15]:58572 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750800Ab3AJJmk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 04:42:40 -0500
From: Oliver Neukum <oneukum@suse.de>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Josh Boyer <jwboyer@redhat.com>, Alan Stern <stern@rowland.harvard.edu>,
        gregkh@linuxfoundation.org, mdharm-usb@one-eyed-alien.net,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: USB autosuspend vs. URB submission
Date: Thu, 10 Jan 2013 10:42:37 +0100
Message-ID: <1643419.R9VmOAX4j3@linux-5eaq.site>
Organization: SUSE
User-Agent: KMail/4.8.5 (Linux/3.4.11-2.16-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <2664900.viczl5BYBS@avalon>
References: <20130107204220.GB12363@hansolo.jdub.homelinux.org> <20130108160321.GC12363@hansolo.jdub.homelinux.org> <2664900.viczl5BYBS@avalon>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 10 January 2013 00:05:55 Laurent Pinchart wrote:

> I've had a quick look at the trace posted at 
> https://bugzilla.redhat.com/show_bug.cgi?id=879462 but usbmon only shows URBs 
> that are successfully submitted. I'm not sure what useful information I could 
> get from the trace.

The test is at the very start of usb_submit_urb()

        if (!urb || !urb->complete)
                return -EINVAL;
        if (urb->hcpriv) { 
                WARN_ONCE(1, "URB %p submitted while active\n", urb);
                return -EBUSY;
        }

usbmon will never see such URBs

I suggest that for debugging you change the WARN_ONCE into a WARN and compare
the URB pointers of usbmon and dmesg.

In the long run it is probably a good idea to pass duplicated URBs to usbmon by
a special code path.

	Regards
		Oliver

