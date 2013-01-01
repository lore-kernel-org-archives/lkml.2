Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752475Ab3AATPm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jan 2013 14:15:42 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:35105 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752412Ab3AATPk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jan 2013 14:15:40 -0500
Date: Tue, 1 Jan 2013 11:15:06 -0800
From: Kent Overstreet <koverstreet@google.com>
To: john.wensley@gmail.com
Cc: fa.linux.kernel@googlegroups.com, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, Zach Brown <zab@redhat.com>, bcrl@kvack.org,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk,
        tytso@mit.edu
Subject: Re: [PATCH 03/32] gadget: remove only user of aio retry
Message-ID: <20130101191506.GE10411@moria.home.lan>
References: <fa.bKjJDjpiXe4ZyttQxy70URjcaYU@ifi.uio.no>
 <fa.aKiGvXaqF8zkt42DoAyNZWYEe5M@ifi.uio.no>
 <9d57e984-32bd-4d94-8137-6aeec4cf5986@googlegroups.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9d57e984-32bd-4d94-8137-6aeec4cf5986@googlegroups.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 29, 2012 at 12:19:10AM -0800, john.wensley@gmail.com wrote:
> On Thursday, December 27, 2012 4:08:46 AM UTC+2, Kent Overstreet wrote:
> ...
> 
> Great. Did you measure by how much your changes improve performance?

This particular patch? No. As for the whole series, Jens has done the
best actual benchmarks; mostly I've just been looking at profiles - I
don't have any high end hardware with drivers suitable for that kind of
benchmarking, myself.

Also, my changes have been particularly aimed at improving the situation
where an ioctx is shared between different threads; we don't have any
actual benchmarks for how much that's improved as fio doesn't do that
but the gains there are going to be much more significant, for
applications where that's useful.
