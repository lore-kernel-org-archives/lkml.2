Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956Ab2BAVmU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Feb 2012 16:42:20 -0500
Received: from einhorn.in-berlin.de ([192.109.42.8]:51288 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756341Ab2BAVmQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Feb 2012 16:42:16 -0500
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Wed, 1 Feb 2012 22:41:56 +0100
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: Andy Grover <agrover@redhat.com>
Cc: Clemens Ladisch <clemens@ladisch.de>, Chris Boot <bootc@bootc.net>,
        target-devel@vger.kernel.org, linux1394-devel@lists.sourceforge.net,
        linux-scsi@vger.kernel.org, lkml <linux-kernel@vger.kernel.org>
Subject: Re: FireWire/SBP2 Target mode
Message-ID: <20120201224156.0773ebc6@stein>
In-Reply-To: <4F29978A.3010707@redhat.com>
References: <4E4BD560.4010806@bootc.net>
	<4E4D3B88.30003@ladisch.de>
	<4F29978A.3010707@redhat.com>
X-Mailer: Claws Mail 3.7.10 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Feb 01 Andy Grover wrote:
> You're saying the sbp2 protocol can theoretically be used other places
> besides firewire? I'd say put it all in the fabric module for now.

While SBP-2 is explicitly specified for IEEE 1394 a.k.a. FireWire only,
it could be used on any bus architecture which implements IEEE 1212
"Control and Status Registers (CSR) Architecture for Microcomputer
Buses".  But IEEE 1394 a.k.a. FireWire is nowadays the only remaining IEEE
1212 implementation, as far as I know.

On the other hand, the transport protocol SBP-2 can be used to encapsulate
various protocols besides SCSI.  A long time ago I heard that there were
SBP-2 printers that weren't SCSI printers, but I may have confused
something.

The current version of the protocol, SBP-3 which extends SBP-2
in an upwards compatible way, has been developed specifically in
order to transport AV/C command sets.  (AV/C is a set of specifications
from the 1394 Trade Association that build on top of IEC 61883 "Consumer
audio/video equipment - Digital interface" and is used for camcorders,
audio interfaces, studio-grade video equipment, TV set top boxes etc.)
But I am not aware of any existing SBP-3 target or SBP-3 initiator which
actually implements AV/C.

So in short,
  - SBP-2/3 is only used on the FireWire bus.
  - Potentially there could be SBP-2/3 targets or initiators that
    implement something else than SCSI.  But stock SBP-2/3 initiator
    drivers of popular OSs are SCSI initiators, and non-SCSI SBP-2/3
    targets are extremely rare or don't exist actually.
-- 
Stefan Richter
-=====-===-- --=- ----=
http://arcgraph.de/sr/
