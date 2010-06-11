Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760053Ab0FKB7F (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jun 2010 21:59:05 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:48822 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754442Ab0FKB7C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jun 2010 21:59:02 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Fri, 11 Jun 2010 10:54:41 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: balbir@linux.vnet.ibm.com, Avi Kivity <avi@redhat.com>,
       kvm <kvm@vger.kernel.org>, linux-mm@kvack.org,
       linux-kernel@vger.kernel.org
Subject: Re: [RFC/T/D][PATCH 2/2] Linux/Guest cooperative unmapped page
 cache control
Message-Id: <20100611105441.ee657515.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <1276214852.6437.1427.camel@nimitz>
References: <20100608155140.3749.74418.sendpatchset@L34Z31A.ibm.com>
	<20100608155153.3749.31669.sendpatchset@L34Z31A.ibm.com>
	<4C10B3AF.7020908@redhat.com>
	<20100610142512.GB5191@balbir.in.ibm.com>
	<1276214852.6437.1427.camel@nimitz>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010 17:07:32 -0700
Dave Hansen <dave@linux.vnet.ibm.com> wrote:

> On Thu, 2010-06-10 at 19:55 +0530, Balbir Singh wrote:
> > > I'm not sure victimizing unmapped cache pages is a good idea.
> > > Shouldn't page selection use the LRU for recency information instead
> > > of the cost of guest reclaim?  Dropping a frequently used unmapped
> > > cache page can be more expensive than dropping an unused text page
> > > that was loaded as part of some executable's initialization and
> > > forgotten.
> > 
> > We victimize the unmapped cache only if it is unused (in LRU order).
> > We don't force the issue too much. We also have free slab cache to go
> > after.
> 
> Just to be clear, let's say we have a mapped page (say of /sbin/init)
> that's been unreferenced since _just_ after the system booted.  We also
> have an unmapped page cache page of a file often used at runtime, say
> one from /etc/resolv.conf or /etc/passwd.
> 

Hmm. I'm not fan of estimating working set size by calculation
based on some numbers without considering history or feedback.

Can't we use some kind of feedback algorithm as hi-low-watermark, random walk
or GA (or somehing more smart) to detect the size ?

Thanks,
-Kame




