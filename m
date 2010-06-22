Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752694Ab0FVXak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jun 2010 19:30:40 -0400
Received: from ozlabs.org ([203.10.76.45]:50874 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752031Ab0FVXaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jun 2010 19:30:39 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Milton Miller <miltonm@bga.com>
Subject: Re: cpumask: fix compat getaffinity
Date: Wed, 23 Jun 2010 09:00:29 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Arnd Bergmann <arnd@arndb.de>,
       KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
       Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org
References: <201005112013.56392.arnd@arndb.de> <20100511031354.GA9327@kroah.com> <1273653045_3386@mail4.comsite.net>
In-Reply-To: <1273653045_3386@mail4.comsite.net>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201006230900.29779.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 May 2010 06:00:45 pm Milton Miller wrote:
> 
> At least for parsing, we need to allocate and parse NR_CPUS until
> all places like arch/powerpc/platforms/pseries/xics.c that compare a
> user-supplied mask to CPUMASK_ALL are eliminated.

Hi, this has been bugging me...

We're OK in this case: cpumask_equal() will only iterate to nr_cpus.  That's
one reason for all the cpumask churn...

I'm about to submit the cpumask shrinkage to Ingo.  I'll cc you...

Cheers,
Rusty.
