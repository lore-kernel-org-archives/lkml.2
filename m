Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754160Ab2K3DkD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 22:40:03 -0500
Received: from cn.fujitsu.com ([222.73.24.84]:60187 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753986Ab2K3Dj7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 22:39:59 -0500
X-IronPort-AV: E=Sophos;i="4.83,346,1352044800"; 
   d="scan'208";a="6303939"
Message-ID: <50B82A7C.8020202@cn.fujitsu.com>
Date: Fri, 30 Nov 2012 11:39:40 +0800
From: Lin Feng <linfeng@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:15.0) Gecko/20120911 Thunderbird/15.0.1
MIME-Version: 1.0
To: Zach Brown <zab@zabbo.net>
CC: Andrew Morton <akpm@linux-foundation.org>, viro@zeniv.linux.org.uk,
        bcrl@kvack.org, kamezawa.hiroyu@jp.fujitsu.com, mhocko@suse.cz,
        hughd@google.com, cl@linux.com, mgorman@suse.de, minchan@kernel.org,
        isimatu.yasuaki@jp.fujitsu.com, laijs@cn.fujitsu.com,
        wency@cn.fujitsu.com, tangchen@cn.fujitsu.com,
        linux-fsdevel@vger.kernel.org, linux-aio@kvack.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [BUG REPORT] [mm-hotplug, aio] aio ring_pages can't be offlined
References: <1354172098-5691-1-git-send-email-linfeng@cn.fujitsu.com> <20121129153930.477e9709.akpm@linux-foundation.org> <20121130000443.GK18574@lenny.home.zabbo.net>
In-Reply-To: <20121130000443.GK18574@lenny.home.zabbo.net>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/30 11:39:26,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/11/30 11:39:27
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Zach,

Thanks for your advice. So agree, I will look into it to lead aio 
to use non-movable pages.


Thanks,
linfeng
On 11/30/2012 08:04 AM, Zach Brown wrote:
>> The best I can think of is to make changes in or around
>> get_user_pages(), to steal the pages from userspace and replace them
>> with non-movable ones before pinning them.  The performance cost of
>> something like this would surely be unacceptable for direct-io, but
>> maybe OK for the aio ring and futexes.
> 
> In the aio case it seems like it could be taught to populate the mapping
> with non-movable pages to begin with.  It's calling get_user_pages() a
> few lines after instantiating the mapping itself with do_mmap_pgoff().
> 
> - z
> 

-- 
--------------------------------------------------
Lin Feng
Development Dept.I
Nanjing Fujitsu Nanda Software Tech. Co., Ltd.(FNST) No. 6 Wenzhu Road,
Nanjing, 210012, China
PHONE：+86-25-86630566-8557 
COINS：7998-8557 
FAX：+86-25-83317685
MAIL：linfeng@cn.fujitsu.com
--------------------------------------------------
