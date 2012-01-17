Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754711Ab2AQOit (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 09:38:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44898 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754559Ab2AQOis (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 09:38:48 -0500
Message-ID: <1326811122.2937.4.camel@localhost>
Subject: Re: [GIT] Security updates for 3.3: SELinux
From: Eric Paris <eparis@redhat.com>
To: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Cc: James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        w41ter@gmail.com
Date: Tue, 17 Jan 2012 09:38:42 -0500
In-Reply-To: <12887.1326810483@jrobl>
References: <alpine.LRH.2.00.1201151322240.1430@tundra.namei.org>
	 <12887.1326810483@jrobl>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-01-17 at 23:28 +0900, J. R. Okajima wrote:
> James Morris:
> > Eric Paris (12):
> 	:::
> >       capabitlies: ns_capable can use the cap helpers rather than lsm call
> 
> After this commit, I am afraid access(2) on NFS may not work correctly.
> The scenario based upon my guess.
> - access(2) overrides the credentials.
> - calls inode_permission() -- ... -- generic_permission() --
>   ns_capable().
> - while the old ns_capable() calls security_capable(current_cred()), the
>   new ns_capable() calls has_ns_capability(current) --
>   security_capable(__task_cred(t)).
> 
> current_cred() returns current->cred which is effective (overridden)
> credentials, but __task_cred(current) returns current->real_cred (the
> NFSD's credential). And the overridden credentials by access(2) lost.
> 
> Is my guess correct?

Linus please revert d2a7009f0bb03fa22ad08dd25472efa0568126b9

Your explanation seems plausible.  I will review the rest and make sure
a similar problem was not introduced elsewhere.

-Eric

