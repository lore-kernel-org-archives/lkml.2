Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752758Ab1GTGeS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 02:34:18 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:42944 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752219Ab1GTGeR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 02:34:17 -0400
MIME-Version: 1.0
In-Reply-To: <b24894c23d0bb06f849822cb30726b532ea3a4c5.1310732789.git.mhocko@suse.cz>
References: <cover.1310732789.git.mhocko@suse.cz>
	<b24894c23d0bb06f849822cb30726b532ea3a4c5.1310732789.git.mhocko@suse.cz>
Date: Wed, 20 Jul 2011 12:04:17 +0530
Message-ID: <CAKTCnzkiRW3aLwnCYyb9XPfTZWipqcA5Jd7d27rZpecqn3wFuQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] memcg: change memcg_oom_mutex to spinlock
From: Balbir Singh <bsingharora@gmail.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: linux-mm@kvack.org, KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 14, 2011 at 8:59 PM, Michal Hocko <mhocko@suse.cz> wrote:
> memcg_oom_mutex is used to protect memcg OOM path and eventfd interface
> for oom_control. None of the critical sections which it protects sleep
> (eventfd_signal works from atomic context and the rest are simple linked
> list resp. oom_lock atomic operations).
> Mutex is also too heavy weight for those code paths because it triggers
> a lot of scheduling. It also makes makes convoying effects more visible
> when we have a big number of oom killing because we take the lock
> mutliple times during mem_cgroup_handle_oom so we have multiple places
> where many processes can sleep.
>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>

Quick question: How long do we expect this lock to be taken? What
happens under oom? Any tests? Numbers?

Balbir Singh
