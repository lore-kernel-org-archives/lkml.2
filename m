Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753725Ab2K2UWi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 15:22:38 -0500
Received: from mail-da0-f46.google.com ([209.85.210.46]:33824 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752609Ab2K2UWf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 15:22:35 -0500
Date: Thu, 29 Nov 2012 12:22:31 -0800
From: Kent Overstreet <koverstreet@google.com>
To: Benjamin LaHaise <bcrl@kvack.org>
Cc: Andi Kleen <andi@firstfloor.org>, linux-kernel@vger.kernel.org,
        linux-aio@kvack.org, linux-fsdevel@vger.kernel.org, zab@redhat.com,
        jmoyer@redhat.com, axboe@kernel.dk, viro@zeniv.linux.org.uk
Subject: Re: [PATCH 22/25] Generic dynamic per cpu refcounting
Message-ID: <20121129202231.GJ15094@google.com>
References: <1354121029-1376-1-git-send-email-koverstreet@google.com>
 <1354121029-1376-23-git-send-email-koverstreet@google.com>
 <m28v9kgsen.fsf@firstfloor.org>
 <20121129185720.GE15094@google.com>
 <20121129185953.GW16230@one.firstfloor.org>
 <20121129191214.GG15094@google.com>
 <20121129192003.GX16230@one.firstfloor.org>
 <20121129192925.GH15094@google.com>
 <20121129193452.GI19042@kvack.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121129193452.GI19042@kvack.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 02:34:52PM -0500, Benjamin LaHaise wrote:
> On Thu, Nov 29, 2012 at 11:29:25AM -0800, Kent Overstreet wrote:
> > There's some kind of symmetry going on here, and if I'd been awake more
> > in college I could probably say exactly why it works, but it does.
> 
> I think the catch is that using only a 32 bit counter is something the 
> user could arbitrarily control the sum of all parts.  I think a 64 bit 
> counter may be required to ensure no overflow occurs.  Otherwise, an 
> overflow could result in a premature free when there are still 2^32 
> objects active thanks to a malicious user (possible on systems with lots 
> of memory these days -- remote, but possible).

That's no different from regular atomic_t - but you're right, we
should be using size_t for anything userspace can manipulate.

Not gonna worry about it in this patch though because the refcount was
an atomic_t before and userspace can only do one get per thread.
