Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030496Ab2CABfj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 Feb 2012 20:35:39 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62987 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752905Ab2CABfh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 Feb 2012 20:35:37 -0500
Message-ID: <4F4ED317.2090404@cn.fujitsu.com>
Date: Thu, 01 Mar 2012 09:38:31 +0800
From: Li Zefan <lizf@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc14 Thunderbird/3.1.4
MIME-Version: 1.0
To: Johannes Weiner <hannes@cmpxchg.org>
CC: Konstantin Khlebnikov <khlebnikov@openvz.org>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Michal Hocko <mhocko@suse.cz>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 1/2] kernel: cgroup: push rcu read locking from css_is_ancestor()
 to callsite
References: <1330438489-21909-1-git-send-email-hannes@cmpxchg.org>
In-Reply-To: <1330438489-21909-1-git-send-email-hannes@cmpxchg.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-01 09:33:43,
	Serialize by Router on mailserver/fnst(Release 8.5.1FP4|July 25, 2010) at
 2012-03-01 09:33:47,
	Serialize complete at 2012-03-01 09:33:47
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Johannes Weiner wrote:
> Library functions should not grab locks when the callsites can do it,
> even if the lock nests like the rcu read-side lock does.
> 
> Push the rcu_read_lock() from css_is_ancestor() to its single user,
> mem_cgroup_same_or_subtree() in preparation for another user that may
> already hold the rcu read-side lock.
> 
> Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Li Zefan <lizf@cn.fujitsu.com>
