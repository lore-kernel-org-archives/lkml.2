Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756164Ab1GAJhI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Jul 2011 05:37:08 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:45077
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755648Ab1GAJhF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Jul 2011 05:37:05 -0400
Date: Fri, 1 Jul 2011 05:37:02 -0400
From: Christoph Hellwig <hch@infradead.org>
To: P?draig Brady <P@draigBrady.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        Josef Bacik <josef@redhat.com>, xfs@oss.sgi.com,
        viro@ZenIV.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] xfstests 255: add a seek_data/seek_hole tester
Message-ID: <20110701093702.GA28684@infradead.org>
References: <1309275199-10801-1-git-send-email-josef@redhat.com>
 <1309275199-10801-5-git-send-email-josef@redhat.com>
 <20110629065306.GC1026@dastard>
 <20110629074021.GA26086@infradead.org>
 <4E0B019E.8080800@draigBrady.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E0B019E.8080800@draigBrady.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 29, 2011 at 11:42:38AM +0100, P?draig Brady wrote:
> There is the argument, that if this interface can distinguish
> these dirty unwritten extents, then why can't the fiemap interface too?
> The advantage of the fiemap interface is that it can distinguish
> empty extents vs holes. Empty extents will become increasingly common
> I think, given the fragmentation and space guarantee benefits they give.
> It would be cool for cp for example to be able to efficiently copy
> empty extents from source to dest.

That brings us back to square one.  FIEMAP is supposed to tell you about
the physical layout on disk.  Unwritten extents physically always are
there, but whether they might have to be copied depends entirely on
in-core state.  Finding that incore state in addition is not all that
easy compared to simply walking the extents.  People might decide it's
worth for an interface like SEEK_HOLE specificly asking for that, but
grafting it into FIEMAP through the backdoor is a horrible idea.

