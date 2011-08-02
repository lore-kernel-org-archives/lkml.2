Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754184Ab1HBMFE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Aug 2011 08:05:04 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:58960
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754146Ab1HBMEw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Aug 2011 08:04:52 -0400
Date: Tue, 2 Aug 2011 08:04:13 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Wu Fengguang <fengguang.wu@intel.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: xfstests 073 regression
Message-ID: <20110802120413.GA18908@infradead.org>
References: <20110730134422.GA1884@infradead.org>
 <20110731151014.GA23106@localhost>
 <20110731234749.GQ5404@dastard>
 <CA+55aFzkb58Gtzgpd3oQgXekpg4APN6jDLNCh=CAMQ0zwyE4kg@mail.gmail.com>
 <20110801012813.GR5404@dastard>
 <CA+55aFwtfUeUn=MuqSEyPiPeC5=k2xK2ULd9-5ShQAJ=4T0CvQ@mail.gmail.com>
 <20110801020951.GA12870@dastard>
 <20110801112330.GA27190@infradead.org>
 <20110801165242.GA18802@infradead.org>
 <20110802114428.GA6014@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110802114428.GA6014@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 02, 2011 at 07:44:28PM +0800, Wu Fengguang wrote:
> What's that bdi 7:0?

/dev/loop0

> And sb_dev=0:0

that we didn't have sb specified in thhis wb_work

> , nr_pages=9223372036854775807=0x7fffffffffffffff.

LONG_MAX.

It all fits perfectly:

static long wb_check_background_flush(struct bdi_writeback *wb)
{
        if (over_bground_thresh()) {
		struct wb_writeback_work work = {
			.nr_pages       = LONG_MAX,
			.sync_mode	= WB_SYNC_NONE,
			.for_background = 1,
			.range_cyclic = 1,
		};

		return wb_writeback(wb, &work);
	}

	return 0;
}
