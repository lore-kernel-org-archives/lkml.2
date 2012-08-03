Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744Ab2HCVsO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 17:48:14 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:38494 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753107Ab2HCVsL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 17:48:11 -0400
Date: Fri, 3 Aug 2012 14:48:06 -0700
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@elte.hu, ebiederm@xmission.com, aarcange@redhat.com,
        ericvh@gmail.com, netdev@vger.kernel.org
Subject: Re: [RFC v2 1/7] hashtable: introduce a small and naive hashtable
Message-ID: <20120803214806.GM15477@google.com>
References: <1344003788-1417-1-git-send-email-levinsasha928@gmail.com>
 <1344003788-1417-2-git-send-email-levinsasha928@gmail.com>
 <20120803171515.GH15477@google.com>
 <501C407D.9080900@gmail.com>
 <20120803213017.GK15477@google.com>
 <501C458E.7050000@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501C458E.7050000@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Fri, Aug 03, 2012 at 11:41:34PM +0200, Sasha Levin wrote:
> I forgot to comment on that one, sorry.
> 
> If we put hash entries after struct hash_table we don't take the
> bits field size into account, or did I miss something?

So, if you do the following,

	struct {
		struct {
			int i;
			long ar[];
		} B;
		long __ar_storage[32];
	} A;

It should always be safe to dereference A.B.ar[31].  I'm not sure
whether this is something guaranteed by C tho.  Maybe compilers are
allowed to put members in reverse order but I think we already depend
on the above.

Thanks.

-- 
tejun
