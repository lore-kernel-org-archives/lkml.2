Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755250Ab2LRQFq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 11:05:46 -0500
Received: from iolanthe.rowland.org ([192.131.102.54]:43150 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755101Ab2LRQFp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 11:05:45 -0500
Date: Tue, 18 Dec 2012 11:05:44 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Venu Byravarasu <vbyravarasu@nvidia.com>
cc: swarren@wwwdotorg.org, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] usb: host: tegra: make use of PHY pointer of HCD
In-Reply-To: <1355813736-2487-1-git-send-email-vbyravarasu@nvidia.com>
Message-ID: <Pine.LNX.4.44L0.1212181105210.1604-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 18 Dec 2012, Venu Byravarasu wrote:

> As pointer to PHY structure can be stored in struct usb_hcd
> making use of it, to call PHY APIs.
> 
> Call to usb_phy_shutdown() is moved up in tegra_ehci_remove(),
> so that to avoid dereferencing of hcd after its freed up.
> 
> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
> ---
> This patch depends on patch http://marc.info/?l=linux-kernel&m=135581274019690&w=2.
> Without above patch applied, phy->notify_connect & phy->notify_disconnect are
> set to some unknown values, which need not be NULL.
> This creates problem when hcd->phy pointer is initialized hub_port_init() in hub.c
> calls usb_phy_notify_connect().
> 
> Stephen,
> Can you plz take this patch through tegra tree, so as to take care of the dependencies?

Acked-by: Alan Stern <stern@rowland.harvard.edu>

