Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754401Ab2HIDZH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Aug 2012 23:25:07 -0400
Received: from mail-gh0-f174.google.com ([209.85.160.174]:44244 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753602Ab2HIDZE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Aug 2012 23:25:04 -0400
MIME-Version: 1.0
In-Reply-To: <20120809031936.GM7262@moria.home.lan>
References: <1344290921-25154-1-git-send-email-koverstreet@google.com>
	<1344290921-25154-13-git-send-email-koverstreet@google.com>
	<Pine.LNX.4.64.1208061913500.21956@file.rdu.redhat.com>
	<20120808232804.GL6983@dhcp-172-17-108-109.mtv.corp.google.com>
	<CAFR8uedZiG0NWgWQQa03r+kKh8rT0jzpj+hwPzq+i7K6zhpT_A@mail.gmail.com>
	<20120809031936.GM7262@moria.home.lan>
Date: Wed, 8 Aug 2012 20:25:03 -0700
Message-ID: <CAH+dOxKr=BcWO5qmYZkrc2px+ckx=_+viWQ9M2hE7RMA3DaXNg@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH v5 12/12] block: Only clone bio vecs that are
 in use
From: Kent Overstreet <koverstreet@google.com>
To: Muthu Kumar <muthu.lkml@gmail.com>
Cc: Tejun Heo <tj@kernel.org>, Mikulas Patocka <mpatocka@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        axboe@kernel.dk, vgoyal@redhat.com, yehuda@hq.newdream.net,
        sage@newdream.net, agk@redhat.com, drbd-dev@lists.linbit.com
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 8, 2012 at 8:19 PM, Kent Overstreet <koverstreet@google.com> wrote:
> In particular, if this change breaks anything then the new bio_split()
> _will_ break things.
>
> We need to be clear about our interfaces; in this case bi_idx and
> bi_vcnt, in particular. Either this is a safe change, or it's not. If
> no one knows... that's a bigger problem, and not just for this patch...
>
> Fortunately this code actually has been tested quite a bit (and the bio
> splitting code for even longer), and (somewhat to my surprise) I haven't
> run into any bugs caused by it.

Oh, it's worse than that - remember how bio_kmalloc() works for up to
1024 pages, but bio_alloc_bioset() only up to 256?

We can already have situations where bios are allocated that are
impossible to clone (or if we don't, it's only because of
queue_limits. That's not sketchy at all.)
