Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754010Ab2JIS2H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 14:28:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54551 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883Ab2JIS2E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 14:28:04 -0400
Date: Tue, 9 Oct 2012 11:27:55 -0700
From: Zach Brown <zab@redhat.com>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, tytso@mit.edu
Subject: Re: [PATCH 3/5] aio: Rewrite refcounting
Message-ID: <20121009182755.GN26187@lenny.home.zabbo.net>
References: <1349764760-21093-1-git-send-email-koverstreet@google.com>
 <1349764760-21093-3-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349764760-21093-3-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 11:39:18PM -0700, Kent Overstreet wrote:
> The refcounting before wasn't very clear; there are two refcounts in
> struct kioctx, with an unclear relationship between them (or between
> them and ctx->dead).
> 
> Now, reqs_active holds a refcount on users (when reqs_active is
> nonzero), and the initial refcount is taken on reqs_active - when
> ctx->dead goes to 1, we drop that initial refcount.

I agree that it's a mess, but let's rethink this work on top of the
series I'm sending out that gets rid of the retry and cancel code.  It
makes the code a lot easier to follow.  (And Jens also has some patches
to take fewer locks in the submission path, we'll want to take them into
account too.)

- z
