Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752589Ab2E2Dai (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 23:30:38 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:60425 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752070Ab2E2Dag (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 23:30:36 -0400
Date: Mon, 28 May 2012 23:30:32 -0400
From: Kent Overstreet <koverstreet@google.com>
To: Tejun Heo <tj@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        axboe@kernel.dk, paul.gortmaker@windriver.com
Subject: Re: [PATCH 0/3] Generic rb tree code
Message-ID: <20120529033032.GB10175@dhcp-172-18-216-138.mtv.corp.google.com>
References: <1337979461-19654-1-git-send-email-koverstreet@google.com>
 <20120528232246.GC20954@dhcp-172-17-108-109.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120528232246.GC20954@dhcp-172-17-108-109.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 29, 2012 at 08:22:46AM +0900, Tejun Heo wrote:
> On Fri, May 25, 2012 at 01:57:38PM -0700, Kent Overstreet wrote:
> > Right now, users of the rb tree code have to open code their own search and
> > insert functions. This provides generic versions that you pass a comparison
> > function to.
> > 
> > I highly doubt the extra function calls are going to have a measurable
> > performance impact in practice - the pointer chasing is going to dominate. I
> > did provide inline versions just in case, though - it's modelled after the
> > spinlock code.
> 
> Modeled after spinlock code how?  AFAICS, spinlock code doesn't
> present inline and !inline versions to users. 

That probably wasn't intended, but it's how it works out.
__raw_spin_lock() and all the variants are defined as inline functions,
and then depending on whether CONFIG_INLINE_BLAH is enabled
_raw_spin_lock_blah() is defined to __raw_spin_lock_blah(), otherwise
_raw_spin_lock_blah() is a wrapper in a .c file.

But the end result is that the inline versions are also available.

> All the current users
> are inline anyway, why not just provide inlined versions and worry
> about whether inlining is beneifical in a separate patch?

Yeah, possible. I think it's only going to be an issue for rb_search()
in practice (since rb_search needs the stack allocated search argument),
should probably just drop the inline version of rb_insert().
