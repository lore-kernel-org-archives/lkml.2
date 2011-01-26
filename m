Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab1AZQwS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 11:52:18 -0500
Received: from mga09.intel.com ([134.134.136.24]:37437 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517Ab1AZQwR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 11:52:17 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,380,1291622400"; 
   d="scan'208";a="596683366"
Date: Wed, 26 Jan 2011 08:52:24 -0800
From: Andi Kleen <ak@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/20] hpfs: replace BKL with a global mutex
Message-ID: <20110126165223.GA6695@tassilo.jf.intel.com>
References: <1295993854-4971-1-git-send-email-arnd@arndb.de>
 <1295993854-4971-11-git-send-email-arnd@arndb.de>
 <m2ipxc34aq.fsf@linux.intel.com>
 <201101261350.42789.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201101261350.42789.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 01:50:42PM +0100, Arnd Bergmann wrote:
> On Wednesday 26 January 2011, Andi Kleen wrote:
> > I don't think that's a very good idea, there's danger
> > of holding it over IO and that would be really bad (as in like MINIX[1])
> > 
> > It would be better to do it the i810 way and check for the number of
> > CPUs at module init time and refuse to run if it's > 1
> 
> I don't see much value of one evil over the other, but why not. The code
> is going away anyway unless someone cleans it up further.

I think it's fine because systems running OS/2 likely only have
one CPU. This way these guys (if they exist) won't see any regression.

-Andi
-- 
Andi Kleen
Intel Open Source Technology Center
