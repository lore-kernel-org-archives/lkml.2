Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932685Ab0EMVyo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 17:54:44 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:51862 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932269Ab0EMVyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 17:54:41 -0400
Date: Thu, 13 May 2010 17:54:39 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Matt Reimer <mattjreimer@gmail.com>
cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       linux-kernel <linux-kernel@vger.kernel.org>,
       Jens Axboe <jens.axboe@oracle.com>,
       Maxim Levitsky <maximlevitsky@gmail.com>,
       linux-pm <linux-pm@lists.linux-foundation.org>,
       Andrew Morton <akpm@linux-foundation.org>, Pavel Machek <pavel@ucw.cz>
Subject: Re: [linux-pm] Is it supposed to be ok to call del_gendisk while 
 userspace is frozen?
In-Reply-To: <AANLkTimW3wLEt-DIRirHic1ZN1Z0k1t3TavwaCxTh_QL@mail.gmail.com>
Message-ID: <Pine.LNX.4.44L0.1005131752160.1731-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 May 2010, Matt Reimer wrote:

> So how does the attached patch look?
> 
> Matt
> 
> 
> From 20d8340471eb05aa54af1349f4ddccecd9c230c6 Mon Sep 17 00:00:00 2001
> From: Matt Reimer <mreimer@sdgsystems.com>
> Date: Thu, 13 May 2010 14:36:54 -0700
> Subject: [PATCH] fs: prevent hang on suspend/resume when MMC/SD card present
> 
> Devices can come and go from the MMC/SD bus during suspend or resume,
> when the writeback thread is frozen, resulting in a hang. So thaw the
> writeback thread in del_gendisk() to prevent the hang.

I don't see anything wrong with the patch itself, but I dislike the 
description.  Devices can come and go from any hotpluggable bus, not 
just MMC/SD.  That just happens to be the first place the problem was 
observed.

Alan Stern

