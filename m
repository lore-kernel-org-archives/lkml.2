Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754002Ab2HCWXq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 18:23:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40114 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753839Ab2HCWXo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 18:23:44 -0400
Date: Fri, 3 Aug 2012 15:23:39 -0700
From: Tejun Heo <tj@kernel.org>
To: Sasha Levin <levinsasha928@gmail.com>
Cc: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        paul.gortmaker@windriver.com, davem@davemloft.net, rostedt@goodmis.org,
        mingo@elte.hu, ebiederm@xmission.com, aarcange@redhat.com,
        ericvh@gmail.com, netdev@vger.kernel.org
Subject: Re: [RFC v2 1/7] hashtable: introduce a small and naive hashtable
Message-ID: <20120803222339.GN15477@google.com>
References: <1344003788-1417-1-git-send-email-levinsasha928@gmail.com>
 <1344003788-1417-2-git-send-email-levinsasha928@gmail.com>
 <20120803171515.GH15477@google.com>
 <501C407D.9080900@gmail.com>
 <20120803213017.GK15477@google.com>
 <501C458E.7050000@gmail.com>
 <20120803214806.GM15477@google.com>
 <501C4E92.1070801@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501C4E92.1070801@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Sat, Aug 04, 2012 at 12:20:02AM +0200, Sasha Levin wrote:
> On 08/03/2012 11:48 PM, Tejun Heo wrote:
> > On Fri, Aug 03, 2012 at 11:41:34PM +0200, Sasha Levin wrote:
> >> I forgot to comment on that one, sorry.
> >>
> >> If we put hash entries after struct hash_table we don't take the
> >> bits field size into account, or did I miss something?
> > 
> > So, if you do the following,
> > 
> > 	struct {
> > 		struct {
> > 			int i;
> > 			long ar[];
> > 		} B;
> > 		long __ar_storage[32];
> > 	} A;
> 
> struct A should have been an union, right?

I actually meant an enclosing struct.  When you're defining a struct
member, simply putting the storage after a struct with var array
should be good enough.  If that doesn't work, quite a few things in
the kernel will break.

Thanks.

-- 
tejun
