Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab2EWFzM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 May 2012 01:55:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:57841 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751205Ab2EWFzK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 May 2012 01:55:10 -0400
Date: Tue, 22 May 2012 22:55:01 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
        Dan Magenheimer <dan.magenheimer@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH] zsmalloc: use unsigned long instead of void *
Message-ID: <20120523055501.GA18748@kroah.com>
References: <1337567013-4741-1-git-send-email-minchan@kernel.org>
 <4FBA4EE2.8050308@linux.vnet.ibm.com>
 <4FBC2916.5000305@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4FBC2916.5000305@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 09:02:30AM +0900, Minchan Kim wrote:
> On 05/21/2012 11:19 PM, Seth Jennings wrote:
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
> > 
> > Also, I wanted to test this but is doesn't apply cleanly on
> > zsmalloc-main.c on v3.4 or what I have as your latest patch series.
> > What is the base for this patch?
> 
> 
> It's based on next-20120518.
> I have always used linux-next tree for staging.
> Greg, What's the convenient tree for you?

linux-next is fine.

But note, I'm ignoring all patches for the next 2 weeks, especially
staging patches, as this is the merge window time, and I can't apply
anything to my trees, sorry.

After 3.5-rc1 is out, then I will look at new stuff like this again.

thanks,

greg k-h
