Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933735Ab2FHIbV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Jun 2012 04:31:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:58433 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932177Ab2FHIbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Jun 2012 04:31:18 -0400
From: Oliver Neukum <oneukum@suse.de>
Organization: SUSE
To: Stefani Seibold <stefani@seibold.net>
Subject: Re: RFC: remove usb_device pointer from usb_skeleton.c
Date: Fri, 8 Jun 2012 10:28:07 +0200
User-Agent: KMail/1.13.5 (Linux/3.3.0-12-desktop+; KDE/4.4.4; x86_64; ; )
Cc: "linux-kernel" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, alan@lxorguk.ukuu.org.uk,
        linux-usb@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>
References: <1339139935.16819.5.camel@wall-e>
In-Reply-To: <1339139935.16819.5.camel@wall-e>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201206081028.07229.oneukum@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Freitag, 8. Juni 2012, 09:18:55 schrieb Stefani Seibold:
> The connected flag could be also replaced by a "intf->condition ==
> USB_INTERFACE_BOUND", which can be hided by a macro.

No, I am sorry, it cannot. You'd know the interface is bound, but not necessarily
to your driver or even the same "incarnation" of your driver. The fundamental
problem is that we have no data structure describing the binding between a device
and a driver so we cannot refcount that.

As a consequence all refcounting just ensures that the device and interface
data structures stay in memory, but we can make only very limited (read-only)
use of them after a disconnection.

	Regards
		Oliver
