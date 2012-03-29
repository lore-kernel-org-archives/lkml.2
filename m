Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933561Ab2C2XwQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 19:52:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:57637 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753865Ab2C2XwH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 19:52:07 -0400
Date: Fri, 30 Mar 2012 01:52:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Christoph Hellwig <hch@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        xfs-masters@oss.sgi.com
Subject: Re: [PATCH 05/13] XFS: Fix lock ASSERT on UP
Message-ID: <20120329235201.GF17822@one.firstfloor.org>
References: <1332895637-32572-1-git-send-email-andi@firstfloor.org> <1332895637-32572-6-git-send-email-andi@firstfloor.org> <20120329232114.GA26342@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120329232114.GA26342@infradead.org>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 29, 2012 at 07:21:14PM -0400, Christoph Hellwig wrote:
> On Tue, Mar 27, 2012 at 05:47:09PM -0700, Andi Kleen wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> > 
> > ASSERT(!spin_is_locked()) doesn't work on UP builds. Replace with a standard
> > lockdep_assert_held()
> 
> The "standard" is assert_spin_locked() - which not only is much cheaper
> but also has the advantage of working in non-lockdep builds.

But then you have it unconditional, not just on debug builds.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
