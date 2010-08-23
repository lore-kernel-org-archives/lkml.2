Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680Ab0HWRDu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 13:03:50 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:35681 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab0HWRDs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Aug 2010 13:03:48 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mIm7lfDf6Ny6He0CKZgUea/Pzyxt7lPThAkYHFYV2/iYwOVZ3LXnP6yyk2Xl1cSh6T
         2WVvJjTsxKRFODGIZ4xhkJSBXFlFq/Rq5VL5/ER0cV1Lia5TfNNWptKag0SaNEMTSk6E
         7GUAiijZ79gW4sps3Dh8+bA0NToPfddZ3dV38=
Date: Tue, 24 Aug 2010 02:03:40 +0900
From: Minchan Kim <minchan.kim@gmail.com>
To: Christoph Lameter <cl@linux.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel List <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Hugh Dickins <hughd@google.com>, Andi Kleen <andi@firstfloor.org>,
        Mel Gorman <mel@csn.ul.ie>
Subject: Re: [PATCH] compaction: fix COMPACTPAGEFAILED counting
Message-ID: <20100823170340.GA2304@barrios-desktop>
References: <1282580114-2136-1-git-send-email-minchan.kim@gmail.com>
 <alpine.DEB.2.00.1008231140320.9496@router.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.00.1008231140320.9496@router.home>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 23, 2010 at 11:41:49AM -0500, Christoph Lameter wrote:
> On Tue, 24 Aug 2010, Minchan Kim wrote
> 
> > This patch introude new argument 'cleanup' to migrate_pages.
> > Only if we set 1 to 'cleanup', migrate_page will clean up the lists.
> > Otherwise, caller need to clean up the lists so it has a chance to postprocess
> > the pages.
> 
> Could we simply make migrate_pages simply not do any cleanup?

If migrate_pages always return number of pages not migrated, it's possible.
But now it can return the number of pages not migrated or error code. 
In case of returning error code, caller has a complex routine to know count the 
number of success.

> Caller has to call putback_lru_pages()?
> 
Hmm. yes it's not good. At least we can help some NOTE.
migrate_pages isn't generic kernel API so i think documentation is enough. 

-- 
Kind regards,
Minchan Kim
