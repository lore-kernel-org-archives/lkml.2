Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751323Ab0HSAwv (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 20:52:51 -0400
Received: from ozlabs.org ([203.10.76.45]:53991 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751249Ab0HSAws (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 20:52:48 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] Documentation: kernel-locking: mutex_trylock cannot be used in interrupt context
Date: Thu, 19 Aug 2010 10:22:42 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-24-generic; KDE/4.4.2; i686; ; )
Cc: linux-kernel@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org
References: <tkrat.12a11fb05527c6ed@s5r6.in-berlin.de>
In-Reply-To: <tkrat.12a11fb05527c6ed@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201008191022.43524.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 19 Aug 2010 07:38:15 am Stefan Richter wrote:
> Chapter 6 is right about mutex_trylock, but chapter 10 wasn't.
> This error was introduced during semaphore-to-mutex conversion of the
> Unreliable guide. :-)
> 
> If user context which performs mutex_lock() or mutex_trylock() is
> preempted by interrupt context which performs mutex_trylock() on the
> same mutex instance, a deadlock occurs.  This is because these functions
> do not disable local IRQs when they operate on mutex->wait_lock.

Acked-by: Rusty Russell <rusty@rustcorp.com.au>

I'm assuming Andrew Morton or Randy Dunlap will pick this up...

Thanks!
Rusty.
