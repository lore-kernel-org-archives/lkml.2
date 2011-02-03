Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751711Ab1BCUZW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 15:25:22 -0500
Received: from mgw2.diku.dk ([130.225.96.92]:34225 "EHLO mgw2.diku.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab1BCUZV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 15:25:21 -0500
Date: Thu, 3 Feb 2011 21:25:15 +0100 (CET)
From: Julia Lawall <julia@diku.dk>
To: linux-kernel@vger.kernel.org
Cc: greg@kroah.com
Subject: request_region/release_resource
Message-ID: <Pine.LNX.4.64.1102032124320.27852@ask.diku.dk>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is there any circumstance in which it is ok to call release_resource on 
the result of calling request(_mem)_region?  One issue is that 
release_resource doesn't free its argument, but then what if the call to 
release_resource is followed by a call to kfree?

Example:
drivers/watchdog/s3c2410_wdt.c, in the function s3c2410wdt_probe

thanks,
julia
