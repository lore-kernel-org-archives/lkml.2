Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754091Ab0CQOay (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 10:30:54 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:58932 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753949Ab0CQOax (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 10:30:53 -0400
Date: Wed, 17 Mar 2010 10:30:52 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jason Wessel <jason.wessel@windriver.com>
cc: gregkh@suse.de, <linux-usb@vger.kernel.org>,
       <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] V2 usb console improvements series
In-Reply-To: <1268773546-12457-1-git-send-email-jason.wessel@windriver.com>
Message-ID: <Pine.LNX.4.44L0.1003171027501.1734-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 16 Mar 2010, Jason Wessel wrote:

> Part of having the console stable requires that usb sysrq handler get
> executed in a tasklet.  The hcd device lock is always held while the
> driver call backs are executed.  The means you cannot get the sysrq
> printk's out to the usb console device after the in_flight urb queue
> is filled.

Either I don't understand this comment properly or else it is simply
wrong.  HCDs do not continue to hold their locks when handing completed
URBs back to drivers.  The giveback call occurs with interrupts
disabled, but no locks are held.

Does this mean one of the patches in your series can be simplified?

Alan Stern

