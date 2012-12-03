Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754701Ab2LCCF0 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Dec 2012 21:05:26 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:62851 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754359Ab2LCCFZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Dec 2012 21:05:25 -0500
X-IronPort-AV: E=Sophos;i="4.83,359,1352044800"; 
   d="scan'208";a="6317664"
Message-ID: <50BC08D0.5070006@cn.fujitsu.com>
Date: Mon, 03 Dec 2012 10:05:04 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: cavokz@gmail.com
CC: akpm@linux-foundation.org, viro@zeniv.linux.org.uk, bcrl@kvack.org,
        kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz, hughd@google.com,
        cl@linux.com, mgorman@suse.de, minchan@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com,
        wency@cn.fujitsu.com, tangchen@cn.fujitsu.com,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG REPORT] [mm-hotplug, aio] aio ring_pages can't be offlined
References: <1354172098-5691-1-git-send-email-linfeng@cn.fujitsu.com> <20121130152421.GA19849@glitch>
In-Reply-To: <20121130152421.GA19849@glitch>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/03 10:04:48,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/12/03 10:04:49,
	Serialize complete at 2012/12/03 10:04:49
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

hi Domenico,

Sorry for my late reply and thanks for your attention, see below :)

On 11/30/2012 11:24 PM, Domenico Andreoli wrote:
> On Thu, Nov 29, 2012 at 02:54:58PM +0800, Lin Feng wrote:
>> Hi all,
> 
> Hi Lin,
> 
>> We encounter a "Resource temporarily unavailable" fail while trying
>> to offline a memory section in a movable zone. We found that there are 
>> some pages can't be migrated. The offline operation fails in function 
>> migrate_page_move_mapping() returning -EAGAIN till timeout because 
>> the if assertion 'page_count(page) != 1' fails.
> 
> is this something that worked before? if yes (then it's a regression)
> do you know with which kernel?

I think it's a problem exist long ago since we got the offline feature,
while I'm not sure from which version :)

It can only be reproduce by a zone-movable configured system holding 
pages allocated by get_user_pages() for a long time. 

Maybe we could also reproduce it by write a app just calls io_setup()
syscall and never release until it dies.  Then locate the memory section 
from which pages are allocated and try to offline it.
 
In fact if one doesn't want to use offline/hotplug memory feature, 
to whom it's not a bug :)

Thanks,
linfeng
> 
> Thanks,
> Domenico
> 
