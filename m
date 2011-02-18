Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755543Ab1BRDHz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Feb 2011 22:07:55 -0500
Received: from LUNGE.MIT.EDU ([18.54.1.69]:51783 "EHLO lunge.queued.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751630Ab1BRDHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Feb 2011 22:07:53 -0500
From: Andres Salomon <dilinger@queued.net>
To: Samuel Ortiz <sameo@linux.intel.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Subject: MFD sharing support (v3, full)
Date: Thu, 17 Feb 2011 19:07:07 -0800
Message-Id: <1297998456-7615-1-git-send-email-dilinger@queued.net>
X-Mailer: git-send-email 1.7.2.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Here's all of my third attempt at MFD cell sharing.  This includes all
parts; some of the patches from v2 are being resent without changes.  I
apologize for the noise, but since I screwed up the threading in the first 
batch and people were having trouble finding some of the patches, I figured
I'd resend everything together.  There are some changes in there as well;
they've been marked in commit messages.

This whole set does the following things:
 - make mfd_cell structs always accessible to platform devices
 - adjust the mfd_cell API to (hopefully) be cleaner, replacing platform_data
and driver_data with mfd_data
 - add wrapper functions to access mfd cell and data fields
 - adjust all mfd clients/drivers to use the new API
 - add a reference counting wrapper for mfd_cell's enable/disable hooks
 - add platform device sharing wrappers to allow mfd clients to create
   new platform devices (at the same time as platform drivers are being
   registered)
 - update the cs5535-mfd driver (and clients) to make use of the new
   sharing code

This effectively provides the ability for mfd clients to share a single 
mfd_cell, and provide the framework for mfd-core be handle shared hardware
resources.

