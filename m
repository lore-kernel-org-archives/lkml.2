Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753497Ab1CBOrM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Mar 2011 09:47:12 -0500
Received: from mail.elliptictech.com ([209.217.122.41]:45073 "EHLO
	mail.ellipticsemi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750802Ab1CBOrL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Mar 2011 09:47:11 -0500
Date: Wed, 2 Mar 2011 09:47:05 -0500
From: Nick Bowler <nbowler@elliptictech.com>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-kernel@vger.kernel.org, Evgeniy Dushistov <dushistov@mail.ru>,
        Nick Piggin <npiggin@gmail.com>
Subject: Re: [PATCH 4/7] ufs: remove the BKL
Message-ID: <20110302144705.GA15482@elliptictech.com>
References: <1299021191-17961-1-git-send-email-arnd@arndb.de>
 <1299021191-17961-5-git-send-email-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1299021191-17961-5-git-send-email-arnd@arndb.de>
Organization: Elliptic Technologies Inc.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-03-02 00:13 +0100, Arnd Bergmann wrote:
> This introduces a new per-superblock mutex in UFS to replace
> the big kernel lock. I have been careful to avoid nested
> calls to lock_ufs and to get the lock order right with
> respect to other mutexes, in particular lock_super.
> 
> I did not make any attempt to prove that the big kernel
> lock is not needed in a particular place in the code,
> which is very possible.
> 
> The code is still only compile-tested,

This isn't true anymore; I've been running with this patch (well, the
previous versions thereof) for some time now.  On the other hand, I
don't use all of this driver's features.

> but it should at least be harmless on non-SMP systems, since the new
> mutex is not taken on those.

I think this part of the patch is strange.  It seems like a gratuitous
difference between SMP/preempt and other systems to #if out the code
that takes the mutex.  This might make problems with the conversion fly
under the radar longer because people with older systems won't encounter
them.

-- 
Nick Bowler, Elliptic Technologies (http://www.elliptictech.com/)
