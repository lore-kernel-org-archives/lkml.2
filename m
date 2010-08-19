Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751373Ab0HSBPH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Aug 2010 21:15:07 -0400
Received: from mga02.intel.com ([134.134.136.20]:8680 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751119Ab0HSBPG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Aug 2010 21:15:06 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,230,1280732400"; 
   d="scan'208";a="546640783"
Subject: Re: number of elements or bytes for kfifo_in etc
From: Huang Ying <ying.huang@intel.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1282177950.2744.1587.camel@yhuang-dev>
References: <1282109365.2744.1549.camel@yhuang-dev>
	 <1282149358.5103.5.camel@wall-e.seibold.net>
	 <1282177950.2744.1587.camel@yhuang-dev>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 19 Aug 2010 09:15:03 +0800
Message-ID: <1282180503.2744.1594.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-08-19 at 08:32 +0800, Huang Ying wrote:
> Hi, Stefani,
> 
> On Thu, 2010-08-19 at 00:35 +0800, Stefani Seibold wrote:
> > Am Mittwoch, den 18.08.2010, 13:29 +0800 schrieb Huang Ying:
> > > Hi, Stefani,
> > > 
> > > In new kfifo implementation in 2.6.36-rc1, description of the third
> > > parameter is:
> > > 
> > > "@n: number of elements to be added"
> > > 
> > > But if my understanding is correct, the actual implementation is:
> > > 
> > > "@n: number of bytes to be added"
> > > 
> > 
> > Number of bytes is wrong, this is only valid for byte stream fifo's
> > where an element is a byte.
> > 
> > Have a look at samples/kfifo/inttype-example.c where an element is a int
> > type.
> 
> Yes. You are right. I misunderstood your code. Sorry for bothering.

And I found __kfifo->esize is used in __kfifo_in/out etc to convert
between elements and bytes. Maybe we can pull the conversion code to
corresponding macro, because where esize is constant and may be
optimized to bit shifting or nothing. What do you think about that?

Best Regards,
Huang Ying


