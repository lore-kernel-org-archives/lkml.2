Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756714Ab1DZOvI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 10:51:08 -0400
Received: from casper.infradead.org ([85.118.1.10]:57402 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755490Ab1DZOvH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 10:51:07 -0400
Subject: Re: [PATCH 00/13] Swap-over-NBD without deadlocking
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Mel Gorman <mgorman@suse.de>
Cc: Linux-MM <linux-mm@kvack.org>, Linux-Netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        David Miller <davem@davemloft.net>, Neil Brown <neilb@suse.de>
In-Reply-To: <20110426144635.GK4658@suse.de>
References: <1303803414-5937-1-git-send-email-mgorman@suse.de>
	 <1303827785.20212.266.camel@twins>  <20110426144635.GK4658@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 26 Apr 2011 16:50:49 +0200
Message-ID: <1303829449.20212.285.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 15:46 +0100, Mel Gorman wrote:
> 
> I did find that only a few route-cache entries should be required. In
> the original patches I worked with, there was a reservation for the
> maximum possible number of route-cache entries. I thought this was
> overkill and instead reserved 1-per-active-swapfile-backed-by-NFS.

Right, so the thing I was worried about was a route-cache poison attack
where someone would spam the machine such that it would create a lot of
route cache entries and might flush the one we needed just as we needed
it.

Pinning the one entry we need would solve that (if possible).
