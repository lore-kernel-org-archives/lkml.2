Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757591Ab1BLB5k (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 20:57:40 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:44812 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752521Ab1BLB5j (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 20:57:39 -0500
Date: Fri, 11 Feb 2011 17:57:35 -0800
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: linux-kernel@vger.kernel.org,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: [PATCH 0/17] mfd sharing support (v2, part 1)
Message-ID: <20110211175735.0d4258dc@queued.net>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.20.1; i486-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Here's my second attempt[0] of the MFD sharing.  Rather than go
through with the whole thing, this is just the part which makes
mfd_cells always available to MFD clients.  I'm planning to later 
remove driver_data, and just use a (renamed) platform_data as a
general cleanup, but for now..  Here's the first part.

Again, the goal here is to allow MFD clients to share MFD driver
resources.  Each platform device that an MFD driver creates has
the mfd_cell that created it located in its platform_data area.  For
drivers that were using the mfd_cell's platform_data field for other
purposes, this is now available by grabbing the mfd_cell and looking at
its platform_data field.

[0] first attempt -
http://thread.gmane.org/gmane.linux.kernel/1095524/focus=1095546
