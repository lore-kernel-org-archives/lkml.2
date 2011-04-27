Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755024Ab1D0BTr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 21:19:47 -0400
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:57853 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438Ab1D0BTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 21:19:46 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: (resend) [PATCH] vmscan,memcg: memcg aware swap token
Cc: kosaki.motohiro@jp.fujitsu.com, LKML <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>,
        Nishimura Daisuke <d-nishimura@mtf.biglobe.ne.jp>
In-Reply-To: <20110426130724.f2ae18e3.akpm@linux-foundation.org>
References: <20110426170146.F396.A69D9226@jp.fujitsu.com> <20110426130724.f2ae18e3.akpm@linux-foundation.org>
Message-Id: <20110427102126.D174.A69D9226@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
X-Mailer: Becky! ver. 2.56.05 [ja]
Date: Wed, 27 Apr 2011 10:19:41 +0900 (JST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Tue, 26 Apr 2011 16:59:19 +0900 (JST)
> KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com> wrote:
> 
> > @@ -75,3 +76,19 @@ void __put_swap_token(struct mm_struct *mm)
> >  		swap_token_mm = NULL;
> >  	spin_unlock(&swap_token_lock);
> >  }
> > +
> > +int has_swap_token_memcg(struct mm_struct *mm, struct mem_cgroup *memcg)
> > +{
> > +	if (memcg) {
> > +		struct mem_cgroup *swap_token_memcg;
> > +
> > +		/*
> > +		 * memcgroup reclaim can disable swap token only if token task
> > +		 * is in the same cgroup.
> > +		 */
> > +		swap_token_memcg = try_get_mem_cgroup_from_mm(swap_token_mm);
> > +		return ((mm == swap_token_mm) && (memcg == swap_token_memcg));
> > +	} else
> > +		return (mm == swap_token_mm);
> > +}
> 
> Seems to be missing a css_put()?

Yes! Please drop this one. I'll rework it at this weekend.

Thank you for the finding!

> 
> Either I'm mistaken or that's a bug.  Perhaps neither of these would
> have happened if we'd bothered to document
> try_get_mem_cgroup_from_mm().
> 



