Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751667Ab2HSALQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Aug 2012 20:11:16 -0400
Received: from netrider.rowland.org ([192.131.102.5]:34371 "HELO
	netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751220Ab2HSALO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Aug 2012 20:11:14 -0400
Date: Sat, 18 Aug 2012 20:11:13 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To: Bruno =?UTF-8?B?UHLDqW1vbnQ=?= <bonbons@linux-vserver.org>
cc: Jiri Kosina <jkosina@suse.cz>, <linux-input@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fbdev@vger.kernel.org>
Subject: Re: [PATCH 0/7] HID: picoLCD updates
In-Reply-To: <20120818154828.0e992bfe@neptune.home>
Message-ID: <Pine.LNX.4.44L0.1208182001320.25537-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 18 Aug 2012, Bruno Prémont wrote:

> One thing I just though about, how does usbhid handle the calls to
> usbhid_submit_report() when hid_hw_stop()/hid_hw_close() have already
> been called?

Looks like they aren't synchronized at all.  That's a bug.  
usbhid_submit_report() should check the HID_DISCONNECTED flag.

> I will attempt to see if it makes a difference to shortcut my
> usbhid_submit_report() calls from the point on I have called hid_hw_close()...

I don't know bout hid_hw_close().  Certainly no more reports should be 
submitted following usbhid_stop().

Alan Stern

