Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160Ab1DNPph (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Apr 2011 11:45:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36441 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759143Ab1DNPpf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Apr 2011 11:45:35 -0400
Date: Thu, 14 Apr 2011 11:45:34 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
cc: Felipe Balbi <balbi@ti.com>, Tanya Brokhman <tlinder@codeaurora.org>,
        <gregkh@suse.de>, <linux-arm-msm@vger.kernel.org>,
        <ablay@codeaurora.org>,
        "'open list:USB GADGET/PERIPH...'" <linux-usb@vger.kernel.org>,
        "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb: merge the two dummy_hcds into one
In-Reply-To: <20110414114605.GA17871@linutronix.de>
Message-ID: <Pine.LNX.4.44L0.1104141141480.2487-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Apr 2011, Sebastian Andrzej Siewior wrote:

> This patch merges the two HCDs so there is one for both.

It is too premature for this.

In fact, the support for USB-3 HCDs is currently in flux.  Sarah Sharp 
has submitted a whole bunch of patches to allow for the creation of 
primary and secondary HCDs, representing the USB-2 and USB-3 root hubs 
of an xHCI controller.  dummy-hcd should use the same mechanism.

This will means creating only one host-side platform device, and then 
creating two usb_hcd structures below it.  Tanya's design should be 
based on Sarah's work.

Alan Stern

