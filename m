Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756773Ab1INPC1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 11:02:27 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51224 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751612Ab1INPC0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 11:02:26 -0400
Date: Wed, 14 Sep 2011 11:02:25 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Sameer Nanda <snanda@chromium.org>
cc: gregkh@suse.de, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] USB: ehci-pci: Check and enable wakeup capability
In-Reply-To: <1315955661-29493-1-git-send-email-snanda@chromium.org>
Message-ID: <Pine.LNX.4.44L0.1109141056310.2066-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Sep 2011, Sameer Nanda wrote:

> If the PORTWAK register is implemented and at least one of the physical
> ports is enabled for wakeup, enable wakeup for the ehci-pci device.

NAK.  Our current policy is that devices do not get enabled for wakeup 
by default unless users expect it (things like keyboards and power 
buttons, maybe LAN interfaces).

One certainly can question this policy.  It might make sense to enable 
wakeup for devices that don't generate wakeup events on their own but 
merely act as bridges for other devices.  By this reasoning, all USB 
host controllers should always be enabled for wakeup by default -- not 
just some of the PCI-based controllers.  But this is a separate matter 
and should be discussed on the mailing list.

Alan Stern

