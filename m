Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753274Ab1CHJi6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Mar 2011 04:38:58 -0500
Received: from casper.infradead.org ([85.118.1.10]:55180 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753080Ab1CHJiz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Mar 2011 04:38:55 -0500
Subject: Re: [PATCH 05/10] block: remove per-queue plugging
From: Peter Zijlstra <peterz@infradead.org>
To: Jens Axboe <jaxboe@fusionio.com>
Cc: Mike Snitzer <snitzer@redhat.com>, Shaohua Li <shli@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hch@infradead.org" <hch@infradead.org>, Ingo Molnar <mingo@elte.hu>
In-Reply-To: <4D754411.5010508@fusionio.com>
References: <1295659049-2688-1-git-send-email-jaxboe@fusionio.com>
	 <1295659049-2688-6-git-send-email-jaxboe@fusionio.com>
	 <AANLkTin8FoXX6oqUyW+scwhadyX-TfW16_oKjvngU9-m@mail.gmail.com>
	 <20110303221353.GA10366@redhat.com>
	 <AANLkTi=MfDzf+-eLbysoP-ZiXX6cV_tVxYE14Vr8FSak@mail.gmail.com>
	 <20110304214359.GA18442@redhat.com> <4D715E8A.5070006@fusionio.com>
	 <20110304222702.GB18921@redhat.com>  <4D72A302.6060008@fusionio.com>
	 <1299493427.2308.11.camel@twins>  <4D753556.3020800@fusionio.com>
	 <1299530500.2308.417.camel@twins>  <4D754411.5010508@fusionio.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Tue, 08 Mar 2011 10:38:42 +0100
Message-ID: <1299577122.2308.1201.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-03-07 at 21:46 +0100, Jens Axboe wrote:
> 
> Great, that'll work for me! Your patch should work as-is, then. Thanks
> Peter.

Well I think it would be good to write it like:

  if (prev->state != TASK_RUNNING && blkneeds_flush(prev)) {
    raw_spin_unlock(&rq->lock);
    blk_flush_plug(prev);
    raw_spin_lock(&rq->lock);
  }

To avoid flipping that lock when we don't have to.
