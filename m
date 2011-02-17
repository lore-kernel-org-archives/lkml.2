Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756046Ab1BQB6e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Feb 2011 20:58:34 -0500
Received: from smtp-out.google.com ([216.239.44.51]:50884 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755497Ab1BQB6b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Feb 2011 20:58:31 -0500
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=from:cc:subject:references:to:date:in-reply-to:message-id:
	user-agent:mime-version:content-type;
	b=uG4NHnA2Ugn84IT/jt2EeMO7jTE709ntwuTyNxWYYFOwntdGhryiOt53vcUo3scgo
	Zq7cyNX2pK4EeNLw/Jaow==
From: Greg Thelen <gthelen@google.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Jiri Kosina <jkosina@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Greg Thelen <gthelen@google.com>
Subject: Re: [PATCH] memcg: clarify use_hierarchy documentation
References: <201102170152.p1H1qKli008601@smtp-out.google.com>
to: Andrew Morton <akpm@linux-foundation.org>
Date: Wed, 16 Feb 2011 17:57:49 -0800
In-Reply-To: <201102170152.p1H1qKli008601@smtp-out.google.com> (Mail Delivery
	Subsystem's message of "Wed, 16 Feb 2011 17:52:20 -0800")
Message-ID: <xr93ei772zj6.fsf@gthelen.mtv.corp.google.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(cc correct linux-mm address)

The memcg code does not allow changing memory.use_hierarchy if the
parent cgroup has enabled use_hierarchy.  Update documentation to match
the code.

Signed-off-by: Greg Thelen <gthelen@google.com>
---
 Documentation/cgroups/memory.txt |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/Documentation/cgroups/memory.txt b/Documentation/cgroups/memory.txt
index 7781857..b6ed61c 100644
--- a/Documentation/cgroups/memory.txt
+++ b/Documentation/cgroups/memory.txt
@@ -485,8 +485,9 @@ The feature can be disabled by
 
 # echo 0 > memory.use_hierarchy
 
-NOTE1: Enabling/disabling will fail if the cgroup already has other
-       cgroups created below it.
+NOTE1: Enabling/disabling will fail if either the cgroup already has other
+       cgroups created below it, or if the parent cgroup has use_hierarchy
+       enabled.
 
 NOTE2: When panic_on_oom is set to "2", the whole system will panic in
        case of an OOM event in any cgroup.
