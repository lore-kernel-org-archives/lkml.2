Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758344Ab1EaUN7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 31 May 2011 16:13:59 -0400
Received: from shards.monkeyblade.net ([198.137.202.13]:36116 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758316Ab1EaUN5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 31 May 2011 16:13:57 -0400
Date: Tue, 31 May 2011 13:13:52 -0700 (PDT)
Message-Id: <20110531.131352.297345785.davem@davemloft.net>
To: tj@kernel.org
Cc: linux-kernel@vger.kernel.org
Subject: Re: blkdev_get() change causes OOPS...
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110531153744.GB9048@mtj.dyndns.org>
References: <20110530.223506.424661345.davem@davemloft.net>
	<20110531153744.GB9048@mtj.dyndns.org>
X-Mailer: Mew version 6.3 on Emacs 23.2 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.6 (shards.monkeyblade.net [198.137.202.13]); Tue, 31 May 2011 13:13:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tejun Heo <tj@kernel.org>
Date: Wed, 1 Jun 2011 00:37:44 +0900

> On Mon, May 30, 2011 at 10:35:07PM -0700, David Miller wrote:
>> 
>> I don't think whole->bd_disk is guaranteed to be non-NULL where you're
>> dereferencing it in blkdev_get() after commit
>> d4dc210f69bcb0b4bef5a83b1c323817be89bad1 ("block: don't block events
>> on excl write for non-optical devices")
> 
> Ah... right, it's there if open succeeded.  I should have put the test
> after !res test.  Does the following patch fix the problem?

Works here:

Acked-by: David S. Miller <davem@davemloft.net>

Make sure this fix propagates into the stable submission.
