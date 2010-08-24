Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752891Ab0HXTNt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Aug 2010 15:13:49 -0400
Received: from www84.your-server.de ([213.133.104.84]:60339 "EHLO
	www84.your-server.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207Ab0HXTNr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Aug 2010 15:13:47 -0400
Subject: Re: [RFC -v2] kfifo writer side lock-less support
From: Stefani Seibold <stefani@seibold.net>
To: huang.ying.caritas@gmail.com
Cc: Huang Ying <ying.huang@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1282654207.11483.32.camel@caritas-mobile.ml.org>
References: <1282614146.2708.13.camel@yhuang-dev>
	 <1282636558.7357.28.camel@wall-e.seibold.net>
	 <1282639425.2708.40.camel@yhuang-dev>
	 <1282640663.7896.17.camel@wall-e.seibold.net>
	 <1282654207.11483.32.camel@caritas-mobile.ml.org>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 24 Aug 2010 21:13:50 +0200
Message-ID: <1282677230.10219.22.camel@wall-e.seibold.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: stefani@seibold.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> > > The patch adds only 1 field (unsigned int) to struct __kfifo. I think
> > > that should be acceptable. Because sizeof(struct __kfifo) should be much
> > > smaller that __kfifo->mask + 1 in most cases.
> > 
> > I don't know what you mean with "because sizeof(struct __kfifo) should
> > be much smaller that __kfifo->mask + 1 in most cases". I am convinced
> > that you did not really understand the kfifo code. sizeof(struct
> > __kfifo) is constant and __kfifo->mask + 1 is the fifo size in elements,
> > which is not constant. Before you answering study the code first!
> > 
> > And is not acceptable to bload the struct __kfifo, because it will never
> > need by the most users.
> 
> I mean, for most user, __kfifo->mask + 1 > sizeof(struct __kfifo), so
> another 4 bytes for each user is relatively small.
> 

You have no idea. As i wrote you should study the code before answering!

sizeof(struct __kfifo) is always 20 bytes on a 32 bit cpu, and
kfifo->mask +1 depends on the size of the number of fifo elements and it
is an initialization parameter. 


If you will be able to shrink the footprint of the struct __kfifo,
whithout wasting the code, you are welcome to do. 

Currently you generate only a lot of hot air. The assertion in your
"number of elements or bytes for kfifo_in etc" thread was also wrong.
You should first study code and understand it.

Until you have can prove your assertion by measurements and working
patches, please stop bothering.

- Stefani


