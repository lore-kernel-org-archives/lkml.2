Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752425Ab1CUJKd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 05:10:33 -0400
Received: from cantor2.suse.de ([195.135.220.15]:43546 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751161Ab1CUJKa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 05:10:30 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Jiri Kosina <jkosina@suse.cz>
Subject: Re: "usb_wwan: error case of resume" (16871dcac) is buggy
Date: Mon, 21 Mar 2011 10:11:07 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
References: <alpine.LNX.2.00.1103210130260.19969@pobox.suse.cz>
In-Reply-To: <alpine.LNX.2.00.1103210130260.19969@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 8BIT
Message-Id: <201103211011.07282.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 21. März 2011, 01:36:45 schrieb Jiri Kosina:
> Hi,
> 
> the commit in subject make the kernel with CONFIG_PM_RUNTIME unset fail 
> during compilation, as struct dev_pm_info doesn't have whole bunch of 
> members in such case.
> 
> The commit in question adds this code:
> 
> 	/* we have to throw away the rest */
> 	do {
> 		unbusy_queued_urb(urb, portdata);
> 		//extremely dirty
> 		atomic_dec(&port->serial->interface->dev.power.usage_count);
> 	} while ((urb = usb_get_from_anchor(&portdata->delayed)));
> 
> The 'extermely dirty' comment makes me a bit nervous whether the patch 
> below is correct or some more thinking would be necessary.

I've since posted a clean patch, although your fix looks correct to me.
The problem was that I was unsure about the locking during resume().
I rather wrote a layering violation than risk a deadlock in an error path
hard to test. But I did not feel well doing it.

	Regards
		Oliver
