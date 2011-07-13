Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752281Ab1GMMne (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jul 2011 08:43:34 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:34049 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752005Ab1GMMnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jul 2011 08:43:33 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 13 Jul 2011 14:41:19 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Boaz Harrosh <bharrosh@panasas.com>, Benny Halevy <bhalevy@panasas.com>,
        osd-dev@open-osd.org
Cc: Jonathan Cameron <jic23@cam.ac.uk>, LKML <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Subject: Re: RFC: Boiler plate functions for ida / idr allocation?
Message-ID: <20110713144119.6e28dc03@stein>
In-Reply-To: <4E1D6900.6040500@cam.ac.uk>
References: <4E1D6900.6040500@cam.ac.uk>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.4; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jul 13 Jonathan Cameron wrote at LKML:
[...]
> Taking ida's first, how about the following patch?  I'm not at
> all attached to the form it takes, merely to cutting out on the
> cut and paste.
> 
> Note I've done only a few random places.  There aren't that many ida
> users and I've only played with that for now.
> 
> Remaining ida cases:
> 
> drivers/gpu/drm/vmwgfx/vmwgfx_gmrid_manager.c:  (cleans up in case of out of range)
> drivers/scsi/osd/osd_uld.c: (locks not taken)
[...]

Boaz, Benny,

osd_uld.c::osd_minor_ida is accessed unsafely.
Device probe() and remove() methods are not globally serialized.
-- 
Stefan Richter
-=====-==-== -=== -==-=
http://arcgraph.de/sr/
