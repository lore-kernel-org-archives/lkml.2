Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759283Ab1CaT21 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Mar 2011 15:28:27 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:54434 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759227Ab1CaT2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Mar 2011 15:28:24 -0400
X-Authority-Analysis: v=1.1 cv=qyUSAyc82z9xLljZQc9ErY9Tl2GSEfqK/XYZS35I9d8= c=1 sm=0 a=XYJHFtupD_QA:10 a=ufTYwEEDWR0A:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=2bW5aYeME0AoosgiAIAA:9 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Thu, 31 Mar 2011 15:28:21 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Michal Nazarewicz <mina86@mina86.com>
Cc: Marek Szyprowski <m.szyprowski@samsung.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-media@vger.kernel.org,
        linux-mm@kvack.org, Kyungmin Park <kyungmin.park@samsung.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Ankita Garg <ankita@in.ibm.com>,
        Daniel Walker <dwalker@codeaurora.org>,
        Johan MOSSBERG <johan.xx.mossberg@stericsson.com>,
        Mel Gorman <mel@csn.ul.ie>, Pawel Osciak <pawel@osciak.com>
Subject: Re: [PATCH 05/12] mm: alloc_contig_range() added
Message-ID: <20110331192821.GF14441@home.goodmis.org>
References: <1301577368-16095-1-git-send-email-m.szyprowski@samsung.com>
 <1301577368-16095-6-git-send-email-m.szyprowski@samsung.com>
 <1301587361.31087.1040.camel@nimitz>
 <op.vs7umufd3l0zgt@mnazarewicz-glaptop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <op.vs7umufd3l0zgt@mnazarewicz-glaptop>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 31, 2011 at 06:26:45PM +0200, Michal Nazarewicz wrote:
> >In any case, please pull the ++ret bit out of the WARN_ON().  Some
> >people like to do:
> >
> >#define WARN_ON(...) do{}while(0)
> >
> >to save space on some systems.
> 
> I don't think that's the case.  Even if WARN_ON() decides not to print
> a warning, it will still return the value of the argument.  If not,
> a lot of code will brake.
>

WARN_ON() should never do anything but test. That ret++ does not belong
inside the WARN_ON() condition. If there are other locations in the
kernel that do that, then those locations need to be fixed.

-- Steve

