Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab2EVSiA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 14:38:00 -0400
Received: from acsinet15.oracle.com ([141.146.126.227]:44490 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752617Ab2EVSh7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 14:37:59 -0400
Date: Tue, 22 May 2012 14:31:19 -0400
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
To: Seth Jennings <sjenning@linux.vnet.ibm.com>
Cc: Minchan Kim <minchan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH] zsmalloc: use unsigned long instead of void *
Message-ID: <20120522183119.GA24107@phenom.dumpdata.com>
References: <1337567013-4741-1-git-send-email-minchan@kernel.org>
 <4FBA4EE2.8050308@linux.vnet.ibm.com>
 <4FBB97B2.6050408@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBB97B2.6050408@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 08:42:10AM -0500, Seth Jennings wrote:
> On 05/21/2012 09:19 AM, Seth Jennings wrote:
> 
> > On 05/20/2012 09:23 PM, Minchan Kim wrote:
> > 
> >> We should use unsigned long as handle instead of void * to avoid any
> >> confusion. Without this, users may just treat zs_malloc return value as
> >> a pointer and try to deference it.
> > 
> > 
> > I wouldn't have agreed with you about the need for this change as people
> > should understand a void * to be the address of some data with unknown
> > structure.
> > 
> > However, I recently discussed with Dan regarding his RAMster project
> > where he assumed that the void * would be an address, and as such,
> > 4-byte aligned.  So he has masked two bits into the two LSBs of the
> > handle for RAMster, which doesn't work with zsmalloc since the handle is
> > not an address.
> > 
> > So really we do need to convey as explicitly as possible to the user
> > that the handle is an _opaque_ value about which no assumption can be made.
> 
> 
> Wasn't really clear here.  All that to say, I think we do need this patch.

That sounds like an Acked-by ?

> 
> Thanks,
> Seth
