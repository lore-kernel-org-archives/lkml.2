Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752350Ab0FWKDL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 06:03:11 -0400
Received: from verein.lst.de ([213.95.11.210]:60060 "EHLO verein.lst.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751506Ab0FWKDJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 06:03:09 -0400
Date: Wed, 23 Jun 2010 12:02:52 +0200
From: Christoph Hellwig <hch@lst.de>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
       linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: trying to understand READ_META, READ_SYNC, WRITE_SYNC & co
Message-ID: <20100623100252.GB9575@lst.de>
References: <20100621094828.GA30748@lst.de> <4C1F3916.4070608@kernel.dk> <20100621202504.GA6474@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100621202504.GA6474@redhat.com>
User-Agent: Mutt/1.3.28i
X-Spam-Score: 0 () 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 21, 2010 at 04:25:04PM -0400, Vivek Goyal wrote:
> In my testing in the past, this was helping if lots of sequential readers
> are running in a system (with 100ms slice each) and if there is another
> reader doing small file reads. Without meta data based preemption check,
> latency of opening small file used to be very high (Because all the sync
> sequntial reader gets to consume their 100ms slices first).
> 
> Situation should be somewhat better now after corrado's changes of
> reducing slice length dynamically. But I suspect that we will still
> experience significantly reduced latency for small file reads in presece
> of multiple sequntial reads going on.

Any chance we could create a benchmark suite for the I/O schedulers?
I'd really like to get these annotations correct, and having an
automated suite that shows the numbers for the interesting workloads
would help greatly with that.

