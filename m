Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089Ab1ERUAe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 May 2011 16:00:34 -0400
Received: from cantor.suse.de ([195.135.220.2]:36241 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752976Ab1ERUAb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 May 2011 16:00:31 -0400
Date: Wed, 18 May 2011 12:55:14 -0700
From: Greg KH <gregkh@suse.de>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        Milton Miller <miltonm@bga.com>, sparclinux@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>, Josip Rodin <joy@entuzijast.net>
Subject: Re: [PATCH 2/2] drivercore: revert addition of of_match to struct
 device
Message-ID: <20110518195514.GB28653@suse.de>
References: <20110518185751.28986.69446.stgit@ponder>
 <20110518192105.28986.53198.stgit@ponder>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110518192105.28986.53198.stgit@ponder>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 18, 2011 at 01:21:05PM -0600, Grant Likely wrote:
> Commit b826291c, "drivercore/dt: add a match table pointer to struct
> device" added an of_match pointer to struct device to cache the
> of_match_table entry discovered at driver match time.  This was unsafe
> because matching is not an atomic operation with probing a driver.  If
> two or more drivers are attempted to be matched to a driver at the
> same time, then the cached matching entry pointer could get
> overwritten.
> 
> This patch reverts the of_match cache pointer and reworks all users to
> call of_match_device() directly instead.
> 
> Signed-off-by: Grant Likely <grant.likely@secretlab.ca>

Acked-by: Greg Kroah-Hartman <gregkh@suse.de>
