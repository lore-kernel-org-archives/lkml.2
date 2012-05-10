Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756320Ab2EJOIt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 10:08:49 -0400
Received: from rcsinet15.oracle.com ([148.87.113.117]:18775 "EHLO
	rcsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759597Ab2EJOIq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 10:08:46 -0400
Date: Thu, 10 May 2012 10:02:15 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Minchan Kim <minchan@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 3/4] zsmalloc use zs_handle instead of void *
Message-ID: <20120510140215.GC26152@phenom.dumpdata.com>
References: <1336027242-372-1-git-send-email-minchan@kernel.org>
 <1336027242-372-3-git-send-email-minchan@kernel.org>
 <4FA28907.9020300@vflare.org>
 <4FA2A2F0.3030509@linux.vnet.ibm.com>
 <4FA33DF6.8060107@kernel.org>
 <20120509201918.GA7288@kroah.com>
 <4FAB21E7.7020703@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FAB21E7.7020703@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 10, 2012 at 11:03:19AM +0900, Minchan Kim wrote:
> On 05/10/2012 05:19 AM, Greg Kroah-Hartman wrote:
> 
> > On Fri, May 04, 2012 at 11:24:54AM +0900, Minchan Kim wrote:
> >> On 05/04/2012 12:23 AM, Seth Jennings wrote:
> >>
> >>> On 05/03/2012 08:32 AM, Nitin Gupta wrote:
> >>>
> >>>> On 5/3/12 2:40 AM, Minchan Kim wrote:
> >>>>> We should use zs_handle instead of void * to avoid any
> >>>>> confusion. Without this, users may just treat zs_malloc return value as
> >>>>> a pointer and try to deference it.
> >>>>>
> >>>>> Cc: Dan Magenheimer<dan.magenheimer@oracle.com>
> >>>>> Cc: Konrad Rzeszutek Wilk<konrad.wilk@oracle.com>
> >>>>> Signed-off-by: Minchan Kim<minchan@kernel.org>
> >>>>> ---
> >>>>>   drivers/staging/zcache/zcache-main.c     |    8 ++++----
> >>>>>   drivers/staging/zram/zram_drv.c          |    8 ++++----
> >>>>>   drivers/staging/zram/zram_drv.h          |    2 +-
> >>>>>   drivers/staging/zsmalloc/zsmalloc-main.c |   28
> >>>>> ++++++++++++++--------------
> >>>>>   drivers/staging/zsmalloc/zsmalloc.h      |   15 +++++++++++----
> >>>>>   5 files changed, 34 insertions(+), 27 deletions(-)
> >>>>
> >>>> This was a long pending change. Thanks!
> >>>
> >>>
> >>> The reason I hadn't done it before is that it introduces a checkpatch
> >>> warning:
> >>>
> >>> WARNING: do not add new typedefs
> >>> #303: FILE: drivers/staging/zsmalloc/zsmalloc.h:19:
> >>> +typedef void * zs_handle;
> >>>
> >>
> >>
> >> Yes. I did it but I think we are (a) of chapter 5: Typedefs in Documentation/CodingStyle.
> >>
> >>  (a) totally opaque objects (where the typedef is actively used to _hide_
> >>      what the object is).
> >>
> >> No?
> > 
> > No.
> > 
> > Don't add new typedefs to the kernel.  Just use a structure if you need
> > to.
> 
> 
> I tried it but failed because there were already tightly coupling between [zcache|zram]
> and zsmalloc. 
> They already knows handle's internal well so they used it as pointer, even zcache keeps
> handle's value as some key in tmem_put and tmem_get
> AFAIK, ramster also will use zsmalloc sooner or later and add more coupling codes. Sigh.
> Please fix it as soon as possible.
> 
> Dan, Seth
> Any ideas?

struct zs {
	void *ptr;
};

And pass that structure around?
