Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755421Ab2K3DmY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 22:42:24 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60089 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1752595Ab2K3DmX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 22:42:23 -0500
X-IronPort-AV: E=Sophos;i="4.83,346,1352044800"; 
   d="scan'208";a="6303958"
Message-ID: <50B82B0D.8010206@cn.fujitsu.com>
Date: Fri, 30 Nov 2012 11:42:05 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: viro@zeniv.linux.org.uk, bcrl@kvack.org, kamezawa.hiroyu@jp.fujitsu.com,
        mhocko@suse.cz, hughd@google.com, cl@linux.com, mgorman@suse.de,
        minchan@kernel.org, isimatu.yasuaki@jp.fujitsu.com,
        laijs@cn.fujitsu.com, wency@cn.fujitsu.com, tangchen@cn.fujitsu.com,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG REPORT] [mm-hotplug, aio] aio ring_pages can't be offlined
References: <1354172098-5691-1-git-send-email-linfeng@cn.fujitsu.com> <20121129153930.477e9709.akpm@linux-foundation.org>
In-Reply-To: <20121129153930.477e9709.akpm@linux-foundation.org>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/30 11:41:51,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/30 11:41:52,
	Serialize complete at 2012/11/30 11:41:52
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Andrew,

On 11/30/2012 07:39 AM, Andrew Morton wrote:
> Tricky.
> 
> I expect the same problem would occur with pages which are under
> O_DIRECT I/O.  Obviously O_DIRECT pages won't be pinned for such long
> periods, but the durations could still be lengthy (seconds).
the offline retry timeout duration is 2 minutes, so to O_DIRECT pages 
seem maybe not a problem for the moment.
> 
> Worse is a futex page, which could easily remain pinned indefinitely.
> 
> The best I can think of is to make changes in or around
> get_user_pages(), to steal the pages from userspace and replace them
> with non-movable ones before pinning them.  The performance cost of
> something like this would surely be unacceptable for direct-io, but
> maybe OK for the aio ring and futexes.
thanks for your advice.
I want to limit the impact as little as possible, as mentioned above,
direct-io seems not a problem, we needn't touch them. Maybe we can 
just change the use of get_user_pages()(in or around) such as aio 
ring pages. I will try to find a way to do this.

Thanks,
linfeng
