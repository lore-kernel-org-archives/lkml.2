Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753395Ab1GFOwF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 10:52:05 -0400
Received: from iolanthe.rowland.org ([192.131.102.54]:36690 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752067Ab1GFOwD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 10:52:03 -0400
Date: Wed, 6 Jul 2011 10:52:02 -0400 (EDT)
From: Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@iolanthe.rowland.org
To: Valdis.Kletnieks@vt.edu
cc: linux-kernel@vger.kernel.org, <linux-usb@vger.kernel.org>
Subject: Re: Weird USB over-current messages in recent kernels...
In-Reply-To: <61130.1309903710@turing-police.cc.vt.edu>
Message-ID: <Pine.LNX.4.44L0.1107061048160.1995-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Jul 2011 Valdis.Kletnieks@vt.edu wrote:

> Seen during boot the last few days on my laptop:
> 
> running 3.0.0-rc4-mmotm0622:
> Jul  2 13:08:37 turing-police kernel: [    2.788108] hub 2-0:1.0: over-current condition on port 1
> Jul  2 13:08:37 turing-police kernel: [    2.990088] hub 2-0:1.0: over-current condition on port 2
> Jul  2 13:08:37 turing-police kernel: [    3.193073] hub 6-0:1.0: over-current condition on port 1
> Jul  2 13:08:37 turing-police kernel: [    3.395088] hub 6-0:1.0: over-current condition on port 2
> 
> running 3.0.0-rc5-mmotm0630:
> Jul  5 09:43:36 turing-police kernel: [  203.686082] hub 6-0:1.0: over-current condition on port 1
> Jul  5 09:43:36 turing-police kernel: [  203.969179] hub 6-0:1.0: over-current condition on port 2
> Jul  5 09:43:36 turing-police kernel: [  204.217077] hub 6-0:1.0: over-current condition on port 1
> 
> The problem?  I don't see any devices that would *cause* the condition:

> The device 5 and 6 on bus 1 are attached to the docking station, the Jul 2 boot
> was undocked and those two devices weren't present. Nobody home on bus 2 or 6
> at any time, as far as I can tell.
> 
> Any ideas?

That message was added recently, which may explain why you haven't seen 
it before.

For more debugging, please collect a usbmon log for bus 2 or bus 6 (see 
Documentation/usb/usbmon.txt).  In fact, you might try doing this for 
an earlier kernel as well.

It may be that your host controllers claim that an over-current
condition exists when it really doesn't, or it may be that those ports
are wired incorrectly and really do have an over-current condition.

Alan Stern

