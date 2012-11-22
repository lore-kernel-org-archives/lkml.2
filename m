Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756047Ab2KVTGv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 14:06:51 -0500
Received: from mga11.intel.com ([192.55.52.93]:59181 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754380Ab2KVTGt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 14:06:49 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,301,1352102400"; 
   d="scan'208";a="251109879"
Date: Thu, 22 Nov 2012 23:41:07 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Metin =?utf-8?B?RMO2xZ9sw7w=?= <metindoslu@gmail.com>
Cc: Jaegeuk Hanse <jaegeuk.hanse@gmail.com>, Jan Kara <jack@suse.cz>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>
Subject: Re: Problem in Page Cache Replacement
Message-ID: <20121122154107.GB11736@localhost>
References: <1353433362.85184.YahooMailNeo@web141101.mail.bf1.yahoo.com>
 <20121120182500.GH1408@quack.suse.cz>
 <1353485020.53500.YahooMailNeo@web141104.mail.bf1.yahoo.com>
 <1353485630.17455.YahooMailNeo@web141106.mail.bf1.yahoo.com>
 <50AC9220.70202@gmail.com>
 <20121121090204.GA9064@localhost>
 <50ACA209.9000101@gmail.com>
 <1353491880.11679.YahooMailNeo@web141102.mail.bf1.yahoo.com>
 <50ACA634.5000007@gmail.com>
 <CAJOrxZBpefqtkXr+XTxEZ6qy-6SCwQJ11makD=Lg_M4itY5Ang@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJOrxZBpefqtkXr+XTxEZ6qy-6SCwQJ11makD=Lg_M4itY5Ang@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 21, 2012 at 12:07:22PM +0200, Metin Döşlü wrote:
> On Wed, Nov 21, 2012 at 12:00 PM, Jaegeuk Hanse <jaegeuk.hanse@gmail.com> wrote:
> >
> > On 11/21/2012 05:58 PM, metin d wrote:
> >
> > Hi Fengguang,
> >
> > I run tests and attached the results. The line below I guess shows the data-1 page caches.
> >
> > 0x000000080000006c       6584051    25718  __RU_lA___________________P________    referenced,uptodate,lru,active,private
> >
> >
> > I thinks this is just one state of page cache pages.
> 
> But why these page caches are in this state as opposed to other page
> caches. From the results I conclude that:
> 
> data-1 pages are in state : referenced,uptodate,lru,active,private

I wonder if it's this code that stops data-1 pages from being
reclaimed:

shrink_page_list():

                if (page_has_private(page)) {
                        if (!try_to_release_page(page, sc->gfp_mask))
                                goto activate_locked;

What's the filesystem used?

> data-2 pages are in state : referenced,uptodate,lru,mappedtodisk

Thanks,
Fengguang
