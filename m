Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752367Ab2FROUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 10:20:46 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:42487 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752460Ab2FROUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 10:20:44 -0400
Date: Mon, 18 Jun 2012 10:20:43 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Michal Nazarewicz <mpn@google.com>
cc: Felipe Balbi <balbi@ti.com>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: =?UTF-8?q?=5BPATCH=202/3=5D=20usb=3A=20gadget=3A=20mass=5Fstorage=3A=20fail=20fsg=5Fstore=5Ffile=28=29=20early=20if=20colud=20not=20open=20file?=
In-Reply-To: <3d80ba5730fb74945ee903664e57f257507bc47c.1340022674.git.mina86@mina86.com>
Message-ID: <Pine.LNX.4.44L0.1206181020240.1591-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Jun 2012, Michal Nazarewicz wrote:

> From: Michal Nazarewicz <mina86@mina86.com>
> 
> Currently, when a new value is stored to the “file” sysfs entry,
> fsg_store_file() will release existing backing file and only then attempt to
> open a new one.  If that fails, no new backing file is open.
> 
> This commit changes the fsg_lun_open() so that it closes existing backing file
> only after the new backing file has been successfully opened.  With that
> change, fsg_store_file() may use it to perform an atomic open operation with
> guarantee that logical unit will either point to the new backing file or still
> to the old one.

This is a good idea.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

