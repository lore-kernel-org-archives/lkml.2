Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932517Ab1C3NrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 09:47:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:49517 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755941Ab1C3NrL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 09:47:11 -0400
Date: Wed, 30 Mar 2011 09:46:58 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>, Jeff Moyer <jmoyer@redhat.com>,
        Mike Snitzer <snitzer@redhat.com>,
        Markus Trippelsdorf <markus@trippelsdorf.de>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        linux-kernel@vger.kernel.org, Chris Mason <chris.mason@oracle.com>
Subject: Re: [PATCH] block: eliminate ELEVATOR_INSERT_REQUEUE
Message-ID: <20110330134658.GB1291@redhat.com>
References: <4D8CF202.9010809@kernel.dk>
 <20110326042156.GB28458@redhat.com>
 <20110328082321.GC16530@htj.dyndns.org>
 <20110328221547.GA1118@redhat.com>
 <x49y63yvwum.fsf@segfault.boston.devel.redhat.com>
 <20110329175458.GE24485@redhat.com>
 <20110330074123.GA17523@htj.dyndns.org>
 <20110330075752.GC17523@htj.dyndns.org>
 <4D92E2CD.6000909@kernel.dk>
 <20110330080203.GD17523@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110330080203.GD17523@htj.dyndns.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 30, 2011 at 10:02:03AM +0200, Tejun Heo wrote:
> Hello, Jens.
> 
> On Wed, Mar 30, 2011 at 09:59:09AM +0200, Jens Axboe wrote:
> > Pure front insert should be used for requeue and internal commands (like
> > spin up this drive, or get error information). Flush should append to
> > the dispatch list.
> 
> Yeah, right.  The reason I used REQUEUE/FRONT was because BACK
> insertion involves draining the elevator and then appending the
> request at the end of the dispatch queue, which is unnecessary and
> inefficient.  So, front insertion was a quick work around that.  If
> we're removing elv_insert(), we can just append directly to the
> dispatch queue from flush code.

Hi Tejun,

With ordering semantics gone, do we still need to drain the elevator before
queuing flush at the end of request queue.

Thanks
Vivek
