Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755180Ab1IPOIP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Sep 2011 10:08:15 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:43696
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754019Ab1IPOIN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Sep 2011 10:08:13 -0400
Date: Fri, 16 Sep 2011 10:08:09 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Tao Ma <tm@tao.ma>
Cc: Shaohua Li <shaohua.li@intel.com>, lkml <linux-kernel@vger.kernel.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Maxim Patlasov <maxim.patlasov@gmail.com>,
        Vivek Goyal <vgoyal@redhat.com>, Corrado Zoccolo <czoccolo@gmail.com>
Subject: Re: [patch]cfq-iosched: delete deep seeky queue idle logic
Message-ID: <20110916140809.GA7026@infradead.org>
References: <1316142577.29510.130.camel@sli10-conroe>
 <4E731CEB.2010909@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E731CEB.2010909@tao.ma>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 05:54:51PM +0800, Tao Ma wrote:
> This year's FAST has a paper named "A Scheduling Framework That Makes
> Any Disk Schedulers Non-Work-Conserving Solely Based on Request
> Characteristics". It has described this situation and suggests a new
> scheduler named "stream scheduler" to resolve this. But I am not sure
> whether CFQ can work like that or not.

As usual I suspect the best thing is to just use noop for these kinds of
cases.  E.g. when you use xfs with the filestreams options you'll get
patterns pretty similar to that in the initial post  - that is
intentional as it is generally use to place them into different areas
of a complex RAID array.  Any scheduler "smarts" will just help to break these
I/O streams.

