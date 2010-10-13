Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753043Ab0JMHR2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Oct 2010 03:17:28 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:54664 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752783Ab0JMHR1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Oct 2010 03:17:27 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Date: Wed, 13 Oct 2010 16:12:06 +0900
From: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: "linux-mm\@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel\@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "minchan.kim\@gmail.com" <minchan.kim@gmail.com>,
        fujita.tomonori@lab.ntt.co.jp
Subject: Re: [RFC][PATCH 1/3] contigous big page allocator
Message-Id: <20101013161206.c29df8ea.kamezawa.hiroyu@jp.fujitsu.com>
In-Reply-To: <87sk0a1sq0.fsf@basil.nowhere.org>
References: <20101013121527.8ec6a769.kamezawa.hiroyu@jp.fujitsu.com>
	<87sk0a1sq0.fsf@basil.nowhere.org>
Organization: FUJITSU Co. LTD.
X-Mailer: Sylpheed 3.0.3 (GTK+ 2.10.14; i686-pc-mingw32)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 13 Oct 2010 09:01:43 +0200
Andi Kleen <andi@firstfloor.org> wrote:

> KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com> writes:
> >
> > What this wants to do: 
> >   allocates a contiguous chunk of pages larger than MAX_ORDER.
> >   for device drivers (camera? etc..)
> 
> I think to really move forward you need a concrete use case
> actually implemented in tree.
> 

yes. I heard there were users at LinuxCon Japan, so restarted.
I heared video-for-linux + ARM wants this.

I found this thread, now.
http://kerneltrap.org/mailarchive/linux-kernel/2010/10/10/4630166

Hmm. 

> >   My intention is not for allocating HUGEPAGE(> MAX_ORDER).
> 
> I still believe using this for 1GB pages would be one of the more
> interesting use cases.
> 

I'm successfully allocating 1GB of continous pages at test. But I'm not sure
requirements and users. How quick this allocation should be ?
For example, if prep_new_page() for 1GB page is slow, what kind of chunk-of-page
construction is the best. 

THanks,
-Kame

