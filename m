Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759479Ab2CTDkS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Mar 2012 23:40:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:59472 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758019Ab2CTDkP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Mar 2012 23:40:15 -0400
MIME-Version: 1.0
X-Originating-IP: [59.167.234.130]
In-Reply-To: <CAL1RGDVAd-LiS0sy6RAFNzkUuXrcuGv829nADcnxUnC2tfx3bw@mail.gmail.com>
References: <CAOzFzEiufg40gKBH6D7zeB47SebfPvgzqOLxhF5eQqpYd-r4zQ@mail.gmail.com>
	<CAOzFzEi=UOnwiV+qVks7+RnYU3PFbaQ+3OaEE3YFG2HHuD5ydQ@mail.gmail.com>
	<CAL1RGDVAd-LiS0sy6RAFNzkUuXrcuGv829nADcnxUnC2tfx3bw@mail.gmail.com>
Date: Tue, 20 Mar 2012 14:33:03 +1100
Message-ID: <CAOzFzEgSWHqabw9yq6JxhD+CxQY61O+gqGwPMdbWPC=M+_oZAw@mail.gmail.com>
Subject: Re: Kernel Panic with bonding + IPoIB on 3.2.9
From: Joseph Glanville <joseph.glanville@orionvm.com.au>
To: Roland Dreier <roland@purestorage.com>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 March 2012 06:05, Roland Dreier <roland@purestorage.com> wrote:
> On Sun, Mar 18, 2012 at 1:21 PM, Joseph Glanville
> <joseph.glanville@orionvm.com.au> wrote:
>> [  422.047024] kernel BUG at net/core/dev.c:1896!
>
> So this line is
>
>        BUG_ON(offset >= skb_headlen(skb));
>
> right?  No paritcular idea how we hit this, though...

Yep... I have looked through most of /drivers/net/bonding and I can't
really see why it should be blowing up there.. it really should cause
the BUG_ON under normal IPoIB if the MTU was the cause - yet I have
not experienced this.
The bonding code doesn't seem to do anything special with the MTU
other than propagating changes to the slaves.

-- 
Founder | Director | VP Research
Orion Virtualisation Solutions | www.orionvm.com.au | Phone: 1300 56
99 52 | Mobile: 0428 754 846
