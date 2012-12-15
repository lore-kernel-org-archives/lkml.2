Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756447Ab2LOMe2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Dec 2012 07:34:28 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:54098 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751968Ab2LOMe0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Dec 2012 07:34:26 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 15 Dec 2012 13:34:10 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Peter Hurley <peter@hurleysoftware.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux1394-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] staging/fwserial: Drop suggestion for helper fn
 integration
Message-ID: <20121215133410.0b6add5c@stein>
In-Reply-To: <1355551400-8204-7-git-send-email-peter@hurleysoftware.com>
References: <1355551400-8204-1-git-send-email-peter@hurleysoftware.com>
	<1355551400-8204-7-git-send-email-peter@hurleysoftware.com>
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.12; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Dec 15 Peter Hurley wrote:
> The firewire core does not require or want the suggested helper fns;
> drop suggestion from TODO file.

It's not about the core, but about what the highlevel drivers need.
(I.e. protocol drivers and some higherlevel parts of the core, e.g.
the userspace driver interface.)

If it is something which two or more drivers use, it goes into the core.
(Or into a library, as Clemens did with snd-firewire-lib.)  If it is
something which needs assistance by the lowlevel driver, it goes into the
core or passes through the core, regardless whether one or more protocol
drivers need it.  (Example:  Physical DMA filtering for the SBP-2
initiator driver.)  If it is something very complicated and 1394
architecture specific, but still only needed by one highlevel driver, I
for one am more comfortable with leaving this in the respective driver
rather than moving this into the core.

The packet payload calculation is a 1394 architecture arcanum and is needed
in on form or another in more than one driver (firewire-net, -sbp2, and
now fwserial).  But as discussed, what they precisely need in the end
differs to a degree that leaves nothing substantial to share.

[That's too many words about a two- or three-line piece of code; but on the
on the other hand it is a generally relevant consideration whenever new
functionality is to be added somewhere in the driver stack.]
-- 
Stefan Richter
-=====-===-- ==-- -====
http://arcgraph.de/sr/
