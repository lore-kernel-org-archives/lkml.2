Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752106Ab0HSJ2D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 05:28:03 -0400
Received: from alpha.arachsys.com ([91.203.57.7]:49615 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752037Ab0HSJ17 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 05:27:59 -0400
Date: Thu, 19 Aug 2010 10:25:36 +0100
From: Chris Webb <chris@arachsys.com>
To: Balbir Singh <balbir@linux.vnet.ibm.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Wu Fengguang <fengguang.wu@intel.com>,
        Minchan Kim <minchan.kim@gmail.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Subject: Re: Over-eager swapping
Message-ID: <20100819092536.GH2370@arachsys.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100819051339.GH28417@balbir.in.ibm.com>
 <20100818164539.GG28417@balbir.in.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Balbir Singh <balbir@linux.vnet.ibm.com> writes:

> Can you give an idea of what the meminfo inside the guest looks like.

Sorry for the slow reply here. Unfortunately not, as these guests are run on
behalf of customers. They install them with operating systems of their
choice, and run them on our service.

> Have you looked at
> http://kerneltrap.org/mailarchive/linux-kernel/2010/6/8/4580772

Yes, I've been watching this discussions with interest. Our application is
one where we have little to no control over what goes on inside the guests,
but these sorts of things definitely make sense where the two are under the
same administrative control.

> Do we have reason to believe the problem can be solved entirely in the
> host?

It's not clear to me why this should be difficult, given that the total size
of vm allocated to guests (and system processes) is always strictly less
than the total amount of RAM available in the host. I do understand that it
won't allow for as impressive overcommit (except by ksm) or be as efficient,
because file-backed guest pages won't get evicted by pressure in the host as
they are indistinguishable from anonymous pages.

After all, a solution that isn't ideal, but does work, is to turn off swap
completely! This is what we've been doing to date. The only problem with
this is that we can't dip into swap in an emergency if there's no swap there
at all.

Best wishes,

Chris.
