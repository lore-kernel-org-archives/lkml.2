Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab1CUOIY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Mar 2011 10:08:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8308 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752193Ab1CUOIW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Mar 2011 10:08:22 -0400
Date: Mon, 21 Mar 2011 10:07:37 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: Lina Lu <lulina_nuaa@foxmail.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>
Subject: Re: cfq-iosched.c: panic in cfq_dispatch_requests
Message-ID: <20110321140737.GA2694@redhat.com>
References: <201103201523220468314@foxmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201103201523220468314@foxmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Mar 20, 2011 at 03:23:23PM +0800, Lina Lu wrote:
> Hi Vivek,
> 
> I did some test with blkio weight policy these days. The kernel panic 
> once in a while. 
> 	
> >From the calltrace, It 's in func cfq_dispatch_requests(+0x058D).
> And I caught a divide by zero error with system monitor tools.

Hi Lina,

Can you please paste the full backtrace here.

> 	
> The panic happens when I first set 100 weight to two IO pids, then 
> change the weight to 200, and begin to perform IO. The kernel panic
> accurately when the IO begin.

So you notice this only if weights are changed otherwise not?

Recently Justin fixed a bug in CFQ where crash can happen when weights
are changed. This fix in Jens's block tree. Can you please apply this
patch and see if it resolves your issue too.

commit 8184f93eced1e304721c2a55c00d87d5a14f8907
Author: Justin TerAvest <teravest@google.com>
Date:   Thu Mar 17 16:12:36 2011 +0100

    cfq-iosched: Don't update group weights when on service tree

Thanks
Vivek
