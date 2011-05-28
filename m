Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752644Ab1E1Hoz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 May 2011 03:44:55 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:32837
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752170Ab1E1How (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 May 2011 03:44:52 -0400
Date: Sat, 28 May 2011 03:44:49 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Namhyung Kim <namhyung@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <jaxboe@fusionio.com>,
        Mike Snitzer <snitzer@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 1/2] blktrace: treat flush as barrier
Message-ID: <20110528074449.GB22382@infradead.org>
References: <1306501883-23498-1-git-send-email-namhyung@gmail.com>
 <20110527131237.GA27647@infradead.org>
 <BANLkTi=8jQPdBNJYfM=geuXFsAXJJgfq=Q@mail.gmail.com>
 <1306509182.1351.1.camel@leonhard>
 <4DE006C5.4010906@fusionio.com>
 <20110527202747.GA4803@infradead.org>
 <1306548581.1679.12.camel@leonhard>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306548581.1679.12.camel@leonhard>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 28, 2011 at 11:09:41AM +0900, Namhyung Kim wrote:
> AFAIK FLUSH always precedes WRITE and then followed by FUA, so how about

Right now most do because that's how the old barriers worked, but it's
going to change.  For $NEXT + 1 I have a patch that for will make
xfs sends FUA without flushes in a lot of cases, and afaik some device
mapper code already does now.

