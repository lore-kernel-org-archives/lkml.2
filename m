Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761010Ab2EIUT0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:19:26 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:55126 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760996Ab2EIUTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:19:23 -0400
Date: Wed, 9 May 2012 13:19:18 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH 3/4] zsmalloc use zs_handle instead of void *
Message-ID: <20120509201918.GA7288@kroah.com>
References: <1336027242-372-1-git-send-email-minchan@kernel.org>
 <1336027242-372-3-git-send-email-minchan@kernel.org>
 <4FA28907.9020300@vflare.org>
 <4FA2A2F0.3030509@linux.vnet.ibm.com>
 <4FA33DF6.8060107@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FA33DF6.8060107@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 04, 2012 at 11:24:54AM +0900, Minchan Kim wrote:
> On 05/04/2012 12:23 AM, Seth Jennings wrote:
> 
> > On 05/03/2012 08:32 AM, Nitin Gupta wrote:
> > 
> >> On 5/3/12 2:40 AM, Minchan Kim wrote:
> >>> We should use zs_handle instead of void * to avoid any
> >>> confusion. Without this, users may just treat zs_malloc return value as
> >>> a pointer and try to deference it.
> >>>
> >>> Cc: Dan Magenheimer<dan.magenheimer@oracle.com>
> >>> Cc: Konrad Rzeszutek Wilk<konrad.wilk@oracle.com>
> >>> Signed-off-by: Minchan Kim<minchan@kernel.org>
> >>> ---
> >>>   drivers/staging/zcache/zcache-main.c     |    8 ++++----
> >>>   drivers/staging/zram/zram_drv.c          |    8 ++++----
> >>>   drivers/staging/zram/zram_drv.h          |    2 +-
> >>>   drivers/staging/zsmalloc/zsmalloc-main.c |   28
> >>> ++++++++++++++--------------
> >>>   drivers/staging/zsmalloc/zsmalloc.h      |   15 +++++++++++----
> >>>   5 files changed, 34 insertions(+), 27 deletions(-)
> >>
> >> This was a long pending change. Thanks!
> > 
> > 
> > The reason I hadn't done it before is that it introduces a checkpatch
> > warning:
> > 
> > WARNING: do not add new typedefs
> > #303: FILE: drivers/staging/zsmalloc/zsmalloc.h:19:
> > +typedef void * zs_handle;
> > 
> 
> 
> Yes. I did it but I think we are (a) of chapter 5: Typedefs in Documentation/CodingStyle.
> 
>  (a) totally opaque objects (where the typedef is actively used to _hide_
>      what the object is).
> 
> No?

No.

Don't add new typedefs to the kernel.  Just use a structure if you need
to.

Vague "handles" are almost never what you want to do in Linux, sorry, I
can't take this patch.

greg k-h
