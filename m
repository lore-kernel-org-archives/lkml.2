Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756534Ab2I1BsL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Sep 2012 21:48:11 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:51774 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1756054Ab2I1BsJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Sep 2012 21:48:09 -0400
X-IronPort-AV: E=Sophos;i="4.80,499,1344182400"; 
   d="scan'208";a="5930470"
Message-ID: <50650330.6000006@cn.fujitsu.com>
Date: Fri, 28 Sep 2012 09:53:52 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: linux-mm@kvack.org, linux-kernel@vger.kernel.org, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, minchan.kim@gmail.com, akpm@linux-foundation.org,
        isimatu.yasuaki@jp.fujitsu.com
Subject: Re: [PATCH 3/4] memory-hotplug: clear hwpoisoned flag when onlining
 pages
References: <1348724705-23779-1-git-send-email-wency@cn.fujitsu.com> <1348724705-23779-4-git-send-email-wency@cn.fujitsu.com> <CAHGf_=qhBSvOgStSgmcKZY8qMyj_Fp=3RLMD08YM8F9NzuY28Q@mail.gmail.com>
In-Reply-To: <CAHGf_=qhBSvOgStSgmcKZY8qMyj_Fp=3RLMD08YM8F9NzuY28Q@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/28 09:48:17,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/09/28 09:48:18,
	Serialize complete at 2012/09/28 09:48:18
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 09/28/2012 04:17 AM, KOSAKI Motohiro Wrote:
> On Thu, Sep 27, 2012 at 1:45 AM,  <wency@cn.fujitsu.com> wrote:
>> From: Wen Congyang <wency@cn.fujitsu.com>
>>
>> hwpoisoned may set when we offline a page by the sysfs interface
>> /sys/devices/system/memory/soft_offline_page or
>> /sys/devices/system/memory/hard_offline_page. If we don't clear
>> this flag when onlining pages, this page can't be freed, and will
>> not in free list. So we can't offline these pages again. So we
>> should clear this flag when onlining pages.
> 
> This seems wrong fix to me.  After offline, memory may or may not
> change with new one. Thus we can't assume any memory status. Thus,
> we should just forget hwpoison status at _offline_ event.
> 

Yes, agree with you. I will update this patch.

Thanks for reviewing.

Wen Congyang

