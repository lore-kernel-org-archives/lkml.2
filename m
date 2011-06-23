Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933421Ab1FWSNb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jun 2011 14:13:31 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:34188
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933337Ab1FWSN0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jun 2011 14:13:26 -0400
Date: Thu, 23 Jun 2011 14:13:17 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@ZenIV.linux.org.uk>
Cc: Andi Kleen <andi@firstfloor.org>,
        Maarten Lankhorst <m.b.lankhorst@gmail.com>,
        Alex Elder <aelder@sgi.com>, xfs-masters@oss.sgi.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: [PATCH v2] xfs: Silence bounds checking compiler warning
Message-ID: <20110623181317.GA26945@infradead.org>
References: <4E037001.8090306__42924.0493024283$1308849791$gmane$org@gmail.com>
 <m2boxocvb5.fsf@firstfloor.org>
 <20110623175533.GK11521@ZenIV.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110623175533.GK11521@ZenIV.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 23, 2011 at 06:55:33PM +0100, Al Viro wrote:
> ... and even better is to write in real C and have u8 name[]; in the
> end of your structure.  That's the standard C99 for this kind of thing
> (see 6.7.2.1p2, p16).  Zero-sized array is a gccism predating standard
> flexible array members and since the standard syntax is accepted by
> any gcc version that might be recent enough to build the kernel...

The situation is even more nasty - the one sized fake flex-array
actually is in the middle of the structure.  Besides sizeof-expressions
taking the one member array into account only members before the
variable sized array are used.  I've started a series cleaning up the
few structures that were done that way (for whatever reason), but it's
pretty intrusive.  I don't think papering over these warnings at this
point is a good idea.

