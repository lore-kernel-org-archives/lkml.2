Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755295Ab2IHPip (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Sep 2012 11:38:45 -0400
Received: from one.firstfloor.org ([213.235.205.2]:49063 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755112Ab2IHPim (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Sep 2012 11:38:42 -0400
Date: Sat, 8 Sep 2012 17:38:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Jeff Layton <jlayton@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, viro@zeniv.linux.org.uk,
        eparis@redhat.com, linux-audit@redhat.com,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 00/10] vfs: getname/putname overhaul
Message-ID: <20120908153836.GK16230@one.firstfloor.org>
References: <1347025085-20285-1-git-send-email-jlayton@redhat.com> <m2r4qd4j8f.fsf@firstfloor.org> <20120907205418.244bd797@corrin.poochiereds.net> <20120908030850.GH16230@one.firstfloor.org> <20120908072426.2880971f@corrin.poochiereds.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120908072426.2880971f@corrin.poochiereds.net>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I could see that allocating out of the slab would mean less waste when
> you have >4k pages, but why would it be faster than just allocating a
> page directly?

The slab allocator is far more optimized than the page allocator 
for the fast path (in fact page could need some major diet in its fast path)

At least that was the established wisdom some time ago, haven't recently
rechecked it.


> Also, by "track separately" do you mean that you think I should drop
> patch 9 in this series and just do two allocations for a getname in all
> cases?

Just meant what you already do in the patchkit.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
