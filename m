Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756701Ab0IGMgY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 08:36:24 -0400
Received: from hera.kernel.org ([140.211.167.34]:52046 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756256Ab0IGMgT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 08:36:19 -0400
Message-ID: <4C8631BE.9030709@kernel.org>
Date: Tue, 07 Sep 2010 14:36:14 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.8) Gecko/20100802 Thunderbird/3.1.2
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>
CC: Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET] backing-dev: replace private thread pool with  workqueue
References: <1283777182-11426-1-git-send-email-tj@kernel.org> <20100907121608.GA26597@lst.de> <4C862DDC.6010702@kernel.org> <4C86303A.90601@fusionio.com>
In-Reply-To: <4C86303A.90601@fusionio.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Tue, 07 Sep 2010 12:36:16 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 09/07/2010 02:29 PM, Jens Axboe wrote:
> I agree (with both of you). It's definitely too early to convert it
> over, but if we can in the longer run, it never hurts to get rid of
> code. The writeback threads aren't a typical threadpool, in that the
> threads stick around and only go away when idle for too long. If they
> stick around, you get the same process hammering IO at your device. So
> converting that over to the generic cwq may or may not be at a
> performance cost, it'll definitely have to be tested.

One thing to try is removing WQ_UNBOUND and see how it affects the
performance.  I put WQ_UNBOUND there mainly to keep the behavior about
the same as the current code but given what it does I think it would
probably fare better with workers bound to CPUs.

Thanks.

-- 
tejun
