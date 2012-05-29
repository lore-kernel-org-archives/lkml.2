Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752683Ab2E2F2y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 01:28:54 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:53557 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab2E2F2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 01:28:52 -0400
Date: Tue, 29 May 2012 14:28:44 +0900
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        axboe@kernel.dk, paul.gortmaker@windriver.com
Subject: Re: [PATCH 0/3] Generic rb tree code
Message-ID: <20120529052844.GB17366@google.com>
References: <1337979461-19654-1-git-send-email-koverstreet@google.com>
 <20120528232246.GC20954@dhcp-172-17-108-109.mtv.corp.google.com>
 <20120529033032.GB10175@dhcp-172-18-216-138.mtv.corp.google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120529033032.GB10175@dhcp-172-18-216-138.mtv.corp.google.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, Kent.

On Mon, May 28, 2012 at 11:30:32PM -0400, Kent Overstreet wrote:
> > Modeled after spinlock code how?  AFAICS, spinlock code doesn't
> > present inline and !inline versions to users. 
> 
> That probably wasn't intended, but it's how it works out.
> __raw_spin_lock() and all the variants are defined as inline functions,
> and then depending on whether CONFIG_INLINE_BLAH is enabled
> _raw_spin_lock_blah() is defined to __raw_spin_lock_blah(), otherwise
> _raw_spin_lock_blah() is a wrapper in a .c file.
> 
> But the end result is that the inline versions are also available.

Doesn't matter.  Nobody outside spinlock implementation proper should
be using them.

> > All the current users
> > are inline anyway, why not just provide inlined versions and worry
> > about whether inlining is beneifical in a separate patch?
> 
> Yeah, possible. I think it's only going to be an issue for rb_search()
> in practice (since rb_search needs the stack allocated search argument),
> should probably just drop the inline version of rb_insert().

As long as there's single version of the thing....

Thanks.

-- 
tejun
