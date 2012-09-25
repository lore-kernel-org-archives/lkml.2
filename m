Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757953Ab2IYTWs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 15:22:48 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:48643 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754488Ab2IYTWr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 15:22:47 -0400
MIME-Version: 1.0
Message-ID: <d2355756-7b4d-4b23-89ce-602c3451ac68@default>
Date: Tue, 25 Sep 2012 12:22:14 -0700 (PDT)
From: Dan Magenheimer <dan.magenheimer@oracle.com>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: Mel Gorman <mgorman@suse.de>, Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: RE: [RFC] mm: add support for zsmalloc and zcache
References: <1346794486-12107-1-git-send-email-sjenning@linux.vnet.ibm.com>
 <20120921161252.GV11266@suse.de>
 <15c1d12a-0e29-478f-97e0-ee4063e2cba5@default> <505DBDC5.3010503@gmail.com>
 <505DBF72.3000208@gmail.com>
In-Reply-To: <505DBF72.3000208@gmail.com>
X-Priority: 3
X-Mailer: Oracle Beehive Extensions for Outlook 2.0.1.7  (607090) [OL
 12.0.6661.5003 (x86)]
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> From: Sasha Levin [mailto:levinsasha928@gmail.com]
> Subject: Re: [RFC] mm: add support for zsmalloc and zcache

Sorry for delayed response!
 
> On 09/22/2012 03:31 PM, Sasha Levin wrote:
> > On 09/21/2012 09:14 PM, Dan Magenheimer wrote:
> >>>> +#define MAX_CLIENTS 16
> >>>>
> >>>> Seems a bit arbitrary. Why 16?
> >> Sasha Levin posted a patch to fix this but it was tied in to
> >> the proposed KVM implementation, so was never merged.
> >>
> >
> > My patch changed the max pools per client, not the maximum amount of clients.
> > That patch has already found it's way in.
> >
> > (MAX_CLIENTS does look like an arbitrary number though).
> 
> btw, while we're on the subject of KVM, the implementation of tmem/kvm was
> blocked due to insufficient performance caused by the lack of multi-page
> ops/batching.

Hmmm... I recall that was an unproven assertion.  The tmem/kvm
implementation was not exposed to any wide range of workloads
IIRC?  Also, the WasActive patch is intended to reduce the problem
that multi-guest high volume reads would provoke, so any testing
without that patch may be moot.
 
> Are there any plans to make it better in the future?

If it indeed proves to be a problem, the ramster-merged zcache
(aka zcache2) should be capable of managing a "split" zcache
implementation, i.e. zcache executing in the guest and "overflowing"
page cache pages to the zcache in the host, which should at least
ameliorate most of Avi's concern.  I personally have no plans
to implement that, but would be willing to assist if others
attempt to implement it.

The other main concern expressed by the KVM community, by
Andrea, was zcache's lack of ability to "overflow" frontswap
pages in the host to a real swap device.  The foundation
for that was one of the objectives of the zcache2 redesign;
I am working on a "yet-to-be-posted" patch built on top of zcache2
that will require some insight and review from MM experts.

Dan
