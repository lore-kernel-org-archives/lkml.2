Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142Ab2GZNtb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jul 2012 09:49:31 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:35119 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751220Ab2GZNt3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jul 2012 09:49:29 -0400
Date: Thu, 26 Jul 2012 08:49:26 -0500
From: Seth Forshee <seth.forshee@canonical.com>
To: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>,
        Arend van Spriel <arend@broadcom.com>
Subject: Re: [BUG] Problem with commit
 cf03c5dac83609f09d9f0e9fa3c09d86daed614d
Message-ID: <20120726134926.GA10452@thinkpad-t410>
Mail-Followup-To: Dirk Gouders <gouders@et.bocholt.fh-gelsenkirchen.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Arend van Spriel <arend@broadcom.com>
References: <gik3xqtzw3.fsf@karga.hank.lab>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <gik3xqtzw3.fsf@karga.hank.lab>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 26, 2012 at 03:28:44PM +0200, Dirk Gouders wrote:
> Hi Seth,
> 
> today, I noticed a problem with the current kernel
> (3.5.0-04773-gbdc0077): my laptop hangs during boot -- the last message
> on the console is printed just before invoking `udevadm trigger'.
> 
> I bisected the problem and ended at commit
> cf03c5dac83609f09d9f0e9fa3c09d86daed614d (brcm80211: smac: inform
> mac80211 of the X2 regulatory domain).  However, I'm not sure that this
> commit really is the reason for my problems, because the behaviour is a
> bit different: at that state the machine not just hangs but the console
> shows a trace which I append to the end of this mail -- but the trace
> happens at the same state during the boot process.

Hi Dirk,

The NULL pointer dereference in wlc_phy_chanspec_band_validch is already
fixed in edc7651f3a4ffa7fca37d92401562694121512ad. There was also
another related crash that appeared after the introduction of 802.11ad
support that's fixed in 32c336a5dfd16b4645c8a0dbc534efd02f079e02.

So in all likelihood whatever problem your seeing in current -git is a
different issue. One easy way to test this would be to prevent the
brcmsmac module from loading and verify that you still get the hang,
then rerun the bisection that way to keep those bugs from affecting your
results.

Cheers,
Seth

