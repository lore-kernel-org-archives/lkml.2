Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab3AIOsE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 09:48:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:50619 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932076Ab3AIOsC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 09:48:02 -0500
Date: Wed, 9 Jan 2013 15:47:58 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Sha Zhengju <handai.szj@gmail.com>
Cc: Hugh Dickins <hughd@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
        akpm@linux-foundation.org, kamezawa.hiroyu@jp.fujitsu.com,
        gthelen@google.com, fengguang.wu@intel.com, glommer@parallels.com,
        dchinner@redhat.com, Sha Zhengju <handai.szj@taobao.com>
Subject: Re: [PATCH V3 4/8] memcg: add per cgroup dirty pages accounting
Message-ID: <20130109144758.GC5095@dhcp22.suse.cz>
References: <1356455919-14445-1-git-send-email-handai.szj@taobao.com>
 <1356456367-14660-1-git-send-email-handai.szj@taobao.com>
 <20130102104421.GC22160@dhcp22.suse.cz>
 <CAFj3OHXKyMO3gwghiBAmbowvqko-JqLtKroX2kzin1rk=q9tZg@mail.gmail.com>
 <alpine.LNX.2.00.1301061135400.29149@eggly.anvils>
 <CAFj3OHVUx0bZyEGQU_CApVbgz7SrX3BQ+0U5fRV=En800wv+cQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFj3OHVUx0bZyEGQU_CApVbgz7SrX3BQ+0U5fRV=En800wv+cQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 09-01-13 22:35:12, Sha Zhengju wrote:
[...]
> To my knowledge, each task is forked in root memcg, and there's a
> moving while attaching it to a cgroup. So move_account is also a
> frequent behavior to some extent.

Not really. Every fork/exec is copies the current group (see
cgroup_fork) so there is no moving on that path.
[...]
-- 
Michal Hocko
SUSE Labs
