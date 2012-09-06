Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757213Ab2IGAC5 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 20:02:57 -0400
Received: from ozlabs.org ([203.10.76.45]:52672 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755656Ab2IGAC0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 20:02:26 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kent Overstreet <koverstreet@google.com>,
        "Michael S. Tsirkin" <mst@redhat.com>
Cc: virtualization@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] virtio-blk: Fix kconfig option
In-Reply-To: <20120906100247.GA27355@koverstreet-glaptop>
References: <20120903044133.GA9980@moria.home.lan> <87wr0ae26e.fsf@rustcorp.com.au> <20120906074113.GA5902@koverstreet-glaptop> <20120906084403.GD17656@redhat.com> <20120906092512.GB5902@koverstreet-glaptop> <20120906094956.GB22816@redhat.com> <20120906100247.GA27355@koverstreet-glaptop>
User-Agent: Notmuch/0.13.2 (http://notmuchmail.org) Emacs/23.3.1 (i686-pc-linux-gnu)
Date: Fri, 07 Sep 2012 09:10:25 +0930
Message-ID: <87zk52hg9i.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kent Overstreet <koverstreet@google.com> writes:

> On Thu, Sep 06, 2012 at 12:49:56PM +0300, Michael S. Tsirkin wrote:
>> On Thu, Sep 06, 2012 at 02:25:12AM -0700, Kent Overstreet wrote:
>> > Do you not understand the difference between depends an selects?
>> > Or did you not read my original mail?

Now you're getting insulting.

It's normal for options to depend on other options.  Sometimes they're
directly nested (eg. E1000 depends on NETDEVICES, and it's nested under
that option), sometimes they're not (eg. E1000 depends on PCI, which is
selected elsewhere).

The fact that you are only just realizing this is not Michael's problem.

>> > Flip off everything in drivers -> virtio
>> > 
>> > Now go to drivers -> block and try to turn on virtio-blk.
>> > 
>> > It's not listed!
>> 
>> Yes. Because you disabled all virtio backends.
>> It does not make sense to have any frontends.
>
> How's a user - or even another kernel developer who isn't familiar with
> virtio - supposed to know that?

I get annoyed that menuconfig doesn't show options whose dependencies
aren't possible, too.  (I got bitten the other way: it doesn't show
dependencies which can't be disabled, and I was trying to turn KALLSYMS
off).

But as I found out just last week, the '/' key allows you to find any
option, and shows what dependencies it has, and their values.

Hope that helps,
Rusty.
