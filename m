Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757372Ab0JHNYy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Oct 2010 09:24:54 -0400
Received: from phunq.net ([64.81.85.152]:43923 "EHLO moonbase.phunq.net"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752417Ab0JHNYx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Oct 2010 09:24:53 -0400
From: Daniel Phillips <phillips@phunq.net>
To: Christoph Hellwig <hch@lst.de>
Subject: Re: introduce dm-snap-mv
Date: Fri, 8 Oct 2010 06:22:57 -0700
User-Agent: KMail/1.9.9
Cc: McPacino <mcpacino@gmail.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org, dm-devel@redhat.com,
        Andrew Morton <akpm@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Nick Piggin <npiggin@kernel.dk>
References: <20101006083150.GA15758@zhongling> <AANLkTim9KFuP1_mrUUsMOEspxkfA=SZW2dmTX4WJbfep@mail.gmail.com> <20101008092427.GA5426@lst.de>
In-Reply-To: <20101008092427.GA5426@lst.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201010080622.58095.phillips@phunq.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 October 2010, Christoph Hellwig wrote:
> On Fri, Oct 08, 2010 at 05:14:27PM +0800, McPacino wrote:
> > Hi Christoph,
> > 
> > I have to take care the cache problem If using the bio directly.
> > BHs can be released by kernel when necessary.
> > 
> > Is there any existing code using bio to read/write metadata
> > blocks? How do they handle the timing freeing bios? I really
> > wish to learn something form it.
> 
> If you actually need caching just use the pagecache, e.g.
> read_mapping_page to read in your data.  That completely abstracts
> away the underlying block size.

And that will automatically give him the PAGE_CACHE_SIZE objects he
wants.  I still don't understand why his model cannot be generalized
to arbitrary block size specifiable at create time.

Regards,

Daniel
