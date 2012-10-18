Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756035Ab2JRNb6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 09:31:58 -0400
Received: from mx1.redhat.com ([209.132.183.28]:62443 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755597Ab2JRNby (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 09:31:54 -0400
Date: Thu, 18 Oct 2012 09:31:49 -0400
From: Vivek Goyal <vgoyal@redhat.com>
To: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Cc: Tejun Heo <tj@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] Fix use-after-free of q->root_blkg and q->root_rl.blkg
Message-ID: <20121018133149.GA18147@redhat.com>
References: <50750367.2070508@ce.jp.nec.com>
 <20121010155929.GA18733@redhat.com>
 <50762182.5090806@ce.jp.nec.com>
 <20121016232040.GH16166@google.com>
 <507DF58E.8060804@ce.jp.nec.com>
 <20121017134704.GB31663@redhat.com>
 <507F6FE2.3030303@ce.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <507F6FE2.3030303@ce.jp.nec.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 18, 2012 at 11:56:34AM +0900, Jun'ichi Nomura wrote:

[..]
> >>>         if (ent == &q->root_blkg->q_node)
> >>
> >> So ent is not &q->root_blkg->q_node.
> > 
> > If q->root_blkg is NULL, will it not lead to NULL pointer dereference.
> > (q->root_blkg->q_node).
> 
> It's not dereferenced.

Ok. We are taking address of root_blkg->q_node so even if root_blkg=NULL,
address is just offset from null. Little subtle for me. :-)

> 
> >>>                 ent = ent->next;
> >>>         if (ent == &q->blkg_list)
> >>>                 return NULL;
> >>
> >> And we return NULL here.
> >>
> >> Ah, yes. You are correct.
> >> We can do without the above hunk.
> > 
> > I would rather prefer to check for this boundary condition early and
> > return instead of letting it fall through all these conditions and
> > then figure out yes we have no next rl. IMO, code becomes easier to
> > understand if nothing else. Otherwise one needs a step by step 
> > explanation as above to show that case of q->root_blkg is covered.
> 
> I have same opinion as yours that it's good for readability.


Tejun, for the sake of readability, are you fine with keeping the original
check and original patch which I had acked.

Thanks
Vivek
