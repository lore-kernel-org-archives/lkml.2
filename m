Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753536Ab1BVX1d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Feb 2011 18:27:33 -0500
Received: from tex.lwn.net ([70.33.254.29]:43886 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752361Ab1BVX1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Feb 2011 18:27:32 -0500
Date: Tue, 22 Feb 2011 16:27:29 -0700
From: Jonathan Corbet <corbet@lwn.net>
To: Andrea Righi <arighi@develer.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Greg Thelen <gthelen@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Gui Jianfeng <guijianfeng@cn.fujitsu.com>,
        Ryo Tsuruta <ryov@valinux.co.jp>,
        Hirokazu Takahashi <taka@valinux.co.jp>, Jens Axboe <axboe@kernel.dk>,
        Andrew Morton <akpm@linux-foundation.org>,
        containers@lists.linux-foundation.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] page_cgroup: make page tracking available for blkio
Message-ID: <20110222162729.054fe596@bike.lwn.net>
In-Reply-To: <20110222230146.GB23723@linux.develer.com>
References: <1298394776-9957-1-git-send-email-arighi@develer.com>
	<1298394776-9957-4-git-send-email-arighi@develer.com>
	<20110222130145.37cb151e@bike.lwn.net>
	<20110222230146.GB23723@linux.develer.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.24.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 23 Feb 2011 00:01:47 +0100
Andrea Righi <arighi@develer.com> wrote:

> > My immediate observation is that you're not really tracking the "owner"
> > here - you're tracking an opaque 16-bit token known only to the block
> > controller in a field which - if changed by anybody other than the block
> > controller - will lead to mayhem in the block controller.  I think it
> > might be clearer - and safer - to say "blkcg" or some such instead of
> > "owner" here.
> 
> Basically the idea here was to be as generic as possible and make this
> feature potentially available also to other subsystems, so that cgroup
> subsystems may represent whatever they want with the 16-bit token.
> However, no more than a single subsystem may be able to use this feature
> at the same time.

That makes me nervous; it can't really be used that way unless we want to
say that certain controllers are fundamentally incompatible and can't be
allowed to play together.  For whatever my $0.02 are worth (given the
state of the US dollar, that's not a whole lot), I'd suggest keeping the
current mechanism, but make it clear that it belongs to your controller.
If and when another controller comes along with a need for similar
functionality, somebody can worry about making it more general.

jon
