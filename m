Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752971Ab0K0QC7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Nov 2010 11:02:59 -0500
Received: from hera.kernel.org ([140.211.167.34]:53923 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752715Ab0K0QC6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Nov 2010 11:02:58 -0500
Message-ID: <4CF12BAB.3000704@kernel.org>
Date: Sat, 27 Nov 2010 17:02:51 +0100
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.12) Gecko/20101027 Lightning/1.0b2 Thunderbird/3.1.6
MIME-Version: 1.0
To: Jens Axboe <jaxboe@fusionio.com>
CC: Christoph Hellwig <hch@lst.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCHSET] backing-dev: replace private thread pool with  workqueue
References: <1283777182-11426-1-git-send-email-tj@kernel.org> <20100907121608.GA26597@lst.de> <4C862DDC.6010702@kernel.org> <4C86303A.90601@fusionio.com> <4C8631BE.9030709@kernel.org>
In-Reply-To: <4C8631BE.9030709@kernel.org>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Sat, 27 Nov 2010 16:02:53 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2010 02:36 PM, Tejun Heo wrote:
> Hello,
> 
> On 09/07/2010 02:29 PM, Jens Axboe wrote:
>> I agree (with both of you). It's definitely too early to convert it
>> over, but if we can in the longer run, it never hurts to get rid of
>> code. The writeback threads aren't a typical threadpool, in that the
>> threads stick around and only go away when idle for too long. If they
>> stick around, you get the same process hammering IO at your device. So
>> converting that over to the generic cwq may or may not be at a
>> performance cost, it'll definitely have to be tested.
> 
> One thing to try is removing WQ_UNBOUND and see how it affects the
> performance.  I put WQ_UNBOUND there mainly to keep the behavior about
> the same as the current code but given what it does I think it would
> probably fare better with workers bound to CPUs.

cmwq now seems pretty solid.  There hasn't been any noticeable failure
yet.  I think we can move on with this conversion now.  Shall I
refresh the patchset against the current block tree?

Thanks.

-- 
tejun
