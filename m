Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab2DMDDs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Apr 2012 23:03:48 -0400
Received: from mail.linux-iscsi.org ([67.23.28.174]:35026 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752207Ab2DMDDq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Apr 2012 23:03:46 -0400
Subject: Re: [PATCH v3 00/11] firewire-sbp-target: FireWire SBP-2 SCSI
 target
From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
To: Chris Boot <bootc@bootc.net>
Cc: linux1394-devel@lists.sourceforge.net, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org, agrover@redhat.com, clemens@ladisch.de,
        stefanr@s5r6.in-berlin.de, Christoph Hellwig <hch@lst.de>
In-Reply-To: <1334154043-69076-1-git-send-email-bootc@bootc.net>
References: <1329317248-94128-1-git-send-email-bootc@bootc.net>
	 <1334154043-69076-1-git-send-email-bootc@bootc.net>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 12 Apr 2012 20:03:42 -0700
Message-ID: <1334286222.3137.4877.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-11 at 15:20 +0100, Chris Boot wrote:
> The FireWire SBP-2 Target is a driver for using an IEEE-1394 connection
> as a SCSI transport. This module uses the SCSI Target framework to
> expose LUNs to other machines attached to a FireWire bus, in effect
> acting as a FireWire hard disk similar to FireWire Target Disk mode on
> many Apple computers.
> 
> Sorry this latest revision has been a long time coming. I was trying to
> chase down a crashing bug (but haven't been able to replicate it), changed
> my mind about a large portion of the code twice, and life got in the way as
> well!
> 

Some very nice work to make this all go Chris..  8-)

Thanks again btw for your target_core_mod patches along the way to v3!

> Changes in v3:
> * Updates for target framework API changes
> * Attempt to make headers self-contained
> * Remove bad use of atomics and memory barriers
> * Rework use of locking
> * Use system workqueues
> * Wrap fw_run_transaction() to retry failed transactions
> * Coding style fixes
> * Fix a few bugs
> * Overhaul sbp_rw_data()
> * Overhaul target fetch agent
> 

So I've merged a squashed version this series from:

  https://github.com/bootc/Linux-SBP-2-Target.git patch-v3

into lio-core/master, and have now pushed to k.o upstream

This looks to me like a reasonable candidate for a v3.5 mainline merge,
so we need to go ahead and get this into target-pending..  Also, thanks
for getting Stefan's ACK's here on the drivers/firmware/ specific
changes..

So for new fabric drivers (as discused with Sebastian and usb-gadget
recently) that the target team has been enforcing that new fabric
modules convert to use a single source / header file for readability and
maintainability purposes.

It would be great if you can publish one more branch (no need to re-post
the full diff) that takes your patch-v3 down to a single .c/.h file.
Otherwise, I'm fine to take the 15 minutes to do this conversion ahead
of dropping into target-pending for the sunday night linux-next build.

Thanks again Chris!

--nab

