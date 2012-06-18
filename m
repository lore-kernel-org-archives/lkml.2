Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752386Ab2FROSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 10:18:44 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42482 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751212Ab2FROSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 10:18:43 -0400
Date: Mon, 18 Jun 2012 10:18:41 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mpn@google.com>
cc: Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/3] usb: gadget: mass_storage: require backing file for
 non-removable LUNs
In-Reply-To: <593bff689c31fefb07534e3f500d8a8c29fcdacb.1340022674.git.mina86@mina86.com>
Message-ID: <Pine.LNX.4.44L0.1206181016320.1591-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2012, Michal Nazarewicz wrote:

> From: Michal Nazarewicz <mina86@mina86.com>
> 
> The fsg_file_store() function does not check whether a LUN is removable or not
> allowing one to specify an empty file name for a non-removable LUN.  This
> commit adds explicit check of whether a file name is provided for
> non-removable LUNs.

Looks okay.  Note that in file_storage.c, the "file" attribute isn't 
writable if the LUN isn't removable, and the "ro" attribute isn't 
writable if the LUN is a cdrom.  Maybe you would prefer to do things 
that way instead.

Alan Stern

