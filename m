Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754131Ab1AXStJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jan 2011 13:49:09 -0500
Received: from mailout10.t-online.de ([194.25.134.21]:60930 "EHLO
	mailout10.t-online.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753562Ab1AXStH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jan 2011 13:49:07 -0500
Message-ID: <4D3DC997.5040605@t-online.de>
Date: Mon, 24 Jan 2011 19:48:55 +0100
From: Knut Petersen <Knut_Petersen@t-online.de>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
CC: Chris Wilson <chris@chris-wilson.co.uk>, jesse.barnes@intel.com
Subject: [BUG/REGRESSION] DRM / i915 / 2.6.37 and 2.6.38-rc*: DVI output gets
 disabled/reenabled under load
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
X-ID: T55qMrZvohKz5XVTsWSR8NXocwen65Bb2-9yLI1T0GMIi6WWvxRCmCfVlCZqTQ1wSO
X-TOI-MSGID: 17b00744-54b8-43df-8f31-a74a3818cb61
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On an AOpen i915GMm-HFS I see the following problem:
The LCD panel connected to DVI-1 gets disabled and then reenabled
under high system load (e.g. -j 15 kernel compile) if I am working on the
framebuffer console (no problems in X).

Kernels affected: 2.6.37, 2.6.38-rc1, 2.6.38-rc2
Kernel _not_ affected: 2.6.31.14, 2.6.36.3

Details: There is a DVI (DVI-1) connector and a VGA (VGA-1) connector
present.
The kernel also detects a connector VGA-2, but there is no hardware
connector for that.

I tried to bisect, but that did not provide a reasonable result because
of other problems
with the code.

Further inspection showed: The problem is related to the 10 second
connector rescan.

Idling at the prompt the status of VGA-2 is an almost stable
connector_status_unknown (3).
Under load that changes, the connector status is floating between
connector_status_unknown and connector_status_disconnected. During the
action
taken after a status changes DVI-1 temporarily gets disabled.

Disabling the connector rescan in the source code fixes the problem,
but obviously that is not the best possible fix ;-)

Knut
