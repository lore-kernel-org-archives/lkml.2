Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752250Ab0IMOQz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Sep 2010 10:16:55 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:39502 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752160Ab0IMOQw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Sep 2010 10:16:52 -0400
Date: Mon, 13 Sep 2010 10:16:51 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Jiri Slaby <jslaby@suse.cz>
cc: phil@ipom.com, <stable@kernel.org>, Greg KH <gregkh@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        Linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: [34-stable regression] USB delay init quirk causes device events
 loss
In-Reply-To: <4C8E0892.3000306@suse.cz>
Message-ID: <Pine.LNX.4.44L0.1009131014460.1584-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 13 Sep 2010, Jiri Slaby wrote:

> Hi,
> 
> this commit:
> commit 93362a875fc69881ae69299efaf19a55a1f57db0
> Author: Phil Dibowitz <phil@ipom.com>
> Date:   Thu Jul 22 00:05:01 2010 +0200
> 
>     USB delay init quirk for logitech Harmony 700-series devices
> 
> causes a lot of pain for users who loose events from their input devices:
> https://bugzilla.novell.com/show_bug.cgi?id=638200
> 
> opensuse 11.3 uses 2.6.34 stable and that's how the patch got there.
> Reverting it makes it work again.
> 
> The problem is that the patch shuffles with usb_detect_quirks which used
> to disable autosuspend by default. Apparently it no longer does.

I don't see how that patch could have the effect you claim.  
usb_detect_quirks still calls usb_disable_autosuspend.  Can you do a 
little more debugging to find out why it isn't working as expected?  
Reverting the commit is not a good solution.

Alan Stern

