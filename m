Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755204Ab2FERXI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jun 2012 13:23:08 -0400
Received: from mx1.redhat.com ([209.132.183.28]:52649 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753651Ab2FERXG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jun 2012 13:23:06 -0400
Date: Tue, 5 Jun 2012 13:23:02 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Myklebust, Trond" <Trond.Myklebust@netapp.com>,
        linux-fsdevel@vger.kernel.org,
        Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: write-behind on streaming writes
Message-ID: <20120605172302.GB28556@redhat.com>
References: <20120528114124.GA6813@localhost>
 <CA+55aFxHt8q8+jQDuoaK=hObX+73iSBTa4bBWodCX3s-y4Q1GQ@mail.gmail.com>
 <20120529155759.GA11326@localhost>
 <CA+55aFykFaBhzzEyRYWRS9Qoy_q_R65Cuth7=XvfOZEMqjn6=w@mail.gmail.com>
 <20120530032129.GA7479@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120530032129.GA7479@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 11:21:29AM +0800, Fengguang Wu wrote:

[..]
> (2) comes from the use of _WAIT_ flags in
> 
>         sync_file_range(..., SYNC_FILE_RANGE_WAIT_BEFORE|SYNC_FILE_RANGE_WRITE|SYNC_FILE_RANGE_WAIT_AFTER);
> 
> Each sync_file_range() syscall will submit 8MB write IO and wait for
> completion. That means the async write IO queue constantly swing
> between 0 and 8MB fillness at the frequency (100MBps / 8MB = 12.5ms).
> So on every 12.5ms, the async IO queue runs empty, which gives any
> pending read IO (from firefox etc.) a chance to be serviced. Nice
> and sweet breaks!

I doubt that async IO queue is empty for 12.5ms. We wait for previous
range to finish (index-1) and have already started the IO on next 8MB
of pages. So effectively that should keep 8MB of async IO in
queue (until and unless there are delays from user space side). So reason
for latency improvement might be something else and not because async
IO queue is empty for some time.

Thanks
Vivek
