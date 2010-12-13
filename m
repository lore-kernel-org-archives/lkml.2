Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758257Ab0LMQzd (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 11:55:33 -0500
Received: from netrider.rowland.org ([192.131.102.5]:40817 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754018Ab0LMQzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 11:55:31 -0500
Date: Mon, 13 Dec 2010 11:55:30 -0500 (EST)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Pete Zaitcev <zaitcev@redhat.com>
cc: morroww6@netscape.net, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <nm127@freemail.hu>
Subject: Re: [PATCH 1/1] usbmon:  usb monitor binary data incorrectly reported
 for isoc transfers
In-Reply-To: <20101212232705.4d14e89c@lembas.zaitcev.lan>
Message-ID: <Pine.LNX.4.44L0.1012131151100.17079-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 12 Dec 2010, Pete Zaitcev wrote:

> This looks obviously incorrect. If anyone ever submits an ISO with
> the newfanged s/g URB, we're going to copy the scatterlist (if not
> crash).

That won't happen.  We support scatter-gather URBs really just for bulk
transfers.  They can also be used for interrupt (though I don't know
why anyone would want to), and just possibly for control (not supported
by all HCDs), but not for isochronous transfers.

Alan Stern

