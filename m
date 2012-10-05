Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932611Ab2JER4t (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 13:56:49 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:57524 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754347Ab2JER4p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 13:56:45 -0400
Date: Fri, 5 Oct 2012 13:56:45 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Florian Fainelli <florian@openwrt.org>
cc: linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 13/32 v2] USB: ohci: move ohci_pci_{suspend,resume} to
 ohci-hcd.c
In-Reply-To: <1349454064-11606-14-git-send-email-florian@openwrt.org>
Message-ID: <Pine.LNX.4.44L0.1210051337040.1541-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 5 Oct 2012, Florian Fainelli wrote:

> As suggested by Alan Stern, move the ohci-pci.c ohci_pci_{suspend,resume}
> routines to ohci-hcd.c. Due to their move, also rename them to
> ohci_{suspend,resume} to make it clear they operate on ohci_hcd. Since they
> are not necessarily called, annotate them with __maybe_unused.
> 
> Signed-off-by: Florian Fainelli <florian@openwrt.org>
> ---
> Changes since v1:
> - moved ohci_{suspend,resume} out of the #ifdef CONFIG_PM block
> - removed the empty CONFIG_PM #ifdef/endif block in ohci-pci.c

Sorry, I didn't explain very well before.  These two routines _should_
remain within "#ifdef CONFIG_PM".

In the v1 patch you put them instead inside "#if defined(CONFIG_PM) ||
defined(CONFIG_PCI)"; that's what I didn't like.

Alan Stern

