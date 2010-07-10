Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754426Ab0GJK4q (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jul 2010 06:56:46 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:45064 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752316Ab0GJK4o (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jul 2010 06:56:44 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:mime-version
         :content-type:content-disposition:user-agent;
        b=ItFyaDsN5/dYwrH2Xwi7L6kigjOhDOYxZDKdPvto4edI4nPbS6zH7qucbQtrPPq6yE
         fEy6wm6iqeBi1Pt6RFoi6nbgyi9QsEEwpoiRjB5vLpBRFKcx/J3VlxkVDp5vxbHALAwL
         KqKOHsdBi/KMxeD3wC5HTu9IvlRwoIXfpT+IM=
Date: Sat, 10 Jul 2010 12:54:29 +0200
From: Dan Carpenter <error27@gmail.com>
To: Paul Menage <menage@google.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>, Andrew Morton <akpm@linux-foundation.org>,
       KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
       Ben Blum <bblum@andrew.cmu.edu>, containers@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: [patch] cgroups: save space for the terminator
Message-ID: <20100710105429.GW19184@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Paul Menage <menage@google.com>, Li Zefan <lizf@cn.fujitsu.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
	Ben Blum <bblum@andrew.cmu.edu>,
	containers@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
	kernel-janitors@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The original code didn't leave enough space for a NULL terminator.
These strings are copied with strcpy() into fixed length buffers in
cgroup_root_from_opts().
 
Signed-off-by: Dan Carpenter <error27@gmail.com>

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 3ac6f5b..a942820 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1102,7 +1102,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 			if (opts->release_agent)
 				return -EINVAL;
 			opts->release_agent =
-				kstrndup(token + 14, PATH_MAX, GFP_KERNEL);
+				kstrndup(token + 14, PATH_MAX - 1, GFP_KERNEL);
 			if (!opts->release_agent)
 				return -ENOMEM;
 		} else if (!strncmp(token, "name=", 5)) {
@@ -1123,7 +1123,7 @@ static int parse_cgroupfs_options(char *data, struct cgroup_sb_opts *opts)
 			if (opts->name)
 				return -EINVAL;
 			opts->name = kstrndup(name,
-					      MAX_CGROUP_ROOT_NAMELEN,
+					      MAX_CGROUP_ROOT_NAMELEN - 1,
 					      GFP_KERNEL);
 			if (!opts->name)
 				return -ENOMEM;
