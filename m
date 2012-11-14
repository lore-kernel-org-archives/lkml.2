Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396Ab2KNTmf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Nov 2012 14:42:35 -0500
Received: from casper.infradead.org ([85.118.1.10]:40790 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753017Ab2KNTme (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Nov 2012 14:42:34 -0500
Message-ID: <50A3F3FD.4070707@infradead.org>
Date: Wed, 14 Nov 2012 11:41:49 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linus <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        dri-devel@lists.freedesktop.org, Dave Airlie <airlied@gmail.com>
Subject: Re: linux-next: Tree for Nov 14 (gpu/drm/i915)
References: <20121114163042.64f0c0495663331b9c2d60d6@canb.auug.org.au>
In-Reply-To: <20121114163042.64f0c0495663331b9c2d60d6@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/13/2012 09:30 PM, Stephen Rothwell wrote:

> Hi all,
> 
> News: next-20121115 (i.e. tomorrow) will be the last release until
> next-20121126 (which should be just be after -rc7, I guess - assuming
> that Linus does not release v3.7 before then), so if you want something
> in linux-next for a reasonable amount of testing, it should probably be
> committed tomorrow.
> 
> Changes since 20121113:
> 



on i386:

ERROR: "__build_bug_on_failed" [drivers/gpu/drm/i915/i915.ko] undefined!

Reference to that symbol is found in
i915_gem_execbuffer.o.  Reference to BUILD_BUG_ON() is found in
i915_gem_execbuffer.c:

static struct eb_objects *
eb_create(int size)
{
	struct eb_objects *eb;
	int count = PAGE_SIZE / sizeof(struct hlist_head) / 2;
	BUILD_BUG_ON(!is_power_of_2(PAGE_SIZE / sizeof(struct hlist_head)));


-- 
~Randy
