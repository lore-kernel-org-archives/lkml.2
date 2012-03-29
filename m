Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760367Ab2C2XVX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Mar 2012 19:21:23 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60670
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760289Ab2C2XVS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Mar 2012 19:21:18 -0400
Date: Thu, 29 Mar 2012 19:21:14 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, xfs-masters@oss.sgi.com
Subject: Re: [PATCH 05/13] XFS: Fix lock ASSERT on UP
Message-ID: <20120329232114.GA26342@infradead.org>
References: <1332895637-32572-1-git-send-email-andi@firstfloor.org>
 <1332895637-32572-6-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1332895637-32572-6-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 27, 2012 at 05:47:09PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> ASSERT(!spin_is_locked()) doesn't work on UP builds. Replace with a standard
> lockdep_assert_held()

The "standard" is assert_spin_locked() - which not only is much cheaper
but also has the advantage of working in non-lockdep builds.

