Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751255Ab1GRVMh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jul 2011 17:12:37 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:60261 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751103Ab1GRVMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jul 2011 17:12:36 -0400
Date: Mon, 18 Jul 2011 17:12:35 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Seth Forshee <seth.forshee@canonical.com>
cc: Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@suse.de>, <linux-usb@vger.kernel.org>,
        <usb-storage@lists.one-eyed-alien.net>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] usb_storage: make usb-stor-scan task non-freezable
In-Reply-To: <20110718162818.GC19552@thinkpad-t410>
Message-ID: <Pine.LNX.4.44L0.1107181708590.1663-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jul 2011, Seth Forshee wrote:

> The following patch is in response to a consistently reproducible
> failure to freeze tasks prior to restoring a hibernation image on a
> Toshiba NB505 netbook. This machine has a built-in USB card reader.
> Since the usb-stor-scan task is freezable but the code in
> quiesce_and_remove_host() that waits for scanning to complete is not,
> khubd can fail to freeze when processing the disconnect for the card
> reader.

What card-reader disconnect?

> It seems that both should either be freezable or not freezable. Since
> there doesn't currently seem to be any freezable way to wait on a
> completion, I started with the simpler approach of making usb-stor-scan
> non-freezable. If it would be preferable to make both freezable I can
> take that approach instead.

I'm not sure what the best approach is.  usb-stor-scan has to be
freezable, because the scanning code registers new child device
structures, which isn't allowed during suspend or hibernation.

Alan Stern

