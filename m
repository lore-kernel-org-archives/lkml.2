Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab2DMOZi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Apr 2012 10:25:38 -0400
Received: from mail-pz0-f52.google.com ([209.85.210.52]:37797 "EHLO
	mail-pz0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753607Ab2DMOZf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Apr 2012 10:25:35 -0400
Date: Fri, 13 Apr 2012 23:25:28 +0900
From: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
To: Takuya Yoshikawa <takuya.yoshikawa@gmail.com>
Cc: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Avi Kivity <avi@redhat.com>, Marcelo Tosatti <mtosatti@redhat.com>,
        Xiao Guangrong <xiaoguangrong.eric@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, KVM <kvm@vger.kernel.org>
Subject: Re: [PATCH 00/13] KVM: MMU: fast page fault
Message-Id: <20120413232528.c5ddbddb3cc0870d6e85a332@gmail.com>
In-Reply-To: <20120411231441.9d0984672dd252b806f99128@gmail.com>
References: <4F742951.7080003@linux.vnet.ibm.com>
	<4F82E04E.6000900@redhat.com>
	<20120409175829.GB21894@amt.cnet>
	<4F8329D3.7000605@gmail.com>
	<20120409194614.GB23053@amt.cnet>
	<4F840DD2.3090101@redhat.com>
	<20120410204031.ffb5b976225ac9fe6dae474e@gmail.com>
	<4F842074.1050108@linux.vnet.ibm.com>
	<20120411211514.35db29c11460516e604059b6@gmail.com>
	<4F857B61.9080602@linux.vnet.ibm.com>
	<20120411231441.9d0984672dd252b806f99128@gmail.com>
X-Mailer: Sylpheed 3.2.0beta3 (GTK+ 2.24.6; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Xiao,

Takuya Yoshikawa <takuya.yoshikawa@gmail.com> wrote:

> > What is your really want to say but i missed?
> 
> How to improve and what we should pay for that.
> 
> Note that I am not objecting to O(1) itself.
> 

I forgot to say one important thing -- I might give you wrong impression.

I am perfectly fine with your lock-less work.  It is really nice!

The reason I say much about O(1) is that O(1) and rmap based
GET_DIRTY_LOG have fundamentally different characteristics.

I am thinking really seriously how to make dirty page tracking work
well with QEMU in the future.

For example, I am thinking about multi-threaded and fine-grained
GET_DIRTY_LOG.

If we use rmap based GET_DIRTY_LOG, we can restrict write protection to
only a selected area of one guest memory slot.

So we may be able to make each thread process dirty pages independently
from other threads by calling GET_DIRTY_LOG for its own area.

But I know that O(1) has its own good point.
So please wait a bit.  I will write up what I am thinking or send patches.

Anyway, I am looking forward to your lock-less work!
It will improve the current GET_DIRTY_LOG performance.

Thanks,
	Takuya
