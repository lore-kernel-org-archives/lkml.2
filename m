Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758466Ab2DYMqZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 08:46:25 -0400
Received: from mail-ey0-f174.google.com ([209.85.215.174]:36822 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757239Ab2DYMqW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 08:46:22 -0400
Subject: Re: many rx packets dropped since 2.6.37
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Chris <xchris89x@googlemail.com>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <CAOFJUkj27aF6diDjcZFTyBaTdDdU8URkj+1vr3ECoozbzqDVBg@mail.gmail.com>
References: <CAOFJUkhi6NoECFGcz=rq8-uVXFc90V4SuH=A1+sWdvYDDhO8Ow@mail.gmail.com>
	 <1335353427.3274.103.camel@edumazet-glaptop>
	 <CAOFJUkj27aF6diDjcZFTyBaTdDdU8URkj+1vr3ECoozbzqDVBg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 25 Apr 2012 14:46:15 +0200
Message-ID: <1335357975.3274.187.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-04-25 at 14:34 +0200, Chris wrote:

> Are you sure that these packets are really dropped? I see a lot of
> more packets dropped with virtio_net instead of e1000. (KVM
> environments)
> 

Yep, we are sure packets are dropped, just read the patch and you'll can
see this.

> Why do we see dropped packets only in virtual environments and bonded
> network interfaces and not on real network interfaces?

This has to be investigated, eventually.

About the bond, if you are in active-backup mode, a frame coming to
inactive device is going to be dropped, or you could have duplication of
logical frames.

You can use tcpdump to get a copy of these frames.



