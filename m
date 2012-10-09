Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755722Ab2JIWV7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 18:21:59 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:38236 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754222Ab2JIWV5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 18:21:57 -0400
Date: Tue, 9 Oct 2012 15:21:53 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Zach Brown <zab@redhat.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tytso@mit.edu
Subject: Re: [PATCH 3/5] aio: Rewrite refcounting
Message-ID: <20121009222153.GG29494@google.com>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-3-git-send-email-koverstreet@google.com>
 <20121009182755.GN26187@lenny.home.zabbo.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121009182755.GN26187@lenny.home.zabbo.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 11:27:55AM -0700, Zach Brown wrote:
> On Mon, Oct 08, 2012 at 11:39:18PM -0700, Kent Overstreet wrote:
> > The refcounting before wasn't very clear; there are two refcounts in
> > struct kioctx, with an unclear relationship between them (or between
> > them and ctx->dead).
> > 
> > Now, reqs_active holds a refcount on users (when reqs_active is
> > nonzero), and the initial refcount is taken on reqs_active - when
> > ctx->dead goes to 1, we drop that initial refcount.
> 
> I agree that it's a mess, but let's rethink this work on top of the
> series I'm sending out that gets rid of the retry and cancel code.  It
> makes the code a lot easier to follow.  (And Jens also has some patches
> to take fewer locks in the submission path, we'll want to take them into
> account too.)

Alright... send it out then. Also, do you know which branch Jens has his
patches in?
