Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754429Ab2AQO2I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jan 2012 09:28:08 -0500
Received: from mail03-md.ns.itscom.net ([175.177.155.113]:48472 "EHLO
	mail03-md.ns.itscom.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754354Ab2AQO2H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jan 2012 09:28:07 -0500
From: "J. R. Okajima" <hooanon05@yahoo.co.jp>
Subject: Re: [GIT] Security updates for 3.3: SELinux
To: James Morris <jmorris@namei.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Eric Paris <eparis@redhat.com>, linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org
In-Reply-To: <alpine.LRH.2.00.1201151322240.1430@tundra.namei.org>
References: <alpine.LRH.2.00.1201151322240.1430@tundra.namei.org>
Date: Tue, 17 Jan 2012 23:28:03 +0900
Message-ID: <12887.1326810483@jrobl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


James Morris:
> Eric Paris (12):
	:::
>       capabitlies: ns_capable can use the cap helpers rather than lsm call

After this commit, I am afraid access(2) on NFS may not work correctly.
The scenario based upon my guess.
- access(2) overrides the credentials.
- calls inode_permission() -- ... -- generic_permission() --
  ns_capable().
- while the old ns_capable() calls security_capable(current_cred()), the
  new ns_capable() calls has_ns_capability(current) --
  security_capable(__task_cred(t)).

current_cred() returns current->cred which is effective (overridden)
credentials, but __task_cred(current) returns current->real_cred (the
NFSD's credential). And the overridden credentials by access(2) lost.

Is my guess correct?


J. R. Okajima
