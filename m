Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755683Ab0KBDxk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 23:53:40 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42896 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755511Ab0KBDxg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 23:53:36 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Daniel Taylor" <Daniel.Taylor@wdc.com>
Subject: Re: hibernate and file system/metadisk driver buffers/caches
Date: Tue, 2 Nov 2010 04:52:45 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.36-rjw+; KDE/4.4.4; x86_64; ; )
Cc: linux-kernel@vger.kernel.org
References: <25B374CC0D9DFB4698BB331F82CD0CF20D601F@wdscexbe08.sc.wdc.com>
In-Reply-To: <25B374CC0D9DFB4698BB331F82CD0CF20D601F@wdscexbe08.sc.wdc.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201011020452.45203.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 01, 2010, Daniel Taylor wrote:
> From what I have found in Documentation/power, I should be
> able to hibernate a system to a partition on flash, and
> resume it, preserving its entire state.
> 
> In case I missed something, though, does anyone know if,
> in particular, MD stripe buffers are preserved, as well
> as the EXTn/XFS buffers/caches?  I think I read that I/O
> buffers in use by drivers are saved only if the driver
> has the appropriate suspend() interfaces.

The entire contents of memory at the moment the image is created are saved.
However, we need room for the image, so we free approximately 50% of memory
before creating the image by creating artificial memory pressure.

Thanks,
Rafael
