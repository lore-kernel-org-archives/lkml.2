Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933327Ab1IOLRd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 07:17:33 -0400
Received: from 173-166-109-252-newengland.hfc.comcastbusiness.net ([173.166.109.252]:60640
	"EHLO bombadil.infradead.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933261Ab1IOLRc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 07:17:32 -0400
Date: Thu, 15 Sep 2011 07:17:28 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Tao Ma <tm@tao.ma>
Cc: Shaohua Li <shli@kernel.org>, linux-kernel@vger.kernel.org,
        Jens Axboe <jaxboe@fusionio.com>
Subject: Re: [PATCH RESEND] block: Don't check QUEUE_FLAG_SAME_COMP in
 __blk_complete_request.
Message-ID: <20110915111728.GA6275@infradead.org>
References: <1315984992-5158-1-git-send-email-tm@tao.ma>
 <1315984992-5158-2-git-send-email-tm@tao.ma>
 <CANejiEWa5um5LtRkL3NcbNgBnUCG1Ud8qw-hfXW3X3GPfHv4iQ@mail.gmail.com>
 <4E715FE2.7040004@tao.ma>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E715FE2.7040004@tao.ma>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 10:16:02AM +0800, Tao Ma wrote:
> > why not delete bio_set_completion_cpu()?
> Not sure. It is added in commit c7c22e4d from the very beginning, and in
> the commit log Jens described it as:
> A bio helper (bio_set_completion_cpu()) is also added, so that queuers
> can ask for completion on that specific CPU. Maybe it is obsolete.
> Anyway, I am fine to generate a patch to remove it if you prefer.
> > 1. nobody uses it in my search
> yes, but it may be designed for someone to use it. The same goes with
> BIO_CPU_AFFINE.

This code is unused, and from the all the discussions lately pretty
obviously broken.  The only thing keeping it serves is creating more
confusion and possibly more bugs.

