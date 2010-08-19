Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751526Ab0HSGw5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Aug 2010 02:52:57 -0400
Received: from www84.your-server.de ([213.133.104.84]:44388 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751163Ab0HSGw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Aug 2010 02:52:56 -0400
Subject: Re: number of elements or bytes for kfifo_in etc
From: Stefani Seibold <stefani@seibold.net>
To: Huang Ying <ying.huang@intel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1282180503.2744.1594.camel@yhuang-dev>
References: <1282109365.2744.1549.camel@yhuang-dev>
	 <1282149358.5103.5.camel@wall-e.seibold.net>
	 <1282177950.2744.1587.camel@yhuang-dev>
	 <1282180503.2744.1594.camel@yhuang-dev>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Thu, 19 Aug 2010 08:52:58 +0200
Message-ID: <1282200778.3752.7.camel@wall-e.seibold.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Donnerstag, den 19.08.2010, 09:15 +0800 schrieb Huang Ying:
> On Thu, 2010-08-19 at 08:32 +0800, Huang Ying wrote:
> > Hi, Stefani,
> > 
> > On Thu, 2010-08-19 at 00:35 +0800, Stefani Seibold wrote:
> > > Am Mittwoch, den 18.08.2010, 13:29 +0800 schrieb Huang Ying:
> > > > Hi, Stefani,
> > > > 
> > > > In new kfifo implementation in 2.6.36-rc1, description of the third
> > > > parameter is:
> > > > 
> > > > "@n: number of elements to be added"
> > > > 
> > > > But if my understanding is correct, the actual implementation is:
> > > > 
> > > > "@n: number of bytes to be added"
> > > > 
> > > 
> > > Number of bytes is wrong, this is only valid for byte stream fifo's
> > > where an element is a byte.
> > > 
> > > Have a look at samples/kfifo/inttype-example.c where an element is a int
> > > type.
> > 
> > Yes. You are right. I misunderstood your code. Sorry for bothering.
> 
> And I found __kfifo->esize is used in __kfifo_in/out etc to convert
> between elements and bytes. Maybe we can pull the conversion code to
> corresponding macro, because where esize is constant and may be
> optimized to bit shifting or nothing. What do you think about that?
> 

esize isn't constant, especially from the point of view inside
__kfifo_in and so on. The is ony good reason not to pass the size of the
element using sizeof(*fifo->type) as a parameter, it will generate more
code. Storing the size of the element in the kfifo structure is the
better decision.

But if you found a better way and can prove it under any circumstance
with a list of measurement results u will get an ack!

- Stefani


