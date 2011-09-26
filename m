Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab1IZHNZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Sep 2011 03:13:25 -0400
Received: from rrzmta2.uni-regensburg.de ([194.94.155.52]:57663 "EHLO
	rrzmta2.uni-regensburg.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933Ab1IZHNY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Sep 2011 03:13:24 -0400
Message-Id: <4E80422B020000A1000077F2@gwsmtp1.uni-regensburg.de>
X-Mailer: Novell GroupWise Internet Agent 12.0.0 Beta 
Date: Mon, 26 Sep 2011 09:13:15 +0200
From: "Ulrich Windl" <Ulrich.Windl@rz.uni-regensburg.de>
To: <linux-kernel@vger.kernel.org>
Subject: Q: I/O schedulers
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

I hope this mail will make it after kernel.org seems do be down for weeks now...

I have a question on I/O schedulers: I/O schedulers work for a single block device (more or less). Now I wonder: is there any attempt to accieve fairness across several block devices that use the same I/O channel?

The background is this: We have a huge SAN disk system that can deviver about 380MB/s through a 4Gb/s FC-Connection. One Linux system alone can pull that from the box. Now such a single Linux system uses some ten virtual disks from the SAN box. When a huge file (several GB) is copied from one SAN disk to another one the same box), at some point I/O gets very slow, and some commands seem unresponsive for several seconds (e.g. more than 60 seconds). Alltogether about 20 machines are connected to that SAN disk system.

Is there any attempt to give every block device using a specific HBA a fair share of the bandwidth? Also, what could be done in the current code to prevent such a situation. I suspect the problem are asynchronous buffer flushs combined with a lot of memory (> 100GB).

Please CC: any replies to me as I'm not subscribed to this list.

Regards,
Ulrich


