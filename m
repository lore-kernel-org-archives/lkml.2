Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752778Ab0G0Rbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 13:31:37 -0400
Received: from tex.lwn.net ([70.33.254.29]:56720 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751648Ab0G0Rbg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 13:31:36 -0400
Date: Tue, 27 Jul 2010 11:31:33 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Israel Schlesinger <israels@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, apw@canonical.com, akpm@linux-foundation.org,
        joe@perches.com
Subject: Re: [PATCH] checkpatch: Add warnings for use of mdelay()
Message-ID: <20100727113133.1605c9fe@bike.lwn.net>
In-Reply-To: <4C4F132F.6020401@codeaurora.org>
References: <4C4F132F.6020401@codeaurora.org>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.21.5; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Jul 2010 10:11:11 -0700
Israel Schlesinger <israels@codeaurora.org> wrote:

> mdelay is a busy-wait loop which is wasteful. If at all possible,
> callers should use msleep instead of mdelay.
> 
> The only time mdelay is really appropriate is in atomic context,
> however, delays of 1ms+ in atomic context are rather expensive, so
> a warning for this case is probably appropriate as well to encourage
> people to move such expensive delays outside of atomic context

Once upon a time, msleep(1) would sleep for 20ms, while mdelay(1) gave
a 1ms delay.  My patch to fix msleep() at that time didn't get in due
to concerns about the cost of using hrtimers.  Perhaps msleep() has
gotten better, but, if not, actually getting a 1ms delay remains a
valid reason for using mdelay() instead IMO.  It made a difference of a
few seconds at open time for a driver I was doing at the time.

jon
