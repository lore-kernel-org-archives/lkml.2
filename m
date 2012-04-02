Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752932Ab2DBO65 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 10:58:57 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:46995 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752427Ab2DBO6z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 10:58:55 -0400
Date: Mon, 2 Apr 2012 07:58:35 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: "Luca Porzio (lporzio)" <lporzio@micron.com>
cc: Arnd Bergmann <arnd@arndb.de>, Rik van Riel <riel@redhat.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        Alex Lemberg <alex.lemberg@sandisk.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Saugata Das <saugata.das@linaro.org>,
        Venkatraman S <venkat@linaro.org>, Yejin Moon <yejin.moon@samsung.com>,
        Hyojin Jeong <syr.jeong@samsung.com>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        "kernel-team@android.com" <kernel-team@android.com>
Subject: RE: swap on eMMC and other flash
In-Reply-To: <26E7A31274623843B0E8CF86148BFE326FB55F8B@NTXAVZMBX04.azit.micron.com>
Message-ID: <alpine.LSU.2.00.1204020754180.1847@eggly.anvils>
References: <201203301744.16762.arnd@arndb.de> <201203301850.22784.arnd@arndb.de> <alpine.LSU.2.00.1203311230490.10965@eggly.anvils> <26E7A31274623843B0E8CF86148BFE326FB55F8B@NTXAVZMBX04.azit.micron.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2 Apr 2012, Luca Porzio (lporzio) wrote:
> 
> Great topics. As per one of Rik original points:
> 
> > 4) skip writeout of zero-filled pages - this can be a big help
> >     for KVM virtual machines running Windows, since Windows zeroes
> >     out free pages;   simply discarding a zero-filled page is not
> >     at all simple in the current VM, where we would have to iterate
> >     over all the ptes to free the swap entry before being able to
> >     free the swap cache page (I am not sure how that locking would
> >     even work)
> > 
> >     with the extra layer of indirection, the locking for this scheme
> >     can be trivial - either the faulting process gets the old page,
> >     or it gets a new one, either way it'll be zero filled
> > 
> 
> Since it's KVMs realm here, can't KSM simply solve the zero-filled pages problem avoiding unnecessary burden for the Swap subsystem?

I would expect that KSM already does largely handle this, yes.
But it's also quite possible that I'm missing Rik's point.

Hugh
