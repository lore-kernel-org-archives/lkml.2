Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab0IGM3y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 08:29:54 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:35494 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756256Ab0IGM3t (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 08:29:49 -0400
Message-ID: <4C86303A.90601@fusionio.com>
Date: Tue, 07 Sep 2010 14:29:46 +0200
From: Jens Axboe <jaxboe@fusionio.com>
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET] backing-dev: replace private thread pool with  workqueue
References: <1283777182-11426-1-git-send-email-tj@kernel.org> <20100907121608.GA26597@lst.de> <4C862DDC.6010702@kernel.org>
In-Reply-To: <4C862DDC.6010702@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-09-07 14:19, Tejun Heo wrote:
> Hello,
> 
> On 09/07/2010 02:16 PM, Christoph Hellwig wrote:
>> What does this conversion buy us?
>>
>> Having explicit per-bdi threads makes the model very simple and safe,
>> while I don't quite trust the now extremly complex work queues yet.
> 
> Well, the whole idea behind the new workqueue is unifying all those
> dedicated pools of threads.  If the conversion is too early given the
> new workqueue implementation, we can postpone bdi conversion by one
> more release cycle, but in the long run there is no point in keeping
> these private thread pools.

I agree (with both of you). It's definitely too early to convert it
over, but if we can in the longer run, it never hurts to get rid of
code. The writeback threads aren't a typical threadpool, in that the
threads stick around and only go away when idle for too long. If they
stick around, you get the same process hammering IO at your device. So
converting that over to the generic cwq may or may not be at a
performance cost, it'll definitely have to be tested.

-- 
Jens Axboe

