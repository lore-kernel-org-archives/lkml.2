Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755720Ab2JPXUq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Oct 2012 19:20:46 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:52100 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754243Ab2JPXUo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Oct 2012 19:20:44 -0400
Date: Tue, 16 Oct 2012 16:20:40 -0700
From: Tejun Heo <tj@kernel.org>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Vivek Goyal <vgoyal@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix use-after-free of q->root_blkg and q->root_rl.blkg
Message-ID: <20121016232040.GH16166@google.com>
References: <50750367.2070508@ce.jp.nec.com>
 <20121010155929.GA18733@redhat.com>
 <50762182.5090806@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50762182.5090806@ce.jp.nec.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu, Oct 11, 2012 at 10:31:46AM +0900, Jun'ichi Nomura wrote:
> >> -	if (ent == &q->root_blkg->q_node)
> >> +	if (q->root_blkg && ent == &q->root_blkg->q_node)
> > 
> > Can we fix it little differently. Little earlier in the code, we check for
> > if q->blkg_list is empty, then all the groups are gone, and there are
> > no more request lists hence and return NULL.
> > 
> > Current code:
> >         if (rl == &q->root_rl) {
> >                 ent = &q->blkg_list;
> > 
> > Modified code:
> >         if (rl == &q->root_rl) {
> >                 ent = &q->blkg_list;
> > 		/* There are no more block groups, hence no request lists */
> > 		if (list_empty(ent))
> > 			return NULL;
> > 	}

Do we need this at all?  q->root_blkg being NULL is completely fine
there and the comparison would work as expected, no?

Thanks.

-- 
tejun
