Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759569Ab1CDNZz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 08:25:55 -0500
Received: from bombadil.infradead.org ([18.85.46.34]:41795 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759532Ab1CDNZy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 08:25:54 -0500
Date: Fri, 4 Mar 2011 08:25:51 -0500
From: "hch@infradead.org" <hch@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>
Subject: Re: [PATCH 07/10] fs: make generic file read/write functions plug
Message-ID: <20110304132551.GA2407@infradead.org>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
 <1295659049-2688-8-git-send-email-jaxboe@fusionio.com>
 <20110304040907.GB32404@redhat.com>
 <4D70E78D.9000402@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D70E78D.9000402@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 04, 2011 at 02:22:21PM +0100, Jens Axboe wrote:
> Good catch, we need to modify that logic. If the task is currently
> plugged, it should not dispatch until blk_finish_plug() is called.
> Essentially SYNC will not control dispatch. Will allow us to clean up
> that logic, too.

<broken-record-mode>

Time to use the opportunity to sort out what the various bio/request
flags mean.

REQ_UNPLUG should simply go away with the explicit stack plugging.
What's left for REQ_SYNC?  It'll control if the request goes into the
sync bucket and some cfq tweaks.  We should clearly document what it
does.

REQ_META?  Maybe we should finally agree what it does and decide if it
should be used consistenly.  Especially the priority over REQ_SYNC in
cfq still looks somewhat odd, as does the totally inconsequent use.

</broken-record-mode>
