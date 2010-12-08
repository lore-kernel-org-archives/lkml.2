Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753886Ab0LHHuq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 02:50:46 -0500
Received: from mga14.intel.com ([143.182.124.37]:12066 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753250Ab0LHHup (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 02:50:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.59,315,1288594800"; 
   d="scan'208";a="358665046"
Subject: Re: [RFC]block: change sort order of elv_dispatch_sort
From: Shaohua Li <shaohua.li@intel.com>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: lkml <linux-kernel@vger.kernel.org>,
        "vgoyal@redhat.com" <vgoyal@redhat.com>
In-Reply-To: <4CFF2C1A.1010100@fusionio.com>
References: <1291786922.12777.152.camel@sli10-conroe>
	 <4CFF2C1A.1010100@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 08 Dec 2010 15:50:43 +0800
Message-ID: <1291794643.12777.161.camel@sli10-conroe>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 14:56 +0800, Jens Axboe wrote:
> On 2010-12-08 13:42, Shaohua Li wrote:
> > Change the sort order a little bit. Makes requests with sector above boundary
> > in ascendant order, and requests with sector below boundary in descendant
> > order. The goal is we have less disk spindle move.
> > For example, boundary is 7, we add sector 8, 1, 9, 2, 3, 4, 10, 12, 5, 11, 6
> > In the original sort, the sorted list is:
> > 8, 9, 10, 11, 12, 1, 2, 3, 4, 5, 6
> > the spindle move is 8->12->1->6, total movement is 12*2 sectors
> > with the new sort, the list is:
> > 8, 9, 10, 11, 12, 6, 5, 4, 3, 2, 1
> > the spindle move is 8->12->6->1, total movement is 12*1.5 sectors
> 
> It was actually done this way on purpose, it's been a while since we
> have done two way elevators even outside the dispatch list sorting
> itself.
> 
> Do you have any results to back this change up? I'd argue that
> continuing to the end, sweeping back, and reading forwards again will be
> faster then doing backwards reads usually.
No, have no data, that is why this is a RFC patch. Part reason is I
don't know when we dispatch several requests to the list. Appears driver
only takes one request one time. What kind of test do you suggest?
I'm curious why the sweeping back is faster. It definitely needs more
spindle move. is there any hardware trick here?

Thanks,
Shaohua

