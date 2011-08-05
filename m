Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756846Ab1HEPXk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Aug 2011 11:23:40 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:38622 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753585Ab1HEPXj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Aug 2011 11:23:39 -0400
Date: Fri, 5 Aug 2011 16:23:38 +0100
From: Al Viro <viro@ZenIV.linux.org.uk>
To: Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Q: cat /proc/mdstat blocking?
Message-ID: <20110805152338.GU2203@ZenIV.linux.org.uk>
References: <4E3BF809020000A100006CDF@gwsmtp1.uni-regensburg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3BF809020000A100006CDF@gwsmtp1.uni-regensburg.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 05, 2011 at 02:02:49PM +0200, Ulrich Windl wrote:
> Hi,
> 
> I thought that /proc/mdstat just displays the current state of the MD RAIDs, not querying them, thus never blocking. Unfortunately I could observer a "cat /proc/mdstat" hanging for several seconds when one of the RAID1 legs was unavailable and multipathd was queueing requests to the leg.
> 
> Practically this makes monitoring of the other RAIDs difficult when one bad device is enough to block /proc/mdstat.
> 
> Now my question: Does it work as designed (i.e. as intended), or is this not as intended?

I suspect that something is holding all_mddevs_lock too long; that, or one
of the subdrivers' spinlocks.  Try to find out what it blocks on and what
holds the lock in question...
