Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752838Ab0E3SGX (ORCPT <rfc822;w@1wt.eu>);
	Sun, 30 May 2010 14:06:23 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:58931 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752528Ab0E3SGV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 30 May 2010 14:06:21 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sun, 30 May 2010 19:56:55 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] firewire: core: check for 1394a compliant IRM, fix
 inaccessibility of Sony camcorder
To: linux1394-devel@lists.sourceforge.net
cc: linux-kernel@vger.kernel.org, Clemens Ladisch <clemens@ladisch.de>
In-Reply-To: <tkrat.740b506673ccbf6d@s5r6.in-berlin.de>
Message-ID: <tkrat.e4ca403b4d64cca4@s5r6.in-berlin.de>
References: <AANLkTimIFRbKWYjFd56acxT2A6nnH6l3-7Q_UyORnonW@mail.gmail.com>
 <4C017477.8000008@s5r6.in-berlin.de> <4C0284E7.3050803@s5r6.in-berlin.de>
 <tkrat.740b506673ccbf6d@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Per IEEE 1394 clause 8.4.2.3, a contender for the IRM role shall check
> whether the current IRM complies to 1394a-2000 or later.  If not force a
> compliant node (e.g. itself) to become IRM.  This was implemented in the
> older ieee1394 driver but not yet in firewire-core.

While I don't have an IRM that features the DCR-TRV25 bug, I did at
least quick tests of the patch with the following consistent results:
  - Joined three nodes to a bus, only one node of them IRM capable,
    but being a 1394-1995-only implementation.
  - Plugged in Linux node into this bus, got the following log:
        firewire_ohci: isochronous cycle inconsistent
        firewire_core: created device fw8: GUID 00d04b21010212c8, S400
        firewire_core: created device fw9: GUID 008088030960484b, S100
        firewire_core: phy config: card 4, new root=ffc3, gap_count=7
        firewire_core: IRM is not 1394a compliant, making local node (ffc1) root.
        firewire_core: phy config: card 4, new root=ffc1, gap_count=7
    and all is well as far as kernel, gscanbus, and Kino can tell.
-- 
Stefan Richter
-=====-==-=- -=-= ====-
http://arcgraph.de/sr/

