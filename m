Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754434Ab1E0U2G (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 16:28:06 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:54181
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751277Ab1E0U2D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 16:28:03 -0400
Date: Fri, 27 May 2011 16:27:47 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Namhyung Kim <namhyung@gmail.com>, Mike Snitzer <snitzer@redhat.com>,
        Christoph Hellwig <hch@infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] blktrace: treat flush as barrier
Message-ID: <20110527202747.GA4803@infradead.org>
References: <1306501883-23498-1-git-send-email-namhyung@gmail.com>
 <20110527131237.GA27647@infradead.org>
 <BANLkTi=8jQPdBNJYfM=geuXFsAXJJgfq=Q@mail.gmail.com>
 <1306509182.1351.1.camel@leonhard>
 <4DE006C5.4010906@fusionio.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DE006C5.4010906@fusionio.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 10:17:09PM +0200, Jens Axboe wrote:
> Agree on Christophs comments, we should not pretend they are the same
> (since they are not). Since flush is a request on its own, F works
> nicely. For FUA it's associated with a write, so F should work there too
> indicating Write Fua (and easily humanly parsed as that, or Write
> Flush). WU would look confusing.

REQ_FLUSH can also be set on a write bio, it only gets split at the
request level.  And even there we're at least pondering allowing it
to stay as part of the write for some paravirtualized storage protocols.

