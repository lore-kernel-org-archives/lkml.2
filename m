Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753218Ab1EOT4s (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 May 2011 15:56:48 -0400
Received: from smtp-out.google.com ([216.239.44.51]:13130 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab1EOT4q convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 May 2011 15:56:46 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=xgrDP/gEc8QINwMfkn2AxbLSXQQE5WqhpzlLszhbsx5Gto7IF0w7RF3WfiFetQXq60
         X9l1htKQMkov0enijZSg==
MIME-Version: 1.0
In-Reply-To: <20110513190458.ddc0fbe2.kamezawa.hiroyu@jp.fujitsu.com>
References: <1305276473-14780-1-git-send-email-gthelen@google.com>
 <1305276473-14780-12-git-send-email-gthelen@google.com> <20110513190458.ddc0fbe2.kamezawa.hiroyu@jp.fujitsu.com>
From: Greg Thelen <gthelen@google.com>
Date: Sun, 15 May 2011 12:56:24 -0700
Message-ID: <BANLkTim_Ur_9T2qW5UauuiPCLErMpp3cBQ@mail.gmail.com>
Subject: Re: [RFC][PATCH v7 11/14] memcg: create support routines for writeback
To: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, containers@lists.osdl.org,
        linux-fsdevel@vger.kernel.org, Andrea Righi <arighi@develer.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Daisuke Nishimura <nishimura@mxp.nes.nec.co.jp>,
        Minchan Kim <minchan.kim@gmail.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Ciju Rajan K <ciju@linux.vnet.ibm.com>,
        David Rientjes <rientjes@google.com>,
        Wu Fengguang <fengguang.wu@intel.com>, Vivek Goyal <vgoyal@redhat.com>,
        Dave Chinner <david@fromorbit.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 3:04 AM, KAMEZAWA Hiroyuki
<kamezawa.hiroyu@jp.fujitsu.com> wrote:
> On Fri, 13 May 2011 01:47:50 -0700
> Greg Thelen <gthelen@google.com> wrote:
>
>> Introduce memcg routines to assist in per-memcg writeback:
>>
>> - mem_cgroups_over_bground_dirty_thresh() determines if any cgroups need
>>   writeback because they are over their dirty memory threshold.
>>
>> - should_writeback_mem_cgroup_inode() determines if an inode is
>>   contributing pages to an over-limit memcg.
>>
>> - mem_cgroup_writeback_done() is used periodically during writeback to
>>   update memcg writeback data.
>>
>> Signed-off-by: Greg Thelen <gthelen@google.com>
>
> Reviewed-by: KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
>
> I'm okay with the bitmap..then, problem will be when set/clear wbc->for_cgroup...

wbc->for_cgroup is only set in two conditions:

a) when mem_cgroup_balance_dirty_pages() is trying to get a cgroup
below its dirty memory foreground threshold.  This is in patch 12/14.

b) when bdi-flusher is performing background writeback and determines
that at any of the cgroup are over their respective background dirty
memory threshold.  This is in patch 13/14.
