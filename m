Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755398Ab1IPSIM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 14:08:12 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:52579 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753796Ab1IPSIL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 14:08:11 -0400
X-Sasl-enc: XCAsfsc9VQ7GDWum1UHImKmvpgL+CfXoW95fsvE4cPPq 1316196490
Date: Fri, 16 Sep 2011 19:55:52 +0200
From: Greg KH <greg@kroah.com>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-mm@kvack.org,
        ngupta@vflare.org, linux-kernel@vger.kernel.org,
        francis.moro@gmail.com, Seth Jennings <sjenning@linux.vnet.ibm.com>
Subject: Re: [PATCH] staging: zcache: fix cleancache crash
Message-ID: <20110916175552.GA25405@kroah.com>
References: <a7d17e7e-c6a1-448e-b60f-b79a4ae0c3ba@default>
 <8cb0f464-7e39-4294-9f98-c4c5a66110ba@default>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8cb0f464-7e39-4294-9f98-c4c5a66110ba@default>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 07:16:10AM -0700, Dan Magenheimer wrote:
> > From: Dan Magenheimer
> > Sent: Tuesday, September 13, 2011 2:56 PM
> > To: Seth Jennings; gregkh@suse.de
> > Cc: devel@driverdev.osuosl.org; linux-mm@kvack.org; ngupta@vflare.org; linux-kernel@vger.kernel.org;
> > francis.moro@gmail.com
> > Subject: RE: [PATCH] staging: zcache: fix cleancache crash
> > 
> > > From: Seth Jennings [mailto:sjenning@linux.vnet.ibm.com]
> > > Sent: Tuesday, September 13, 2011 1:19 PM
> > > To: gregkh@suse.de
> > > Cc: devel@driverdev.osuosl.org; linux-mm@kvack.org; ngupta@vflare.org; linux-kernel@vger.kernel.org;
> > > francis.moro@gmail.com; Dan Magenheimer; Seth Jennings
> > > Subject: [PATCH] staging: zcache: fix cleancache crash
> > >
> > > After commit, c5f5c4db, cleancache crashes on the first
> > > successful get. This was caused by a remaining virt_to_page()
> > > call in zcache_pampd_get_data_and_free() that only gets
> > > run in the cleancache path.
> > >
> > > The patch converts the virt_to_page() to struct page
> > > casting like was done for other instances in c5f5c4db.
> > >
> > > Based on 3.1-rc4
> > >
> > > Signed-off-by: Seth Jennings <sjenning@linux.vnet.ibm.com>
> > 
> > Yep, this appears to fix it!  Hopefully Francis can confirm.
> > 
> > Greg, ideally apply this additional fix rather than do the revert
> > of the original patch suggested in https://lkml.org/lkml/2011/9/13/234
> > 
> > Acked-by: Dan Magenheimer <dan.magenheimer@oracle.com>
> 
> 
> Greg, Francis has confirmed offlist that Seth's fix below
> has fixed his issue as well.  Please apply, hopefully as
> soon as possible and before 3.1 goes final!

Due to the loss of kernel.org, it might miss it, but don't worry, that's
what stable kernel releases are for :)

thanks,

greg k-h
