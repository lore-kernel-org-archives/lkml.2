Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755988Ab0FXPxx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jun 2010 11:53:53 -0400
Received: from cantor2.suse.de ([195.135.220.15]:60060 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754671Ab0FXPxw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jun 2010 11:53:52 -0400
Date: Fri, 25 Jun 2010 01:53:49 +1000
From: Nick Piggin <npiggin@suse.de>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
       John Stultz <johnstul@us.ibm.com>, Frank Mayhar <fmayhar@google.com>
Subject: Re: [patch 14/52] fs: dcache scale subdirs
Message-ID: <20100624155349.GJ10441@laptop>
References: <20100624030212.676457061@suse.de>
 <20100624030727.818410048@suse.de>
 <87pqzgaheu.fsf@basil.nowhere.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pqzgaheu.fsf@basil.nowhere.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 24, 2010 at 11:50:17AM +0200, Andi Kleen wrote:
> npiggin@suse.de writes:
> 
> > Protect d_subdirs and d_child with d_lock, except in filesystems that aren't
> > using dcache_lock for these anyway (eg. using i_mutex).
> 
> Different locking for different file systems seems a bit confusing.
> Could the be unified?

Yes well it is a bit misleading. It should always be modified under
spinlocks, but some filesystems are using i_mutex for read access,
which should be fine (and not require knowledge of any other code).

