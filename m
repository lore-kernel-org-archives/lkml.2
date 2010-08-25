Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752612Ab0HYIkN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Aug 2010 04:40:13 -0400
Received: from mga02.intel.com ([134.134.136.20]:54317 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752350Ab0HYIkK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Aug 2010 04:40:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.56,267,1280732400"; 
   d="scan'208";a="548529741"
Subject: Re: [RFC -v2] kfifo writer side lock-less support
From: Huang Ying <ying.huang@intel.com>
To: Stefani Seibold <stefani@seibold.net>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andi Kleen <andi@firstfloor.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <1282640663.7896.17.camel@wall-e.seibold.net>
References: <1282614146.2708.13.camel@yhuang-dev>
	 <1282636558.7357.28.camel@wall-e.seibold.net>
	 <1282639425.2708.40.camel@yhuang-dev>
	 <1282640663.7896.17.camel@wall-e.seibold.net>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Aug 2010 16:40:07 +0800
Message-ID: <1282725607.2708.96.camel@yhuang-dev>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-08-24 at 17:04 +0800, Stefani Seibold wrote:
> > > The regular use case of a fifo is that there is one write and one
> > > reader. In this case, the current implementation of the kfifo structure
> > > is lock less.
> > > 
> > > So i you need this, than it would be better to use the ring buffer.
> > 
> 
> But you waste a clean interface designed together with the community.
> 
> > I really need multiple-writers and one reader in APEI GHES support, and
> > I need lock-less in writer side (because the buffer need to be written
> > in NMI handler). So I can not use the original kfifo implementation.
> > 
> 
> I believe you that you need it, but the question is: Is there more users
> who need it. And i am sure, there are no more users or very very few.
> 
> So for the protocol a big NAK!

We really need the lock-less writer side support. So we try to do that
by extending kfifo. But it is clear that you don't like our design and
implementation. Can you help us to design a better protocol for it?

Thanks,
Huang Ying


