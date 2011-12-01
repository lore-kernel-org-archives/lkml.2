Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755248Ab1LAPk6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Dec 2011 10:40:58 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35718 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754766Ab1LAPk5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Dec 2011 10:40:57 -0500
Date: Thu, 1 Dec 2011 10:40:36 -0500
From: Jason Baron <jbaron@redhat.com>
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        rostedt@goodmis.org
Subject: Re: [PATCH] jump_label: jump_label for boot options.
Message-ID: <20111201154036.GA2443@redhat.com>
References: <20111201115353.563f79fc.kamezawa.hiroyu@jp.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111201115353.563f79fc.kamezawa.hiroyu@jp.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 01, 2011 at 11:53:53AM +0900, KAMEZAWA Hiroyuki wrote:
> I tried to use jump_label for handling memcg's boot options which sets
> global variable true/false and never changes after boot. And found jump_table
> is larger than expected. This patch is a trial to allow to place jump_table
> in .init section. How do you think ?
> 

Remeber too, that 'static_branch()' is inherently biased. That is, the
'false' path is assumed to be the the most likely path. Thus, the 'true'
path is move out-of-line. Thus, if the 'true' branch is potentially
used all the time, we would want to make sure that the savings of not
having to check a variable is still worth it. I should probably rename
static_branch() -> 'static_branch_default_false()' to make that clear.

Maybe we need an unbiased static_branch() too, but I'm not sure excatly
how to implement it...

Thanks,

-Jason
