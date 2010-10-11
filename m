Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576Ab0JKVkD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Oct 2010 17:40:03 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:38326 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756523Ab0JKVkC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Oct 2010 17:40:02 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Mon, 11 Oct 2010 23:39:46 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: sbp2: parallelize login/inquiry, reconnect, and
 shutdown
To: Tejun Heo <tj@kernel.org>
cc: linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
In-Reply-To: <tkrat.1386de42b88d7218@s5r6.in-berlin.de>
Message-ID: <tkrat.dd9197843f6a0a54@s5r6.in-berlin.de>
References: <tkrat.06dc43b96f9ab9bf@s5r6.in-berlin.de>
 <tkrat.1433473bc081daa9@s5r6.in-berlin.de> <4CB3148C.5040902@kernel.org>
 <tkrat.1386de42b88d7218@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Stefan Richter wrote:
> There are indeed situations where the last module reference was already
> put down before the work is run for the last time.  Thanks for the hint.
> 
> What is preferable, an own workqueue instance whose destroy_workqueue()
> lets sbp2_cleanup wait for unfinished work, or module ref-counting like
> below?

Anoher thing:  Somebody might have swap space on a FireWire disk.  Yet
the system workqueues that firewire-core and (perhaps) firewire-sbp2 are
using are created without WQ_RESCUER.

Does this --- fringe use case as it might be --- call for private
workqueues in firewire-core (for fw_device.work) and firewire-sbp2 (for
sbp2_logical_unit.work)?

Besides the less interesting cases of device discovery and shutdown,
both of these works are also involved in SBP reconnect which needs to be
performed at each FireWire bus reset (which can happen anytime for a
variety of reasons).
-- 
Stefan Richter
-=====-==-=- =-=- -=-==
http://arcgraph.de/sr/

