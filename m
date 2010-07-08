Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757812Ab0GHNkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 09:40:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:1038 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755461Ab0GHNj7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 09:39:59 -0400
From: Jeff Moyer <jmoyer@redhat.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux kernel mailing list <linux-kernel@vger.kernel.org>,
       Jens Axboe <axboe@kernel.dk>, Corrado Zoccolo <czoccolo@gmail.com>,
       Nauman Rafique <nauman@google.com>, Divyesh Shah <dpshah@google.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>
Subject: Re: [RFC/RFT PATCH] cfq-iosched: Implement cfq group idling
References: <20100707230521.GB7842@redhat.com>
X-PGP-KeyID: 1F78E1B4
X-PGP-CertKey: F6FE 280D 8293 F72C 65FD  5A58 1FF8 A7CA 1F78 E1B4
X-PCLoadLetter: What the f**k does that mean?
Date: Thu, 08 Jul 2010 09:39:45 -0400
In-Reply-To: <20100707230521.GB7842@redhat.com> (Vivek Goyal's message of
	"Wed, 7 Jul 2010 19:05:21 -0400")
Message-ID: <x4939vuf5y6.fsf@segfault.boston.devel.redhat.com>
User-Agent: Gnus/5.110011 (No Gnus v0.11) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek Goyal <vgoyal@redhat.com> writes:

> Currently we idle on sequential queues and allow dispatch from a single
> queue and that can become a bottleneck on higher end storage. For example
> on my HP EVA, I can run multiple sequential streams and achieve top BW
> of around 350 MB/s. But with CFQ, dispatching from single queue does not
> keep the array busy (limits to 150-180 MB/s with 4 or 8 processes).
>
> One approach to solve this issue is simply use slice_idle = 0. But this
> also takes away the any service differentiation between groups.

That also takes away service differentiation between queues.  If you
want to maintain that at all, then this is really just pushing the
problem to another layer.

This is the crux of my issues with CFQ.  It works really well for SATA
disks.  Once you try running it on enterprise storage, it falls flat.
Is it a design goal of CFQ to get it to run well on enterprise storage?

Jens?

Cheers,
Jeff
