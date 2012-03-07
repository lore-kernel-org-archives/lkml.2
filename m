Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031790Ab2CGBaY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 20:30:24 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33585 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031777Ab2CGBaR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 20:30:17 -0500
Date: Tue, 6 Mar 2012 17:29:46 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
cc: Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>, linux-mm@kvack.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Hillf Danton <dhillf@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] memcg: fix mapcount check in move charge code for
 anonymous page
In-Reply-To: <1331076667-11118-1-git-send-email-n-horiguchi@ah.jp.nec.com>
Message-ID: <alpine.LSU.2.00.1203061722040.1431@eggly.anvils>
References: <1331076667-11118-1-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 6 Mar 2012, Naoya Horiguchi wrote:
> 
> IMO, ideally the charge of shared (both file and anon) pages should
> be accounted for all cgroups to which the processes mapping the pages
> belong to, where each charge is weighted by inverse number of mapcount.
> I think accounting total number of mapcount with another counter does
> not work, because the weight of charge depends on each page and the
> total count of mapcount doesn't describe the proportion among cgroups.
> But anyway, it adds more complexity and needs much work, so is not
> a short term fix.

That "ideal" complexity was considered before the current memcg approach
went in.  We elected to go with the less satisfying, but much simpler,
single-owner approach, and it does seem to have paid off.  I believe
that even those who had successfully developed a more complex approach
have since abandoned it for performance scalability reasons.

Hugh
